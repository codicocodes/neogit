# frozen_string_literal: true

require "tmpdir"
require "git"
require "neovim"
require "debug"

PROJECT_DIR = File.expand_path(File.join(__dir__, ".."))

Dir[File.join(File.expand_path("."), "spec", "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true
  config.profile_examples = 10
  config.order = :random

  config.around(:each) do |example|
    Dir.mktmpdir do |tmp|
      Dir.chdir(tmp) do
        example.run
      end
    end
  end

  config.around(:each) do |example|
    if example.metadata[:git]
      system("touch testfile")

      @repo = Git.init
      @repo.config("user.email", "test@example.com")
      @repo.config("user.name", "tester")
      @repo.add("testfile")
      @repo.commit("Initial commit")
    end

    if example.metadata[:neovim]
      $neovim = Neovim.attach_child(
        [
          { "NEOGIT_LOG_FILE" => "true", "NEOGIT_LOG_LEVEL" => "debug" },
          "nvim",
          "--embed",
          "--clean",
          "--headless",
          # "-c set rtp^=#{PROJECT_DIR},#{dependencies}",
          # "-c lua require('neogit').setup({})"
        ]
      )

      $neovim.exec_lua("vim.opt.runtimepath:append('#{PROJECT_DIR}')", [])

      dependencies = Dir[File.join(PROJECT_DIR, "tmp", "*")].select { Dir.exist? _1 }
      dependencies.each do |dep|
        $neovim.exec_lua("vim.opt.runtimepath:append('#{dep}')", [])
      end

      $neovim.exec_lua("require('neogit').setup()", [])
      $neovim.exec_lua("require('neogit').open()", [])
      # $neovim.cmd({cmd: "Neogit"}, {output: true })
      # $neovim.cmd("lua require('neogit').open()")
    end

    example.run
  end
end
