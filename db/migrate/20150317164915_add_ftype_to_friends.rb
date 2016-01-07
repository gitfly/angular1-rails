class AddFtypeToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :ftype, :integer
  end
end
