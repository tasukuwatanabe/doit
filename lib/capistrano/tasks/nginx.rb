namespace :nginx do
  desc 'restart nginx'
  task command do
    on roles(:web) do
      sudo 'service nginx restart'
    end
  end
end
