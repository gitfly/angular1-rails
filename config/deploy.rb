# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'baozheng'
set :repo_url, 'git@github.com:iambaozheng/baozheng.git'

# set :deploy_to, '/home/ubuntu/baozheng'
# set :branch, fetch(:branch, "master")

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# set :tmp_dir, "/home/deploy/tmp"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :delayed_job_server_role, :app
# set :delayed_job_args, "-n 1"


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# callback = callbacks[:after].find{|c| c.source == "deploy:assets:precompile" }
# callbacks[:after].delete(callback)
# after 'deploy:update_code', 'deploy:assets:precompile' unless fetch(:skip_assets, false)


desc "tail rails logs" 
task :tail do
  on roles(:app) do
    execute "tail -f #{shared_path}/log/#{fetch(:stage)}.log"
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'delayed_job:restart'
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
      # invoke 'delayed_job:restart'
    end
  end

  # after :publishing, :restart
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # invoke 'delayed_job:restart'                                                

      within release_path do
        # execute :rake, 'cache:clear'
      end
    end
  end

end
