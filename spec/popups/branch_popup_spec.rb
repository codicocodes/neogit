# frozen_string_literal: true

require "spec_helper"

# def wait_for_expect
#   last_error = nil
#   success = false
#
#   5.times do
#     begin
#       yield
#       success = true
#       break
#     rescue RSpec::Expectations::ExpectationNotMetError => e
#       last_error = e
#       sleep 0.5
#     end
#   end
#
#   raise last_error if !success && last_error
# end

RSpec.describe "Branch Popup", :neovim do
  let(:repo) { Git.init }
  let(:nvim) { NeovimClient.new }

  before do
    system("touch testfile")

    repo.config("user.email", "test@example.com")
    repo.config("user.name", "tester")
    repo.add("testfile")
    repo.commit("Initial commit")

    nvim.setup
    sleep(1)
  end

  describe "Checkout branch/revision" do
    it "can checkout a local branch"
  end

  describe "Create branch" do
    it "can create and checkout a branch" do
      nvim.input("new branch")
      nvim.feedkeys("bc")
      nvim.feedkeys("master<cr>")

      expect(repo.current_branch).to eq "new-branch"
    end
  end
end
