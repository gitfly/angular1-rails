class AddTtypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ttype, :integer
  end
end
