partial("orders/#{params[:order][:template]||'show_order'}", object: @order)
