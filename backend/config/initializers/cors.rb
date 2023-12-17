Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ['http://localhost:8080', 'https://app.doit-plan.com']
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
