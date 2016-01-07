object false

node(:templates) do |m|
  @templates.map do |template|
    partial("solu_templates/show", object: template)
  end
end
