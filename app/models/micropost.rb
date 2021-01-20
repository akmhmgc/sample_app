class Micropost < ApplicationRecord
  before_save :add_reply_to
  belongs_to :user
  # データベースを取得した時のデフォルトの順序
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # ファイルサイズに関するvalidationは存在しないのでメソッドを作成
  validate  :picture_size
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  # スコープの使用
  def self.including_replies(replied_user)
    where("in_reply_to is null OR in_reply_to = ?", replied_user)
  end

  private
  # contentから自動でin_reply_toを作成するメソッド作成
  def add_reply_to
    #
    # self.in_reply_to = content.match(/@[a-zA-Z0-9]+/)
    # "@user you are cool!!".scan(/(@)([a-zA-Z0-9]+)/)[0][1] => "user"
    content_array = content.scan(/(@)([a-zA-Z0-9]+)/)
    self.in_reply_to = content_array[0][1] unless content_array.empty?
  end

end