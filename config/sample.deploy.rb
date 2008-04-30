# =============================================================================
# REQUIRED VARIABLES
# =============================================================================

set :application, "my_site.com"

# You may need to set one or more of these.
set :user, "flippy"            # defaults to the currently logged in user
set :deploy_to, "/home/#{user}/#{application}" # defaults to "/u/apps/#{application}"

# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# Don't touch unless you know what you are doing
# =============================================================================

# Leave this unless you are storing your own copy elsewhere.
set :repository, "http://topfunky.net/svn/gullery"

role :web, application
role :app, application
role :db,  application, :primary => true

desc "Copy production database config file."
task :after_symlink do
  run "cp #{shared_path}/config/database.yml #{current_path}/config/database.yml"
end

desc "Restart for shared hosts"
task :restart do
  run "#{current_path}/script/process/reaper --dispatcher=dispatch.fcgi"
end
