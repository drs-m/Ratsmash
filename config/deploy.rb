# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'RMash'
set :repo_url, 'git@code.rmash.de:rmash/Ratsmash.git'
set :deploy_user, 'rails'

set :asset_roles, [:app]

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

set :use_sudo, false

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, fetch(:linked_dirs) + %w{uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

    # before :deploy, "deploy:check_revision"
    # after "deploy:symlink:shared", "deploy:compile_assets_locally"
    after :finishing, "deploy:cleanup"

    after "deploy:publishing", "deploy:restart"

    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 2 do
            sudo "nginx -s reload"
            # Your restart mechanism here, for example:
            # execute :touch, release_path.join('tmp/restart.txt')
        end
    end

    after :publishing, :restart

end
