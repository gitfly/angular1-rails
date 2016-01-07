class AddConsumeAddUpToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :consume_add_up, :integer, default: 1
  end
end
