class IssueStatusChange < ActiveRecord::Base
  unloadable

  belongs_to :issue_status

  def self.default_attributes
    {
      "assigned_to" => "0",
      "author" => "0",
      "watcher" => "0"
    }
  end

  # Finds the extra_content based on the issue's current status and
  # if the user is supposed to see anything.
  def self.extra_content_for(issue, user)
    return nil unless issue.status.present?

    issue_status_change = issue.status.issue_status_change
    return nil unless issue_status_change.present?

    if issue_status_change.author? && issue.author == user
      return issue_status_change.extra_content
    end

    if issue_status_change.assigned_to? && issue.assigned_to == user
      return issue_status_change.extra_content
    end

    if issue_status_change.watcher? && issue.watched_by?(user)
      return issue_status_change.extra_content
    end

    return nil
  end

  # object_daddy defaults for testing
  if Rails.env.test?
    generator_for :author => false
    generator_for :watcher => false
    generator_for :assigned_to => false
    generator_for :extra_content => 'Generated'
  end
end
