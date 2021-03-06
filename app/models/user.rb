class User < ActiveRecord::Base
  has_and_belongs_to_many :groups

  validates_uniqueness_of :name
  validates_presence_of :name
end
