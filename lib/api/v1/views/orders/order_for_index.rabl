object @order

attrs = [:id, :number, :show_item_type, :show_status, :show_status_zh, :customer_id, :show_color, :show_brand, :show_style, :show_created_at, :show_number, :urgent, :late, :paid, :show_paid]
current_user.type == "CounselorManager" and attrs << :status_handler
attributes *attrs
