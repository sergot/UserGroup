require 'spec_helper'

describe GroupsController do
  describe 'GET #new' do
    it 'responds successfully with an HTTP 200 status code' do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'assigns all of the groups to @groups' do
      g1, g2 = FactoryGirl.create(:group), FactoryGirl.create(:group)

      get :index
      expect(assigns(:groups)).to match_array([g1, g2])
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new group in the database' do
        expect {
          post :create, group: FactoryGirl.attributes_for(:group)
        }.to change(Group, :count).by(1)
      end
      it 'redirects to #show' do
        post :create, group: FactoryGirl.attributes_for(:group)
        response.should redirect_to Group.last
      end
    end

    context 'with invalid attributes' do
      context '(repeated)' do
        it 'does not save the new group in the database' do
          group = FactoryGirl.create(:group, name: 'u1')

          expect {
            post :create, group: FactoryGirl.build(:group, name: 'u1').attributes
          }.to_not change(Group, :count)
        end
      end

      context '(not repeated)' do
        it 'does not save the new group in the database' do
          expect {
            post :create, group: FactoryGirl.attributes_for(:invalid_group)
          }.to_not change(Group, :count)
        end
      end

      it 'redirects to #new' do
        post :create, group: FactoryGirl.attributes_for(:invalid_group)
        response.should redirect_to new_group_path
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @group = FactoryGirl.create(:group)
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :show, id: @group
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :show, id: @group
      expect(response).to render_template('show')
    end

    it 'assigns currect group to @group' do
      get :show, id: @group
      expect(assigns(:group)).to eq(@group)
    end
  end

  describe 'GET #new_groups_users' do
    it 'responds successfully with an HTTP 200 status code' do
      get :new_groups_users
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :new_groups_users
      expect(response).to render_template('new_groups_users')
    end

    it 'assigns all of the users to @users' do
      user = FactoryGirl.create(:user)
      get :new_groups_users
      expect(assigns(:users)).to eq([user])
    end

    it 'assigns all of the groups to @groups' do
      group = FactoryGirl.create(:group)
      get :new_groups_users
      expect(assigns(:groups)).to eq([group])
    end
  end

  describe 'POST #new_groups_users' do
    before :each do
      @group = FactoryGirl.create(:group)
      @user = FactoryGirl.create(:user)
    end

    context 'with valid attributes' do
      it 'adds selected user to selected group' do
        post :new_groups_users, uid: @user.id, gid: @group.id
        @user.groups.should match_array([@group])
      end
    end

    context 'with invalid attributes' do
      it 'does not add selected user to selected group' do
        post :new_groups_users, uid: nil, gid: nil
        @user.groups.should_not match_array([@group])
      end
    end

    it 'redirects to chosen #users' do
      post :new_groups_users, uid: @user.id, gid: @group.id
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'POST #add_user' do
    before :each do
      @group_to_add_to = FactoryGirl.create(:group)
      @user_to_be_added = FactoryGirl.create(:user)

      @user_who_adds = FactoryGirl.create(:user)
    end

    context 'when current user is in group which adding another user to' do
      before :each do
        @user_who_adds.groups = [@group_to_add_to]
      end

      it 'adds another user to selected groups' do
        post :add_user, id: @user_who_adds.id, uid: @user_to_be_added.id, gid: [@group_to_add_to.id]
        @user_to_be_added.groups.should == [@group_to_add_to]
      end

      it 'changes flash[:notice] value' do
        post :add_user, id: @user_who_adds.id, uid: @user_to_be_added.id, gid: [@group_to_add_to.id]
        expect(response).to redirect_to(@user_who_adds)
        flash[:notice].should be_nil
      end

      it 'redirects to current user #show' do
        post :add_user, id: @user_who_adds.id, uid: @user_to_be_added.id, gid: [@group_to_add_to.id]
        expect(response).to redirect_to(@user_who_adds)
      end
    end

    context 'when current users is not in the group' do
      it 'does not add user to selected groups' do
        post :add_user, id: @user_who_adds.id, uid: @user_to_be_added.id, gid: [@group_to_add_to.id]
        @user_to_be_added.groups.should == []
      end

      it 'redirects to current user #show' do
        post :add_user, id: @user_who_adds.id, uid: @user_to_be_added.id, gid: [@group_to_add_to.id]
        expect(response).to redirect_to(@user_who_adds)
      end
    end
  end
end