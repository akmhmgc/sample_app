require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest 
  def setup
    # fixture file(users.yml)の呼び出し
    @user = users(:michael)
  end
  
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    # ? = root_pathを持つlinkが存在するかのチェック
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    get contact_path
    # test helplerでapplication helperモジュールを呼びだしてから使用
    assert_select "title", full_title("Contact")

    # signup
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "successful users links " do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'

    # 全てのuserのリンクがあることを確認
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "unsuccessful users links " do
    get users_path
    assert_redirected_to login_url
  end
end
