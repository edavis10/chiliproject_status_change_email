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
end
