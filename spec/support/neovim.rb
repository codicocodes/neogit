# frozen_string_literal: true

module NeovimHelper
  def nvim_print_screen
    return if $neovim.nil?

    puts nvim_get_lines
  end

  def nvim_get_lines
    return if $neovim.nil?

    $neovim.current.buffer.get_lines(0, -1, true).join("\n")
  end

  # Low-level user input
  def nvim_input(keys)
    $neovim.input(keys)
  end

  # Higher-level user input
  def nvim_feedkeys(keys, mode: 'm')
    $neovim.feedkeys(
      $neovim.replace_termcodes(keys, true, false, true),
      mode,
      false
    )

    $neovim.feedkeys("", "x", true)
  end
end
