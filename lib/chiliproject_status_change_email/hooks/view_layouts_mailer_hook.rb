module ChiliProjectStatusChangeEmail
  module Hooks
    # Hooks into the email layout to add question content
    class ViewLayoutsMailerHook < Redmine::Hook::ViewListener

      include ActionView::Helpers::SanitizeHelper
      extend ActionView::Helpers::SanitizeHelper::ClassMethods
      
      def view_layouts_mailer_html_before_content(context={})
        render_response_string(context, :html)
      end

      def view_layouts_mailer_plain_before_content(context={})
        render_response_string(context, :plain)
      end

      private

      def render_response_string(context, format)
        if context[:issue].present?
          issue = context[:issue]
          current_recipient = context[:recipients].try(:first)
          user = User.find_by_mail(current_recipient)
          extra_content = IssueStatusChange.extra_content_for(issue, user)

          if format == :html
            return textilizable(extra_content, :only_path => false)
          else
            return extra_content
          end
          
        else
          ''
        end

      end
      
    end
  end
end
