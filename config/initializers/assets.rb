# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

controllers = Dir.glob('app/controllers/*.rb').map do |file| 
  file.split('/').last.split('_').first << '.js'
end

Rails.application.config.assets.precompile += controllers

Rails.application.config.assets.precompile += %w( app.js controllers.js mobile.js )

Rails.application.config.assets.precompile += %w( slim.css printer.css mobile.css)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
