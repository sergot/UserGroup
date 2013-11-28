class AddUsersToGroups < ActiveRecord::Migration
  def self.up
    create_table 'groups_users', :id => false do |t|
      t.references :user
      t.references :group
    end
    add_index :groups_users, [:user_id, :group_id], unique: true
  end

  def self.down
    drop_table 'users_groups'
  end
end
