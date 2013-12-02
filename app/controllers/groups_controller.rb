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
    groups_to_add = params[:gid].map do |g|
      Group.find(g)
    end

    AuthorizedGroupsAssignment.new(by_user).assigns_groups(user_to_add, groups_to_add)
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


class AuthorizedGroupsAssignment

  def initialize(assigner)
    @assigner = assigner
  end

  def assigns_groups(assignee, groups)
    ActiveRecord::Base.transaction do
      groups.each do |group|
        assign_group(assignee, group)
      end
    end
  end

  def assign_group(assignee, group)
    if authorized_assignment?(group) and ensure_unique_assignment(assignee, group)
      assignee.groups << group
    end
  end


  private

  def authorized_assignment?(group)
    @assigner.groups.exists?(group)
  end

  def ensure_unique_assignment(assignee, group)
    !assignee.groups.exists?(group)
  end

end