class AddSubstitutedToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :substituted, :boolean, default: false
  end
end
