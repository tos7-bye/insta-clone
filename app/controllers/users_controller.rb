class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy,
                                                                :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
# GET/users
  def index
    @users = User.paginate(page: params[:page])
  end
# GET/users/:id 
  def show
    @user = User.find(params[:id])
    @micropost = Micropost.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @comments = @micropost.comments
    @comment = Comment.new
  end
# GET/users/new
  def new
    @user = User.new
  end
# POST/users
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # success(valid params)
    else
      # Failure(not valid params)
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash.now[:danger] = "Profile editing failed"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def destroy_all
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User withdrawn"
    redirect_to root_path
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :name, :email, :gender, :phone_number,
                                                  :introduction, :password, :password_cofirmation)
  end

    # beforeアクション

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end

