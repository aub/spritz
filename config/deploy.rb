### General settings
set :application, "artistcommon.com"
set :repository,  "set your repository location here"
set :user, "deployer"
set :port, 31268
set :runner, "aubrey"
set :deploy_to, "/home/aubrey/public_html/#{application}"

### Git-related settings
default_run_options[:pty] = true
set :repository,  "git@github.com:aub/builder.git"
set :scm, "git"
set :scm_passphrase, "str8up" #This is your custom users password
set :deploy_via, :remote_cache
#set :branch, "origin/master" # If a specific branch is needed.

### Roles
role :app, "67.207.136.137"
role :web, "67.207.136.137"
role :db,  "67.207.136.137", :primary => true

### Dependencies to be checked
depend :remote, :gem, "haml", ">= 1.8.2"
depend :remote, :gem, "will_paginate", ">= 2.1.0"
depend :remote, :gem, "liquid", ">= 1.7.0"

### Custom tasks

desc "Fix the need to change the permissions on the tmp directory."
task :after_symlink, :roles => :app do
  run "chmod g+w #{deploy_to}/current/tmp"
end

namespace :deploy do

  desc "Override the regular spinner to use ours"
  task :spinner, :roles => :app do
    start
  end

  desc "Restart the mongrel cluster"
  task :restart, :roles => :app do
    stop 
    start
  end

  desc "Start the mongrel cluster"
  task :start, :roles => :app do
    start_mongrel
  end

  desc "Stop the mongrel cluster"
  task :stop, :roles => :app do
    stop_mongrel
  end

  desc "Start Mongrel"
  task :start_mongrel, :roles => :app do
    begin
      run "mongrel_cluster_ctl start"
    rescue RuntimeError => e
      puts e
      puts "Mongrel appears to be up already."
    end
  end

  desc "Stop Mongrel"
  task :stop_mongrel, :roles => :app do
    begin
      run "mongrel_cluster_ctl stop"
    rescue RuntimeError => e
      puts e
      puts "Mongrel appears to be down already."
    end
  end
end

desc "tail production log files" 
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}" 
    break if stream == :err    
  end
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

namespace :assets do
  
  desc "Remove existing directories and link to the shared ones"
  task :symlink, :roles => :app do
    assets.create_dirs
    run <<-CMD
      rm -rf  #{current_path}/public/assets &&
      ln -nfs #{shared_path}/assets #{current_path}/public/assets
    CMD
  end
  
  desc "Create the shared directories"
  task :create_dirs, :roles => :app do
    run "mkdir -p #{shared_path}/assets"
  end
end

after "deploy:update_code", "assets:symlink"