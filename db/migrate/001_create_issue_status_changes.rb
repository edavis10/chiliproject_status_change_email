class CreateIssueStatusChanges < ActiveRecord::Migration
  def self.up
    create_table :issue_status_changes do |t|
      t.references :issue_status
      t.boolean :author
      t.boolean :watcher
      t.boolean :assigned_to
      t.text :extra_content
    end
    
  end

  def self.down
    drop_table :issue_status_changes
  end
end
