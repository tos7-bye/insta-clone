class CommentsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :correct_user, only: :destroy

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = current_user.comments.build(comment_params)
    @comment.micropost_id = params[:micropost_id]
    @comments = @micropost.comments
    if @comment.save
      flash[:success] = 'コメントしました'
      redirect_to user_path(current_user)
    else
      flash[:success] = 'コメントに失敗しました'
      redirect_to user_path(current_user)
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

