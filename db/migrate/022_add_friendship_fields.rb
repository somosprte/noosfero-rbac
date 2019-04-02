class AddFriendshipFields < ActiveRecord::Migration
  def self.up
    # users must be able to classify their friends
    add_column :friendships, :group, :string
  end

  def self.down
    remove_column :friendships, :group
  end
end
