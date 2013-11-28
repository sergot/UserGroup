class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(:name => params[:group][:name])
    if @group.save
      redirect_to @group
    else
      @group = Group.new
      flash[:notice] = 'Group exists!'
      redirect_to :action => 'new'
    end
  end

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def add_user
    by_user = User.find(params[:id])
    user_to_add = User.find(params[:uid])
    groups_to_add = params[:gid]

    groups_to_add.each do |g|
      if by_user.groups.exists?(g)
        user_to_add.groups.push(Group.find(g))
      else
        flash[:notice] = "You can't add users to groups which you are not in."
      end
    end
    redirect_to user_path(by_user)
  end

  def new_groups_users
    if not params[:gid] or not params[:uid]
      @groups = Group.all
      @users = User.all
    else
      user = User.find(params[:uid])
      group = Group.find(params[:gid])
        if user and group
          user.groups.push(group)
        end
      redirect_to users_path
    end
  end
end
