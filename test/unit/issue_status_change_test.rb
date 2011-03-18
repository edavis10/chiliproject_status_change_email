require 'test_helper'

class IssueStatusChangeTest < ActiveSupport::TestCase
  should "belong_to IssueStatus"

  context "#extra_content_for(issue, user)" do
    context "for the owner" do
      should "return the content if the owner? option is true"
      should "return nothing if the owner? option is false"
    end

    context "for a watcher" do
      should "return the content if the watcher? option is true"
      should "return nothing if the watcher? option is false"
    end

    context "for the assignee" do
      should "return the content if the assigned_to? option is true"
      should "return nothing if the assigned_to? option is false"
    end
  end
  
end
