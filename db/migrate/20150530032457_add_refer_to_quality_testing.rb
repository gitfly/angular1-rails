class AddReferToQualityTesting < ActiveRecord::Migration
  def change
    add_column :quality_testings, :refer, :boolean, default: false
  end
end
