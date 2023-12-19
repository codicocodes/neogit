# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Branch Popup", :git, :neovim do
  include NeovimHelper

  describe "Checkout branch/revision" do
    it "can checkout a local branch"
  end

  describe "Create branch" do
    it "can create and checkout a branch" do
      sleep 1
      nvim_feedkeys("bc")
      sleep 2
      nvim_feedkeys("new branch<cr>")
      sleep 1
      debugger(pre: "info")
      expect(@repo.current_branch).to eq "new-branch"
    end
  end
end
