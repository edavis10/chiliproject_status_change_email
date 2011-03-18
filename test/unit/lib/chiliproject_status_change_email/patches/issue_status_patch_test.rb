require File.dirname(__FILE__) + '/../../../../test_helper'

class ChiliprojectStatusChangeEmail::Patches::IssueStatusTest < ActionController::TestCase
  subject {IssueStatus.new}
  
  context "IssueStatus" do
    should_have_one(:issue_status_change)
  end
  
end
