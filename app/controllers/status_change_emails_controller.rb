class StatusChangeEmailsController < ApplicationController
  unloadable
  before_filter :require_admin

  def index
    render :text => 'Welcome'
  end
end
