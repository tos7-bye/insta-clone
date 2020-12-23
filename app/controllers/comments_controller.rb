class CommentsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :correct_user, only: :destroy

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment_micropost = @comment.micropost
    @comments = @micropost.comments
    if @comment.save
      @comment_micropost.create_notification_comment(current_user, @comment.id)
      flash[:success] = 'コメントしました'
      redirect_to micropost_path(@micropost)
    else
      flash[:success] = 'コメントに失敗しました'
      redirect_to micropost_path(current_user)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = 'コメントを削除しました'
    redirect_to user_path(current_user)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end
end

