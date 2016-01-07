object :overdues => false

node(:overdues) do |m|
  @overdues.map do |overdue|
    partial("overdues/overdue", object: overdue)
  end
end

node(:order) do |m|
  @order
end