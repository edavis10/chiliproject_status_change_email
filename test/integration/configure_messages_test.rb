require 'test_helper'

class ConfigureMessagesTest < ActionController::IntegrationTest
  def setup
    @user = User.generate!(:password => 'test', :password_confirmation => 'test', :admin => true)
  end

  should "add an admin panel" do
    login_as(@user.login, 'test')
    visit_home
    click_link 'Administration'
    assert_response :success

    assert find('#admin-menu a.status-change-emails')
    click_link 'Status Change Email'
    assert_response :success
  end
  
  should "not allow non-admins to access the admin panel" do
    @non_admin = User.generate!(:password => 'test', :password_confirmation => 'test', :admin => false)
    login_as(@non_admin.login, 'test')

    assert has_no_content?('Administration')
    visit '/status_change_emails'
    assert_response :forbidden
  end
  
  context "configuring statuses" do
    should "have a matrix of statuses as rows"
    should "have an author column"
    should "have a watcher column"
    should "have an assigned to column"
    should "have a content column"
    should "save the values to the Status Change record"
  end
  
end


