class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest # 最初のsave前に実行される

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # 大文字と小文字に区別なく一意性を持たせる AAA@co.jp aaa@co.jpは同時登録不可
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # has_secure_passwordと同じ方法で、渡された文字列のハッシュ値を返すメソッド
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    # インスタンスにはtokenを保存
    self.remember_token = User.new_token
    # DBにはハッシュ化したトークンを保存 update_attributeはインスタンスメソッド(ApplcationRecordのメソッド)なのでレシーバー不要
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンとダイジェストの一致
  # tokenにはttoken自体を入れる必要あり ex) token = user1.activation_token
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") #インスタンスを表すselfは省略可能
    return false if digest.nil?
    #  tokenがダイジェストと一致するかどうかのチェック
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ログイン情報の破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    # 有効化トークンとダイジェストを作成および代入する
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end

# user = User.new(name:"akim",email:"akimu@akimu.com",password:"foobar",password_confirmation:"foobar")