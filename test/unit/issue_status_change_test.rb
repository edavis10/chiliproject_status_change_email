require 'test_helper'

class IssueStatusChangeTest < ActiveSupport::TestCase
  should_belong_to(:issue_status)
  
  context "#extra_content_for(issue, user)" do
    setup do
      @status = IssueStatus.generate!(:name => "New")
      @author = User.generate!
      @watcher = User.generate!
      @assigned_to = User.generate!

      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project,
                                           :status => @status,
                                           :author => @author,
                                           :assigned_to => @assigned_to)
      @issue.add_watcher(@watcher)
    end
    
    context "for the issue author" do
      should "return the extra_content if the IssueStatusChange#author? option is true" do
        IssueStatusChange.generate!(:issue_status => @status,
                                    :extra_content => 'test',
                                    :author => true)
        
        assert_equal 'test', IssueStatusChange.extra_content_for(@issue, @author)
      end
      
      
      should "return nothing if the IssueStatusChange#author? option is false" do
        IssueStatusChange.generate!(:issue_status => @status,
                                    :extra_content => 'test',
                                    :author => false)
        
        assert_equal nil, IssueStatusChange.extra_content_for(@issue, @author)

      end
      
    end

    context "for an issue watcher" do
      should "return the extra_content if the IssueStatusChange#watcher? option is true" do
        IssueStatusChange.generate!(:issue_status => @status,
                                    :extra_content => 'test',
                                    :watcher => true)
        
        assert_equal 'test', IssueStatusChange.extra_content_for(@issue, @watcher)
      end
      
      should "return nothing if the IssueStatusChange#watcher? option is false" do
        IssueStatusChange.generate!(:issue_status => @status,
                                    :extra_content => 'test',
                                    :watcher => false)
        
        assert_equal nil, IssueStatusChange.extra_content_for(@issue, @watcher)
      end
      
    end

    context "for the issue assignee" do
      should "return the extra_content if the IssueStatusChange#assigned_to? option is true" do
        IssueStatusChange.generate!(:issue_status => @status,
                                    :extra_content => 'test',
                                    :assigned_to => true)
        
        assert_equal 'test', IssueStatusChange.extra_content_for(@issue, @assigned_to)
      end
      
      should "return nothing if the IssueStatusChange#assigned_to? option is false" do
        IssueStatusChange.generate!(:issue_status => @status,
                                    :extra_content => 'test',
                                    :assigned_to => false)
        
        assert_equal nil, IssueStatusChange.extra_content_for(@issue, @assigned_to)
      end
      
    end
  end
  
end

