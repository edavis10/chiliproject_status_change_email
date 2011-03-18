class StatusChangeEmailsController < ApplicationController
  unloadable
  before_filter :require_admin

  def index
    @issue_statuses = IssueStatus.all(:order => 'position ASC')
  end
end
