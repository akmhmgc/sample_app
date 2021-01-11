require "test_helper"

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  # test "full title helper" do
  #   assert session[:user_id].nil?
  #   assert_equal current_user,         nil
  # end

  # sessionは存在していないがrememberでアカウントが保存されている場合のテスト
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    # dbにあるtokenのダイジェストを変更し => current_userがnilを返すかのテスト
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end
