require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user1 = users(:archer)
    @other_user2 = users(:lana)
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.length} microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 無効な送信
    post microposts_path, params: { micropost: { content: "" } }
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost:
                                      { content: content,
                                        picture: picture } }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセスする
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end

  test "sender and recipient only see reply feed" do
    log_in_as(@user)
    get root_path
    content = "@"+"#{@other_user1.personal_id} You are the best!!"
    post microposts_path, params: { micropost:
      { content: content} }
    # 自分自身が返したreplyは見られる
    follow_redirect!
    assert_match CGI.escapeHTML(content), response.body

    # user1から見られる
    delete logout_path
    log_in_as(@other_user1)
    get root_path
    assert_match CGI.escapeHTML(content), response.body

    # user2からは見えない
    delete logout_path
    log_in_as(@other_user2)
    get root_path
    assert_no_match CGI.escapeHTML(content), response.body
  end
end