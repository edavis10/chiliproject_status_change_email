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

    should "save the values to the Status Change record" do
      within("#status-#{@new_status.id}") do
        check("status-#{@new_status.id}-author")
        check("status-#{@new_status.id}-watcher")
        check("status-#{@new_status.id}-assigned_to")
        fill_in("status-#{@new_status.id}-extra-content", :with => 'New status')
      end

      within("#status-#{@finished_status.id}") do
        uncheck("status-#{@finished_status.id}-author")
        uncheck("status-#{@finished_status.id}-watcher")
        uncheck("status-#{@finished_status.id}-assigned_to")
        fill_in("status-#{@finished_status.id}-extra-content", :with => 'Finished status')
      end

      within("#status-#{@closed_status.id}") do
        check("status-#{@closed_status.id}-author")
        uncheck("status-#{@closed_status.id}-watcher")
        uncheck("status-#{@closed_status.id}-assigned_to")
        fill_in("status-#{@closed_status.id}-extra-content", :with => 'Closed status')
      end

      click_button 'Save'
      assert_response :success

      @new_status.reload
      assert @new_status.issue_status_change
      assert @new_status.issue_status_change.author?
      assert @new_status.issue_status_change.watcher?
      assert @new_status.issue_status_change.assigned_to?
      assert_equal "New status", @new_status.issue_status_change.extra_content

      @finished_status.reload
      assert @finished_status.issue_status_change
      assert !@finished_status.issue_status_change.author?
      assert !@finished_status.issue_status_change.watcher?
      assert !@finished_status.issue_status_change.assigned_to?
      assert_equal "Finished status", @finished_status.issue_status_change.extra_content

      @closed_status.reload
      assert @closed_status.issue_status_change
      assert @closed_status.issue_status_change.author?
      assert !@closed_status.issue_status_change.watcher?
      assert !@closed_status.issue_status_change.assigned_to?
      assert_equal "Closed status", @closed_status.issue_status_change.extra_content

    end
    
  end
  
end


