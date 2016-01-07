class AddAtypeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :atype, :integer, default: 0
  end
end
