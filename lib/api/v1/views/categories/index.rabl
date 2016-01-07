object @categories => false
attributes :id, :name, :title, :edit, :parent_id, :record_id

node(:nodes) do |n|
  n.children.map do |child|
    partial("categories/show", object: child)
  end
end
