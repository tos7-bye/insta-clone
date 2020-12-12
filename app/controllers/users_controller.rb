class UsersController < ApplicationController
# GET/users/:id 
  def show
    @user = User.find(params[:id])
  end
# GET/users/new
  def new
    @user = User.new
  end
# POST/users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
      flash[:success] = "Welcome to the Inata Clone!"
      # success(valid params)
    else
      # Failure(not valid params)
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                                :password_cofirmation)
  end
end
