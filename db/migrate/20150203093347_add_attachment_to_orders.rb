class AddAttachmentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :attachment, :string, default: ''
  end
end
