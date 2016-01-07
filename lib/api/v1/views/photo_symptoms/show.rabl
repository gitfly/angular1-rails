object @symptom
attributes :id, :photo_id, :symptoms, :category_ids, :desc, :stype

if @category 
  node(:options) do |n|
    @category.children.map do |child|
      partial("categories/show", object: child)
    end
  end
end
