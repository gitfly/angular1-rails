class AddOriginalPriceAndRealIncomeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :original_price, :integer, default: 0
    add_column :activities, :real_income, :integer, default: 0
  end
end
