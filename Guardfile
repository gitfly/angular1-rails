# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec feature)

## Uncomment to clear the screen before every task
# clearing :on

## Guard internally checks for changes in the Guardfile and exits.
## If you want Guard to automatically start up again, run guard in a
## shell loop, e.g.:
##
##  $ while bundle exec guard; do echo "Restarting Guard..."; done
##
## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), the you will want to move the Guardfile
## to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'livereload' do
  watch('spec/models/order_spec.rb')  { "spec" }
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{app/models/.+\.rb})
  watch(%r{app/controllers/.+\.rb})
  watch(%r{lib/api/v1/.+\.rb})
  watch(%r{lib/api/v1/views/.+\.rabl})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(coffee|less|css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end

# guard 'coffeescript', :input => 'app/assets/javascripts', :noop => true, :hide_success => true

# coffeescript_options = {
#   input: 'app/assets/javascripts',
#   output: 'app/assets/javascripts',
#   patterns: [%r{^app/assets/javascripts/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
# }
# 
# guard 'coffeescript', coffeescript_options do
#   coffeescript_options[:patterns].each { |pattern| watch(pattern) }
# end
# 

# guard 'sass', :input => 'sass', :output => 'css'
# guard 'sass', :input => 'app/assets/stylesheets', :noop => true, :hide_success => true

# NOTE: the subpath hack using a regexp group no longer works
# - instead, use the patterns option, e.g. change:
#
#    guard :less do
#      watch /^foo\/(.+)\.less/
#    end
#
#  into:
#
#    patterns = [/^foo\/(.+)\.less/]
#    guard :less, patterns: patterns do
#      patterns.each { |pattern| watch(pattern) }
#    end

# less_options = {
#   all_on_start: true,
#   all_after_change: true,
#   patterns: [/^.+\.less$/]
# }
# 
# guard :less, less_options do
#   less_options[:patterns].each { |pattern| watch(pattern) }
# end



# 
# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separately)
#  * 'just' rspec: 'rspec'

# guard :rspec, cmd: "bundle exec rspec" do
# guard :rspec, cmd:"spring rspec -f html -o ./tmp/spec_results.html", launchy: './tmp/spec_results.html' do
# guard :rspec, cmd:"spring rspec -f doc" do

# guard :rspec, cmd:"spring rspec -f doc" do
#   require "guard/rspec/dsl"
#   dsl = Guard::RSpec::Dsl.new(self)
# 
#   # Feel free to open issues for suggestions and improvements
# 
#   # RSpec files
#   rspec = dsl.rspec
#   watch(rspec.spec_helper) { rspec.spec_dir }
#   watch(rspec.spec_support) { rspec.spec_dir }
#   watch(rspec.spec_files)
# 
#   # Ruby files
#   ruby = dsl.ruby
#   dsl.watch_spec_files_for(ruby.lib_files)
# 
#   # Rails files
#   rails = dsl.rails(view_extensions: %w(erb haml slim))
#   dsl.watch_spec_files_for(rails.app_files)
#   dsl.watch_spec_files_for(rails.views)
# 
#   watch(rails.controllers) do |m|
#     [
#       rspec.spec.("routing/#{m[1]}_routing"),
#       rspec.spec.("controllers/#{m[1]}_controller"),
#       rspec.spec.("acceptance/#{m[1]}")
#     ]
#   end
# 
#   # watch(%r{^app/models/(.+)\.rb$}) {|m| "spec/models/#{m[1]}_spec.rb" }
# 
#   # Rails config changes
#   watch(rails.spec_helper)     { rspec.spec_dir }
#   watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
#   watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }
# 
#   # Capybara features specs
#   watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }
#   watch(rails.layouts)       { |m| rspec.spec.("features/#{m[1]}") }
# 
#   # Turnip features and steps
#   watch(%r{^spec/acceptance/(.+)\.feature$})
#   watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
#     Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
#   end
# end
# 
# guard 'sass', :input => 'sass', :output => 'css'
