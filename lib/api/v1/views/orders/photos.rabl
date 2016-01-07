object false

node(:before) do |m|
  @photos.map do |photo|
    partial('orders/photo', object: photo)
  end
end

node(:after) do |m|
  @photos.map do |photo|
    partial('orders/photo', object: photo.after)
  end
end if @with_child

