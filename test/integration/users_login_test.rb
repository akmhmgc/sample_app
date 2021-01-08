require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    # model専用のfixture fileは自動的にモデルに使用されるクラスになる(User class)
    @user = users(:michael)
  end

  test "login with invalid information" do

    # login URLに遷移
    get login_path
    
    # 間違ったログイン情報をPOST(flashが返ってくるはず)
    post login_path, params: { session: { email: "", password: "" } }
    
    # 求めているのは一度ページが遷移すると、flashが消えている状態
    # post後のテンプレート確認 > flash? > ページ遷移 > flash?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    # logout
    delete logout_path
    assert_not is_logged_in?
    # destroyアクションの中でリダイレクトが指定されているの
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

end