lock "~> 3.16"

# making Rails.application available here
require File.expand_path("./environment", __dir__)

load File.expand_path('../deploy/tagit.rb', __FILE__)
require File.expand_path('../deploy/cap_notify', __FILE__)

set :application, "ORTE-backend"
set :repo_url, "git@github.com:a-thousand-channels/ORTE-backend.git"
set :deploy_to, "/home/orte-deploy/#{fetch(:application)}-#{fetch(:stage)}"
set :ssh_options, forward_agent: true, verify_host_key: :always
set :keep_releases, 3
set :rvm_type, :user
set :bundle_flags,    ''
set :bundle_without, [:development]
# set :bundle_dir,      ''
# set :bundle_path, nil
set :bundle_binstubs, nil
set :notify_emails, ['']

# append :linked_files, "config/secrets.yml"
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/master.key')
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing,  'deploy:restart'

  desc 'Send email notification'
  task :send_notification do
    on roles(:app) do
      current = fetch(:current_revision)
      previous = fetch(:previous_revision)
      branch = fetch(:branch)
      git_log = "\n" + '-' * 63
      git_log += "\n=== #{fetch(:application).capitalize} - #{fetch(:stage).capitalize}\n\n"
      git_log += "=== Deployed Branch: #{branch}\n"
      git_log += "=== Deployed Revision: #{current}\n"
      git_log += "=== Previous Revision: #{previous}\n\n"

      # If deployed master branch, show the difference between the last 2 deployments
      # or show the difference between master and the deployed branch.
      # base_rev, new_rev = branch != "master" ? ["master", branch] : [previous, current]
      base_rev = previous
      new_rev = current

      # Show difference between master and deployed revisions.
      if (diff = `git log #{base_rev}..#{new_rev} --oneline`) != ''
        git_log += "=== Difference between current revision and deployed revision:\n\n"
        # Colorize refs
        # Indent commit messages nicely, max 80 chars per line, line has to end with space.
        logline = diff.gsub(/^([a-f0-9]+) /, '\\1 - ')
                      .gsub("\n", "\n    ")
                      .split("\n").map { |l|
                        l.scan(/.{1,120}/).join("\n" << ' ' * 14)
                         .gsub(/([^ ]*)\n {14}/m, "\n" << ' ' * 14 << '\\1')
                       }
                      .join("\n")
        git_log += "    #{logline}\n"
      else
        git_log += "=== Deployed the last revision again.\n\n"
      end
      puts git_log
      Notifier.deploy_notification(fetch(:notify_emails), fetch(:stage), git_log).deliver
    end
  end

  desc 'Backup the remote database'
  task :db_backup do
    on roles(:db) do
      filename = "#{fetch(:application)}-#{fetch(:rails_env)}.dump.#{Time.now.to_i}.sql"
      dump_dir = "#{shared_path}/dumps"
      file = "#{dump_dir}/#{filename}"
      execute "mkdir -p #{dump_dir}"
      db = YAML.safe_load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result, [], [], true)[fetch(:rails_env).to_s]

      execute "mysqldump -u #{db['username']} --password=#{db['password']} #{db['database']} > #{file}"
    end
  end

  before :migrate,    'deploy:db_backup'
  after :updating,    'deploy:tagit'
  after :publishing,  'deploy:send_notification'

end