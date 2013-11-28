require 'faker'

FactoryGirl.define do
  factory :group do |f|
    f.name { Faker::Name.name }
  end
end

FactoryGirl.define do
  factory :invalid_group, parent: :group do |f|
    f.name nil
  end
end