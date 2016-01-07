object @template => false
attributes :id, :header, :footer, :before

locals[:object] ||= @template

node(:photos) do |p|
  locals[:object].photos.map do |photo|
    partial('photos/photo', object: photo)
  end
end
