module ChiliprojectStatusChangeEmail
  module Patches
    module IssueStatusPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          has_one :issue_status_change
        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end
    end
  end
end
