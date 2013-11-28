require 'spec_helper'

describe User do
  it 'has a valid factory' do
    FactoryGirl.create(:user).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:user, name: nil).should_not be_valid
  end

  it 'does not allow duplicate name' do
    FactoryGirl.create(:user, name: 'u1')
    FactoryGirl.build(:user, name: 'u1').should_not be_valid
  end
end