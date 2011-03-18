class IssueStatusChange < ActiveRecord::Base
  unloadable

  belongs_to :issue_status
end
