object @photo => false
attributes :id, :order_id, :original_url, :thumb_url, :parent_id, :photoable_type, :photoable_id, :header, :sequence, :name, :show_size, :used

locals[:object] ||= @photo
if locals[:object]
  node(:symptoms) do |m|
    locals[:object].symptoms.where(stype: locals[:stype]).map do |sym|
      partial('photo_symptoms/show', object: sym).merge(
        options: sym.options.map do |cat|
          partial('categories/show', object: cat)
        end
      )
    end
  end

  if locals[:with_child]
    node(:child_photos) do |m|
      locals[:object].child_photos.map do |p|
        {
          id: p.id, 
          order_id: p.order_id, 
          original_url: p.original_url, 
          thumb_url: p.thumb_url, 
          parent_id: p.parent_id
        }
      end
    end
  end

end
