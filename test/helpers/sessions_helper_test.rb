require "test_helper"

class SessionsHelperTest < ActionView::TestCase
  test "full title helper" do
    assert session[:user_id].nil?
    assert_equal current_user,         nil
  end
end
