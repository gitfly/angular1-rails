class AddPmToCompensates < ActiveRecord::Migration
  def change
    add_column :compensates, :pm, :integer
  end
end
