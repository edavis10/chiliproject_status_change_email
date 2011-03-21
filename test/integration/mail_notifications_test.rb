require 'test_helper'

class MailNotificationsTest < ActionController::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @status = IssueStatus.generate!(:name => "New")
    @project = Project.generate!

    @author = User.generate!
    @watcher = User.generate!
    @assigned_to = User.generate!
    @editor = User.generate!(:password => 'test', :password_confirmation => 'test')
    @role = Role.generate!(:permissions => [:view_issues, :edit_issues, :add_issue_notes])
    User.add_to_project(@author, @project, @role)
    User.add_to_project(@watcher, @project, @role)
    User.add_to_project(@assigned_to, @project, @role)
    User.add_to_project(@editor, @project, @role)
    
    @issue = Issue.generate_for_project!(@project,
                                         :status => @status,
                                         :author => @author,
                                         :assigned_to => @assigned_to)
    @issue.add_watcher(@watcher)

  end

  def edit_issue
    login_as(@editor.login, 'test')
    visit_issue_page(@issue)
    fill_in "notes", :with => 'New note'
    assert_difference('Journal.count') do
      click_button 'Submit'
      assert_response :success
    end
  end

  context "Issue notifications" do
    context "to a user who gets the additional content" do
      context "with status change content" do
        setup do
          @issue_status_change = IssueStatusChange.generate!(:issue_status => @status,
                                                             :extra_content => '_This is extra content_',
                                                             :author => true)
        end

        should "include the content in the plain text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@author.mail) &&
              email.body.match('_This is extra content_')
          end
          
        end
        
        should "include the content in the html text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@author.mail) &&
              email.body.match('<em>This is extra content</em>')
          end
          
        end

        should "allow full textile in the extra_content without throwing errors" do
          @issue_status_change.extra_content = 'h3. A Header which triggers strip_tags'
          @issue_status_change.save

          edit_issue
          assert_sent_email do |email|
            email.to.include?(@author.mail) &&
              email.body.match('h3. A Header which triggers strip_tags') # Can't test the HTML version easily
          end
          
        end
        
      end

      context "with no status change content" do
        setup do
          IssueStatusChange.destroy_all
        end
        
        should "not include the content in the plain text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@author.mail) &&
              !email.body.match('This is extra content')
          end

        end
        
        should "not include the content in the html text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@author.mail) &&
              !email.body.match('This is extra content')
          end

        end
      end
    end

    context "to a user who doesn't get the additional content" do
      context "with status change content" do
        setup do
          IssueStatusChange.generate!(:issue_status => @status,
                                      :extra_content => '_This is extra content_',
                                      :author => true)
        end

        should "not include the content in the plain text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@assigned_to.mail) &&
              !email.body.match('This is extra content')
          end

        end
        
        should "not include the content in the html text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@assigned_to.mail) &&
              !email.body.match('This is extra content')
          end
        end
        
      end

      context "with no status change content" do
        setup do
          IssueStatusChange.destroy_all
        end

        should "not include the content in the plain text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@assigned_to.mail) &&
              !email.body.match('This is extra content')
          end
        end
        
        should "not include the content in the html text email" do
          edit_issue
          assert_sent_email do |email|
            email.to.include?(@assigned_to.mail) &&
              !email.body.match('This is extra content')
          end
        end
        
      end
    end
  end
end
  
    
