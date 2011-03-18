require 'test_helper'

class MailNotificationsTest < ActionController::IntegrationTest
  def setup

  end

  context "Issue notifications" do
    context "to a user who gets the additional content" do
      context "with status change content" do
        should "include the content in the plain text email"
        should "include the content in the html text email"
      end

      context "with no status change content" do
        should "not include the content in the plain text email"
        should "not include the content in the html text email"
      end
    end

    context "to a user who doesn't get the additional content" do
      context "with status change content" do
        should "not include the content in the plain text email"
        should "not include the content in the html text email"
      end

      context "with no status change content" do
        should "not include the content in the plain text email"
        should "not include the content in the html text email"
      end
    end
  end
end
  
    
