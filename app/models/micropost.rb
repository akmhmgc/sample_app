class Micropost < ApplicationRecord
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
end
