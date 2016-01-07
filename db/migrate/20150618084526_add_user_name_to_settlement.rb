class AddUserNameToSettlement < ActiveRecord::Migration
  def change
    add_column :settlements, :user_name, :string
  end
end
