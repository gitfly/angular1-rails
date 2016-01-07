object false

node(:technologies) do
  @technologies.map do |tech|
    partial('technologies/detail', object: tech)
  end
end

node(:count) do
  @count
end