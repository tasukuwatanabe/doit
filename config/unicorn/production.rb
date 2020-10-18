worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true # 更新時ダウンタイム無し

app_path = '/var/www/rails/doit'
app_shared_path = "#{app_path}/shared"
working_directory "#{app_path}/current/"

listen "#{app_shared_path}/tmp/sockets/unicorn.sock"

stdout_path "#{app_shared_path}/log/unicorn.stdout.log"
stderr_path "#{app_shared_path}/log/unicorn.stderr.log"

pid "#{app_shared_path}/tmp/pids/unicorn.pid"

# ログの出力
stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
