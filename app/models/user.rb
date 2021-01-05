class User < ApplicationRecord
  # before_save:dbへ保存される直前に実行されるコールバック関数
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # 大文字と小文字に区別なく一意性を持たせる AAA@co.jp aaa@co.jpは同時登録不可
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password,  presence: true,length: { minimum: 6 }
end
