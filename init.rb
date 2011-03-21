require 'redmine'

Redmine::Plugin.register :chiliproject_status_change_email do
  name 'Redmine Status Change Email plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  menu(:admin_menu, :status_change_emails, {:controller => 'status_change_emails', :action => 'index'}, :caption => :status_change_email_title)
end

require 'dispatcher'
Dispatcher.to_prepare :chiliproject_status_change_email do

  require_dependency 'issue_status'
  IssueStatus.send(:include, ChiliprojectStatusChangeEmail::Patches::IssueStatusPatch)
end

require 'chiliproject_status_change_email/hooks/view_layouts_mailer_hook'
