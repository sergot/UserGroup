class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      @user = User.new
      flash[:notice] = 'User exists!'
      redirect_to :action => 'new'
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @groups = Group.all
    @users = User.where.not(id: @user.id)
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
