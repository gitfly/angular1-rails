object false
# attributes :id, :order_id, :original_url, :thumb_url, :symptoms

node(:all_photos) do |m|
  @photos.map do |photo|
    partial('photos/show', object: photo, locals: {stype: @stype, with_child: @with_child})
  end
end

