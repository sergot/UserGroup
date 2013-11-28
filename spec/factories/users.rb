require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Name.name }
  end
end

FactoryGirl.define do
  factory :invalid_user, parent: :user do |f|
    f.name nil
  end
end
