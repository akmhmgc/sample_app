ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase # 全てのテストで使用可能
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

  # テストユーザーとしてログインする いつ必要になるのか不明
  def log_in_as(user)
    session[:user_id] = user.id
  end
  
end

#integration test用のクラス
# ActiveSupport::Testcaseを継承している
class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする メソッドのダックインが行われている
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end