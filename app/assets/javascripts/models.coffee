app = window.app

app.factory "User", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/users"
    name: "user"

app.factory "Order", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/orders"
    name: "order"

app.factory "OrderStatus", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/order_statuses"
    name: "orderStatus"

app.factory "Customer", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/customers"
    name: "customer"

app.factory "Service", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/services"
    name: "service"

app.factory "ServiceType", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/services/types"
    name: "serviceType"

app.factory "Customer", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/customers"
    name: "customer"

app.factory "ConsumptionRecord", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/consumption_records"
    name: "consumptionRecord"

app.factory "Settlement", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/settlements"
    name: "settlement"

app.factory "PayRecord", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/pay_records"
    name: "payRecord"

app.factory "Recharge", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/recharges"
    name: "recharge"

app.factory "Address", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/addresses"
    name: "address"

app.factory "Friend", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/friends"
    name: "friend"

app.factory "Photo", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/photos"
    name: "photo"

app.factory "Category", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/categories"
    name: "category"

app.factory "OrderLog", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/order_logs"
    name: "orderLog"

app.factory "ItemVersion", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/items/versions"
    name: "itemVersion"

app.factory "ItemBrand", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/items/brands"
    name: "itemBrand"

app.factory "ItemColor", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/items/colors"
    name: "itemColor"

app.factory "UncompletedOrder", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/orders/uncompleted"
    name: "uncompletedOrder"

app.factory "Activity", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/activities"
    name: "activity"

app.factory "PhotoSymptom", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/photo_symptoms"
    name: "photoSymptom"

app.factory "Desc", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/descs"
    name: "desc"

app.factory "PhotoDesc", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/photo_descs"
    name: "photoDesc"

app.factory "SoluTemplate", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/solu_templates"
    name: "soluTemplate"

app.factory "DescTag", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/desc_tags"
    name: "descTag"

app.factory "Reconciliation", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/orders/reconciliations"
    name: "reconciliation"

app.factory "ReportHome", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/datareports/report_home"
    name: "reportHome"

app.factory "OrderItem", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/datareports/orderitems"
    name: "orderitem"

app.factory "OverdueOrder", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/datareports/overdue_orders"
    name: "overdueOrder"

app.factory "PaymentDetail", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/datareports/payment_details"
    name: "paymentDetail"

app.factory "CustomerDetail", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/datareports/customer_details"
    name: "customerDetail"

app.factory "Compensate", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/compensates"
    name: "compensate"

app.factory "Refund", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/refunds"
    name: "refund"

app.factory "Overdue", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/orders/overdue"
    name: "Overdue"

app.factory "FetchDeliveryDetail", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/orders/fetch_delivery_detail"
    name: "fetchDeliveryDetail"

app.factory "StorageDetail", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/datareports/storage_detail"
    name: "storageDetail"

app.factory "Store", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/warehouses/store"
    name: "store"

app.factory "GlobalObject", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1"
    name: "globalObject"

app.factory "Appointment", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/appointments"
    name: "appointment"

app.factory "Courier", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/couriers"
    name: "courier"
