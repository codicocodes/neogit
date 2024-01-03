# frozen_string_literal: true

class NeovimClient
  def initialize
    @instance = nil
  end

  def setup
    @instance = attach_child

    # Sets up the runtimepath
    lua "vim.opt.runtimepath:append('#{PROJECT_DIR}')"
    runtime_dependencies.each do |dep|
      lua "vim.opt.runtimepath:append('#{dep}')"
    end

    lua <<~LUA
      require('neogit').setup()
      require('neogit').open()
    LUA

    sleep(0.025) # Seems to be about right
  end

  def print_screen
    puts get_lines
  end

  def lua(code)
    @instance.exec_lua(code, [])
  end

  def get_lines
    @instance.current.buffer.get_lines(0, -1, true).join("\n")
  end

  # Overload vim.fn.input() to prevent blocking.
  def input(*args)
    lua <<~LUA
      local inputs = { #{args.map(&:inspect).join(",")} }

      vim.fn.input = function()
        return table.remove(inputs, 1)
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

  def attach_child
    Neovim.attach_child(["nvim", "--embed", "--clean", "--headless"])
  end

  def runtime_dependencies
    Dir[File.join(PROJECT_DIR, "tmp", "*")].select { Dir.exist? _1 }
  end
end
