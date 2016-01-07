Dumper::Agent.start_if(:app_key => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') do
  # Rails.env.production? && dumper_enabled_host?
  Rails.env.production?
end
