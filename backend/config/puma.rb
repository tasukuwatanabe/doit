app_path = File.expand_path("..", __dir__)
directory app_path
pidfile "#{app_path}/tmp/pids/puma.pid"
state_path "#{app_path}/tmp/pids/puma.state"
threads 0, 16
bind "unix://#{app_path}/tmp/sockets/puma.sock"
activate_control_app