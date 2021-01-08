class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 全てのcontrollerでSessionHelperを使用可能
  include SessionsHelper
end
