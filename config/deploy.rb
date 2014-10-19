set :stages, %w(production)     #various environments
load "deploy/assets"                    #precompile all the css, js and images... before deployment..
require "bundler/capistrano"            # install all the new missing plugins...
require 'capistrano/ext/multistage'     # deploy on all the servers..
require "rvm/capistrano"                # if you are using rvm on your server..
require './config/boot'

before "deploy:assets:precompile","deploy:config_symlink"
after "deploy:update", "deploy:cleanup" #clean up temp files etc.
after "deploy:update_code","deploy:migrate"

set(:application) { "screenshotz" }
set :rvm_ruby_string, '2.1.2'             # ruby version you are using...
set :rvm_type, :user
set :whenever_environment, defer { stage }  # whenever gem for cron jobs...
set :whenever_identifier, defer { "#{application}_#{stage}" }
server "107.170.153.145", :app, :web, :db, :primary => true
set (:deploy_to) { "/home/sweety/#{application}/#{stage}" }
set :user, 'sweety'
set :keep_releases, 3
set :repository, "git@bitbucket.org:manoj2411/screenshotz.git"
set :use_sudo, false
set :scm, :git
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

namespace :deploy do
  task :start , :roles => :app, :except => { :no_release => true }  do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :config_symlink do
    run "ln -sf #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end



