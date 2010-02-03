set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

before "deploy:setup", "db:password"

namespace :deploy do
  desc "Default deploy - updated to run migrations"
  task :default do
    set :migrate_target, :latest
    update_code
    migrate
    symlink
    restart
  end
  desc "Start the mongrels"
  task :start do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::start --config #{mongrel_cluster_config}")
  end
  desc "Stop the mongrels"
  task :stop do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::stop --config #{mongrel_cluster_config}")
  end
  desc "Restart the mongrels"
  task :restart do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::restart --config #{mongrel_cluster_config}")
  end

  # Clean up old releases after each deployment
  after "deploy", "deploy:cleanup"

  before :deploy do
    if real_revision.empty?
      raise "The tag, revision, or branch #{revision} does not exist."
    end
  end
end

namespace :db do
  desc "Create database password in shared path" 
  task :password do
    set :db_password, Proc.new { Capistrano::CLI.password_prompt("Remote database password: ") }
    run "mkdir -p #{shared_path}/config" 
    put db_password, "#{shared_path}/config/dbpassword" 
  end
end


task :setup_production_database_configuration do
mysql_password = Capistrano::CLI.password_prompt("Production MySQL password: ")
require 'yaml'
spec = { "production" => {
  "adapter" => "mysql",
  "database" => user,
  "username" => user,
  "password" => mysql_password } }
  run "mkdir -p #{shared_path}/config"
  put(spec.to_yaml, "#{shared_path}/config/database.yml")
end
after "deploy:setup", :setup_production_database_configuration


task :copy_production_database_configuration do
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
after "deploy:update_code", :copy_production_database_configuration


# http://errtheblog.com/posts/19-streaming-capistrano
desc "tail production log files" 
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}" 
    break if stream == :err    
  end
end

desc "check production log files in textmate(tm)" 
task :mate_logs, :roles => :app do

  require 'tempfile'
  tmp = Tempfile.open('w')
  logs = Hash.new { |h,k| h[k] = '' }

  run "tail -n500 #{shared_path}/log/production.log" do |channel, stream, data|
    logs[channel[:host]] << data
    break if stream == :err
  end

  logs.each do |host, log|
    tmp.write("--- #{host} ---\n\n")
    tmp.write(log + "\n")
  end

  exec "mate -w #{tmp.path}" 
  tmp.close
end

desc "remotely console" 
task :console, :roles => :app do
  input = ''
  run "cd #{current_path} && ./script/console #{ENV['RAILS_ENV']}" do |channel, stream, data|
    next if data.chomp == input.chomp || data.chomp == ''
    print data
    channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
  end
end
