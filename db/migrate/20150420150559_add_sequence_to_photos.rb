class AddSequenceToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :sequence, :integer, default: 0
  end
end
