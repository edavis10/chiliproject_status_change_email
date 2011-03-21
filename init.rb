require 'redmine'

Redmine::Plugin.register :chiliproject_status_change_email do
  name 'Status Change Email'
  author 'Eric Davis'
  url "https://projects.littlestreamsoftware.com/projects/chiliproject_status_change_email"
  author_url 'http://www.littlestreamsoftware.com'
  description 'Plugin that adds custom messages to email based on the issue statuses.'
  version '0.1.0'

  requires_redmine :version_or_higher => '1.0.0' # TODO: need the custom per-recipient patch too

  menu(:admin_menu, :status_change_emails, {:controller => 'status_change_emails', :action => 'index'}, :caption => :status_change_email_title)
end

require 'dispatcher'
Dispatcher.to_prepare :chiliproject_status_change_email do

  require_dependency 'issue_status'
  IssueStatus.send(:include, ChiliprojectStatusChangeEmail::Patches::IssueStatusPatch)
end

require 'chiliproject_status_change_email/hooks/view_layouts_mailer_hook'
