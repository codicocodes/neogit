# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Branch Popup", :git, :nvim do
  describe "Variables" do
    describe "branch.<current>.description" do
      it "can edit branch description"
    end

    describe "branch.<current>.{merge,remote}" do
      it "can set the upstream for current branch"
    end

    describe "branch.<current>.rebase" do
      it "can change rebase setting"
    end

    describe "branch.<current>.pushRemote" do
      it "can change pushRemote for current branch"
    end
  end

  describe "Actions" do
    describe "Checkout branch/revision" do
      it "can checkout a local branch"
    end

    describe "Checkout local branch" do
      it "can checkout a local branch"
    end

    describe "Checkout recent branch" do
      it "can checkout a local branch"
    end

    describe "Checkout new branch" do
      it "can create and checkout a branch" do
        nvim.input("new branch")
        nvim.feedkeys("bc")
        nvim.feedkeys("master<cr>")

        expect(git.current_branch).to eq "new-branch"
      end
    end
  end

  describe "Checkout new spin-off" do
    it "can create and checkout a spin-off branch"
  end

  describe "Checkout new worktree" do
    it "can create and checkout a worktree"
  end

  describe "Create new branch" do
    it "can create a new branch"
  end

  describe "Create new spin-off" do
    it "can create a new spin-off"
  end

  describe "Create new worktree" do
    it "can create a new worktree"
  end

  describe "Configure" do
    it "Launches the configuration popup"
  end

  describe "Rename" do
    it "can rename a branch"
  end

  describe "reset" do
    it "can reset a branch"
  end

  describe "delete" do
    it "can delete a branch"
  end
end
