require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
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
end
