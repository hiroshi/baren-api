$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano" # Load RVM's capistrano plugin.
require 'bundler/capistrano'

set :application, "baren-api"
set :repository,  "git://github.com/hiroshi/baren-api.git"
set :scm, :git
set :deploy_via, :remote_cache
set :local_repository,  "."
set :branch, "master"
set :user, "www-data"
set :group, "www-data"
set :use_sudo, false
set :deploy_to, "/var/www/baren-api"
set :rvm_ruby_string, 'ruby-1.9.2-p180'
server "jerle.yakitara.com", :app, :web, :db, :primary => true

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
