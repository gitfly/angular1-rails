collection @technologies, :root => "technologies"

node(:technologies) do
  @technologies.map do |tech|
    partial('technologies/detail', object: tech)
  end
end

