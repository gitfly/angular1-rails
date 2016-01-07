module AppointmentInfo
  extend ActiveSupport::Concern

  module ClassMethods

    def get_delivery_orders
      values = Order.find_by_sql(
        "select orders.id as id, " \
        "users.id as customer_id, "\
        "'delivery' as adtype, " \
        "concat(orders.delivery_hour_start,'-',orders.delivery_hour_end) as date_detail," \
        "concat(addresses.district, addresses.details) as address_detail, "\
        "orders.delivery_trouble as trouble, "\
        "users.name as name, " \
        "users.id as customer_id, " \
        "users.phone as phone "\
        "from orders " \
        "left join addresses " \
        "on delivery_address_id = addresses.id "\
        "and  addresses.deleted_at is null "\
        "left join users " \
        "on orders.customer_id = users.id " \
        "and users.type ='Customer' and users.deleted_at is null " \
        "where orders.delivery_manner = #{::Order::DeliveryManner[:包拯上门送]} "\
        "and orders.status = #{::OrderStatus::Status[:waiting_for_customer_receipt]} "\
        "and date(orders.delivery_date) = date(now())"
      )
      return values
    end

    def get_appointments
      values =  Appointment.find_by_sql(
        "select appointments.id as id, "\
        "appointments.customer_id as customer_id, "\
        "'fetch' as adtype, "\
        "appointments.trouble as trouble, "\
        "concat(appointments.date_detail_start,'-',appointments.date_detail_end)"\
        " as date_detail, "\
        "concat(addresses.district, addresses.details) as address_detail, "\
        "appointments.name as name, " \
        "appointments.phone as phone "\
        "from appointments " \
        "left join addresses " \
        "on appointments.id = addresses.addressable_id "\
        "and addresses.addressable_type = 'Appointment' "\
        "and  addresses.deleted_at is null "\
        "where date(appointments.date) = date(now()) "\
        "and appointments.trouble = 0 "\
        "and appointments.finished = 0 "\
        "and appointments.atype = 0"
      )
      return values
    end


    def completed_appointments
     values = Order.find_by_sql(
        "select appointments.id as id, "\
        "appointments.customer_id as customer_id, "\
        "'fetch' as adtype, "\
        "appointments.date as date_detail, "\
        "appointments.trouble as trouble, "\
        "concat(addresses.district, addresses.details) as address_detail, "\
        "appointments.name as name, " \
        "appointments.phone as phone "\
        "FROM appointments "\
        "left join addresses " \
        "on appointments.id = addresses.addressable_id "\
        "and addresses.addressable_type = 'Appointment' "\
        "and  addresses.deleted_at is null "\
        "WHERE appointments.finished = 1 "\
        "and appointments.atype = 0 "\
        "and date(appointments.date) = date(now())"
      )
      return values
    end

    def deliveried_orders
      values = Order.find_by_sql("select orders.id as id, " \
        "users.id as customer_id, "\
        "'delivery' as adtype, " \
        "orders.delivery_date_detail as date_detail," \
        "orders.delivery_trouble as trouble, "\
        "concat(addresses.district, addresses.details) as address_detail, "\
        "users.name as name, " \
        "users.id as customer_id, " \
        "users.phone as phone "\
        "from orders " \
        "left join addresses " \
        "on delivery_address_id = addresses.id "\
        "and  addresses.deleted_at is null "\
        "left join users " \
        "on orders.customer_id = users.id " \
        "and users.type ='Customer' and users.deleted_at is null " \
        "inner join order_statuses "\
        "on orders.id = order_statuses.order_id "\
        "where order_statuses.status = #{::OrderStatus::Status[:customer_receipt_confirmed]} "\
        "and orders.status = #{::OrderStatus::Status[:customer_receipt_confirmed]} "\
        "and (date(order_statuses.created_at) = date(now())) "\
        "and orders.delivery_manner = #{::Order::DeliveryManner[:包拯上门送]} "
      )
      return values
    end

    def combine_array_and_sort(arr1, arr2)

      ary = (arr1 + arr2).sort_by do |item|
        unless item[:address_detail]
          item[:address_detail] = ""
        end
        item[:address_detail]
      end 
      return ary
    end

    def get_appointment_info
      delivery_orders = get_delivery_orders.uniq! {|e| e[:customer_id] }
      unless delivery_orders
        delivery_orders = []
      end
      return combine_array_and_sort(delivery_orders, get_appointments)
    end

    def get_completed_appointment_info
      deliveried = deliveried_orders.uniq! {|e| e[:customer_id] }
      unless deliveried 
        deliveried = []  
      end  
      return combine_array_and_sort(completed_appointments, deliveried)
    end
  end
end
