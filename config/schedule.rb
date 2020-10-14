require File.expand_path(File.dirname(__FILE__) + '/environment')

set :output, 'log/crontab.log'
set :environment, :production
set :env_path,    '"$HOME/.rbenv/shims":"$HOME/.rbenv/bin"'

job_type :runner, %q{ cd :path && PATH=:env_path:"$PATH" bin/rails runner -e :environment ':task' :output }

every 1.minute do
  runner 'Batch::Guest.destroy'
end
