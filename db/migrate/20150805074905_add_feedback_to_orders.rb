class AddFeedbackToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :feedback, :string
  end
end
