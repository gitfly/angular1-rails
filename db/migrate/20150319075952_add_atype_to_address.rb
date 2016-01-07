class AddAtypeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :atype, :integer
    add_index :addresses, :atype
  end
end
