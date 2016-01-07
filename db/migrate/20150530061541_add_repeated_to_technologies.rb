class AddRepeatedToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :repeated, :boolean, default: false
    Technology.group(:ttype).group(:order_id).each do |tech|
      techs = Technology.where(order_id: tech.order_id, ttype: tech.ttype).order('id asc')
      techs.update_all(repeated: true)
      techs.last.update_attributes!(repeated: false)
    end
  end
end
