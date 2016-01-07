class AddServiceNumberSensitivityTagsToCustomer < ActiveRecord::Migration
  def change
    add_column :users, :service_number, :integer
    add_column :users, :sensitivity, :integer
    add_column :users, :tags, :string
  end
end
