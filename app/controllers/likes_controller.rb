class LikesController < ApplicationController

  def create
    @like = current_user.likes.build(micropost_id: params[:micropost_id])
    @like.save
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.create_notification_like(current_user)
    respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
    end
  end


  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @like = Like.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
    @like.destroy
    respond_to do |format| 
      format.html {redirect_to request.referrer}
      format.js
    end
  end
end

