set :domain, "bumsonthesaddle.com"
set :user, "bumsont"
set :application, ENV['PROD'] ? 'bazaar' : 'bazaar_demo'

set :rails_env, 'production'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :group_writable, false  	
set :use_sudo, false
set :keep_releases, 2

role :web, domain
role :app, domain
role :db,  domain, :primary => true

default_run_options[:pty] = true
set :git_account, 'rohankini'
set :repository,  "git@github.com:#{git_account}/bazaar.git"
set :scm, "git"

ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

desc "link up symlinks to the correct folder"
task :after_update do 
  sym_link_database_yml
end

def sym_link_database_yml    
  destination = File.join(current_path, 'config', 'database.yml')
  source_yaml = File.join(shared_path, 'config', 'database.yml')
  run("rm -rf #{destination}")
  run("ln -s #{source_yaml} #{destination}")
end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end