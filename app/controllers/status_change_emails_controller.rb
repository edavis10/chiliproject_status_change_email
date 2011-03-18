class StatusChangeEmailsController < ApplicationController
  unloadable
  before_filter :require_admin

  def index
    @issue_statuses = IssueStatus.all(:order => 'position ASC')
  end

  def update
    @issue_statuses = IssueStatus.all(:order => 'position ASC', :include => :issue_status_change)
    @issue_statuses.each do |issue_status|
      if issue_status.issue_status_change.present?
        issue_status_change = issue_status.issue_status_change
      else
        issue_status_change = issue_status.build_issue_status_change
      end

      if params["status-#{issue_status.id}"].present?
        issue_status_change.attributes = params["status-#{issue_status.id}"].reverse_merge(IssueStatusChange.default_attributes)
        issue_status_change.save
      else
        # Not in params, destroy
        issue_status_change.destory unless issue_status_change.new_record?
      end
      
    end
    
    flash[:notice] = l(:notice_successful_update)
    redirect_to :action => 'index'
  end
  
end
