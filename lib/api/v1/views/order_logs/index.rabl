object @logs => false

@logs ||= locals[:object]

attributes :id, :handle_type, :user_id, :order_id, :attrs, :user_name, :user_avatar, :changed_values, :show_type, :show_time
