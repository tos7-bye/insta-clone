module ApplicationHelper
  def full_title(page_title="")
    base_title = 'Insta Clone'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def notification_form(notification)
    @visitor = notification.visitor
    @comment = nil
    your_micropost = link_to 'あなたの投稿', micropost_path(notification), 
                                                                    style:"font-weight: bold;"
    @visitor_comment = notification.comment_id
    #notification.actionがfollowかlikeかcommentか
    case notification.action
      when "follow" then
        tag.a(notification.visitor.name, href: users_path(@visitor),
                                                       style: "font-weight: bold;")
        + "があなたをフォローしました"
      when "like" then
        tag.a(notification.visitor.name, href: users_path(@visitor),
                                          style: "font-weight: bold;")
        + "が" + tag.a('あなたの投稿', href: micropost_path(notification.micropost_id),
                                        style: "font-weight: bold;")
        + "にいいねしました"
      when "comment" then
        @comment = Comment.find_by(id: @visitor_comment)&.content
        tag.a(@visitor.name, href:users_path(@visitor),
                              style:"font-weight: bold;")
        + "が" + tag.a('あなたの投稿', href: micropost_path(notification.micropost_id),
                                        style: "font-weight: bold;")
        + "にコメントしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

  def default_meta_tags
    {
      site: "Insta Clone",
      title: "Insta Clone",
      reverse: true,
      separator: '|',
      description: "Insta Cloneは、コンパクトなSNS機能を備えたアプリです。",
      keywords: "SNS、写真、画像、投稿、共有",
      noindex: ! Rails.env.production?,
      canonical: request.original_url,
      og: {
        site_name: "Insta Clone",
        title: "Insta Clone", 
        description: "Insta Cloneは、コンパクトなSNS機能を備えたアプリです。",
        type: "website",
        url: request.original_url,
        image: "image_url",
        locale: "ja_JP",
      }
    }
  end
end