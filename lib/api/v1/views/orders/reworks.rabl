object false

node(:worker_reworks) do |m|
  @worker_reworks.map do |order|
    partial("orders/rework", object: order)
  end
end

node(:solu_reworks) do |m|
  @solu_reworks.map do |order|
    partial("orders/rework", object: order)
  end
end
