Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ['http://localhost:8080', 'https://twatanabe-doit-backend.herokuapp.com']
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end