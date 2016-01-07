object false

node(:technologies) do
  @technologies.map do |tech|
    partial('technologies/show', object: tech)
  end
end
