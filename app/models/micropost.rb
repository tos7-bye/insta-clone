class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum:140}
  validates :image, content_type: { in: %w[image/jpeg image/png],
                                message: "must be a valid image format" },
                                size:         { less_than: 5.megabytes,
                                message: "should be less than 5MB" }

  # 表示用のリサイズ済み画像を返す(home)
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  # 表示用のリサイズ済み画像を返す(users/show)
  def display_thum
    image.variant(resize_to_fill: [200, 200])
  end

  # いいねしていればtrueを返す
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # いいね通知
  def create_notification_like(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and micropost_id = ? and action = ? ",
                                current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        micropost_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメント通知
  def create_notification_comment(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do | temp_id | 
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
  end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  # コメント通知
  def save_notification_comment(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def self.search(search)
    Micropost.all if search.blank?
    Micropost.where(['content LIKE ?', "%#{search}%"])
  end
end
