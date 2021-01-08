ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...  
  include ApplicationHelper

  # SessionsHelperも使用可能に
  # include SessionsHelper
  def is_logged_in?
    # loginした時点でsession[:id]は空でなくなるので判定
    !session[:user_id].nil?
  end

end
