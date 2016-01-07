module OrderLoggable
  extend ActiveSupport::Concern

  included do
    # include Wisper::Publisher
    attr_accessor :handler_id
    attr_accessor :current_logger
    attr_accessor :all_changed
  end

  def updated_by(user, params={})
    ActiveRecord::Base.transaction do
      self.all_changed ||= {}

      self.update_association_attributes(user, params)
      self.update_attributes!(self.class.permit(params))

      customer.orders.uncompleted.update_all(
        pickup_manner: pickup_manner, 
        delivery_date: delivery_date,
        delivery_manner: delivery_manner,
        fetch_address_id: fetch_address_id, 
        delivery_address_id: delivery_address_id,
        delivery_date_detail: delivery_date_detail
      )

      self.logs.create!(
        handle_type: 'Update', 
        user_id: user.id,
        changed_values: self.all_changed
      ) unless all_changed.blank?
    end
  end

  def update_association_attributes(user, params)
    update_or_create_item_by(user, Item.permit(params[:item]))
    update_or_create_friend_by(user, Friend.permit(params[:friend]))

    update_or_create_address_by(
      user, Address.permit(params[:fetch_address]), :fetch_address
    )
    update_or_create_address_by(
      user, Address.permit(params[:delivery_address]), :delivery_address
    )
  end

  def update_or_create_item_by(user, params={})
    params.blank? and return nil
    if item
      record_changed_attributes(params, item)
      item.update_attributes!(params)
    else
      record_changed_attributes(params, nil, :item)
      create_item!(params)
    end
  end

  def update_or_create_address_by(user, params={}, type=:fetch_address)
    params.blank? and return nil

    old_address = send(type)

    atype = Address::Atype[type]
    addr = customer.addresses.find_or_create_by!(params.merge(atype: atype))
    self.update_attributes!("#{type}_id": addr.id)
  end

  def update_or_create_friend_by(user, params={})
    params.blank? and return nil
    if friend
      record_changed_attributes(params, friend)
      friend.update_attributes!(params)
    else
      record_changed_attributes(params, nil, :friend)
      create_friend!(params)
    end
  end

  def record_changed_attributes(params={}, obj=nil, name=nil)
    return unless self.all_changed

    if name
      name = "#{name}_"
    elsif obj
      name = "#{obj.param_name}_"
    end

    params.each do |k, v|
      if obj.nil? || v.to_s != obj.send(k).to_s
        key = "#{name}#{k}"
        key_zh = I18n.t("activerecord.attributes.order_log.#{key}")
        value = obj.try(:send, k)
        case key
        when 'item_type'
          self.all_changed[key_zh] = [
            Item::Type[value.try(:to_sym)], 
            Item::Type[v.to_sym]
          ]
        else
          self.all_changed[key_zh] = [value, v]
        end
      end
    end
  end

  class_methods do
    def create_order_by(user, params)
      ActiveRecord::Base.transaction do
        order = Store.first.orders.create!(self.permit(params))
        order.update_association_attributes(user, params)
        order.logs.create!(handle_type: 'Create', user_id: user.id)
        order
      end
    end
  end
end
