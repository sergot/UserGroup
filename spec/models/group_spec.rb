require 'spec_helper'

describe Group do
  it 'has a valid factory' do
    FactoryGirl.create(:group).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:group, name: nil).should_not be_valid
  end

  it 'does not allow duplicate name' do
    FactoryGirl.create(:group, name: 'u1')
    FactoryGirl.build(:group, name: 'u1').should_not be_valid
  end
end