namespace :nginx do
  desc 'restart nginx'
  task restart: :environment do
    on roles(:web) do
      sudo 'service nginx restart'
    end
  end
end
