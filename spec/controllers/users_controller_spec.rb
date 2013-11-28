require 'spec_helper'

describe UsersController do
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

    it 'assigns all of the users to @users' do
      u1, u2 = FactoryGirl.create(:user), FactoryGirl.create(:user)

      get :index
      expect(assigns(:users)).to match_array([u1, u2])
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new user in the database' do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      it 'redirects to #show' do
        post :create, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to User.last
      end
    end

    context 'with invalid attributes' do
      context '(repeated)' do
        it 'does not save the new user in the database' do
          user = FactoryGirl.create(:user, name: 'u1')

          expect {
            post :create, user: FactoryGirl.build(:user, name: 'u1').attributes
          }.to_not change(User, :count)
        end
      end

      context '(not repeated)' do
        it 'does not save the new user in the database' do
          expect {
            post :create, user: FactoryGirl.attributes_for(:invalid_user)
          }.to_not change(User, :count)
        end
      end

      it 'redirects to #new' do
        post :create, user: FactoryGirl.attributes_for(:invalid_user)
        response.should redirect_to new_user_path
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :show, id: @user
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :show, id: @user
      expect(response).to render_template('show')
    end

    it 'assigns all of the groups to @groups' do
      group = FactoryGirl.create(:group)
      get :show, id: @user
      expect(assigns(:groups)).to eq([group])
    end

    it 'assigns all of the users to @users, without current user' do
      user = FactoryGirl.create(:user)
      get :show, id: @user
      expect(assigns(:users)).to eq([user])
    end

    it 'assigns current user to @user' do
      get :show, id: @user
      expect(assigns(:user)).to eq(@user)
    end
  end
end