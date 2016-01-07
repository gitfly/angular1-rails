object false
# attributes :id, :content, :tags

node(:descs) do
  @descs.map do |desc|
    partial('photo_descs/show', object: desc)
  end
end

node(:init_tags) do
  Category.roots.map do |cat|
    partial('categories/show', object: cat)
  end
end

node(:count) do
  @count
end
