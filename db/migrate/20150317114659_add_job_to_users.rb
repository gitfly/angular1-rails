class AddJobToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job, :string
  end
end
