require 'test_helper'

class ConfigureMessagesTest < ActionController::IntegrationTest
  def setup

  end

  should "add an admin panel"
  should "not allow non-admins to access the admin panel"
  context "configuring statuses" do
    should "have a matrix of statuses as rows"
    should "have an author column"
    should "have a watcher column"
    should "have an assigned to column"
    should "have a content column"
    should "save the values to the Status Change record"
  end
  
end


