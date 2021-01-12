require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
 
  def setup
    # fixture file(users.yml)の呼び出し
    @user = users(:michael)
  end

  # 編集失敗時のテスト(自分で作成できた！)
  test "unsuccessful info" do
    log_in_as(@user)
    get edit_user_url(@user)
    # params{user:{name:~}の形が必要（controller内でdebugger回せばわかる）
    patch user_path(@user), params: { user: { name:  "",
      email: "foo@invalid",
      password:              "foo",
      password_confirmation: "bar" } }
      # edit.htmlがレンダーされる
      assert_template 'users/edit'
      
      # エラーメッセージの表示
      assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
