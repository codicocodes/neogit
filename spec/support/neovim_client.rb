# frozen_string_literal: true

class NeovimClient
  def initialize
    @instance = nil
  end

  def setup
    @instance = Neovim.attach_child(
      [
        { "NEOGIT_LOG_FILE" => "true", "NEOGIT_LOG_LEVEL" => "debug" },
        "nvim",
        "--embed",
        "--clean",
        "--headless",
      ]
    )

    @instance.exec_lua("vim.opt.runtimepath:append('#{PROJECT_DIR}')", [])

    dependencies = Dir[File.join(PROJECT_DIR, "tmp", "*")].select { Dir.exist? _1 }
    dependencies.each do |dep|
      @instance.exec_lua("vim.opt.runtimepath:append('#{dep}')", [])
    end

    @instance.exec_lua("require('neogit').setup()", [])
    @instance.exec_lua("require('neogit').open()", [])
  end

  def print_screen
    return if @instance.nil?

    puts get_lines
  end

  def get_lines
    return if @instance.nil?

    @instance.current.buffer.get_lines(0, -1, true).join("\n")
  end

  # Low-level user input
  def input(keys)
    @instance.exec_lua(<<~LUA, [])
      vim.fn.input = function()
        return "#{keys}"
      end
    LUA
  end

  # Higher-level user input
  def feedkeys(keys, mode: 'm')
    @instance.feedkeys(
      @instance.replace_termcodes(keys, true, false, true),
      mode,
      false
    )

    @instance.feedkeys("", "x", true)
  end
end
