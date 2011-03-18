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
    setup do
      @new_status = IssueStatus.generate!(:name => "New")
      @finished_status = IssueStatus.generate!(:name => "Finished")
      @closed_status = IssueStatus.generate!(:name => "Closed")

      login_as(@user.login, 'test')
      visit_status_change_email_admin_panel
    end
    
    should "have a matrix of statuses as rows" do
      assert find("table#status-change-emails")
      assert find("table#status-change-emails tr#status-#{@new_status.id}")
      assert find("table#status-change-emails tr#status-#{@finished_status.id}")
      assert find("table#status-change-emails tr#status-#{@closed_status.id}")

    end
    
    should "have an author column" do
      assert find("table#status-change-emails th", :text => 'Author')
    end
    
    should "have a watcher column" do
      assert find("table#status-change-emails th", :text => 'Watcher')
    end

    should "have an assigned to column" do
      assert find("table#status-change-emails th", :text => 'Assignee')
    end

    should "have a content column" do
      assert find("table#status-change-emails th", :text => 'Extra content')
    end

    should "save the values to the Status Change record"
  end
  
end


