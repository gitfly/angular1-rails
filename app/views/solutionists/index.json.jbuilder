json.array!(@solutionists) do |solutionist|
  json.extract! solutionist, :id
  json.url solutionist_url(solutionist, format: :json)
end
