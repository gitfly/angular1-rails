object @desc
attributes :content, :id, :dtype, :symptom, :technology, :expect

locals[:object] ||= @desc

node(:tags) do
  locals[:object].tags.map do |desc|
    partial('desc_tags/show', object: desc)
  end
end

