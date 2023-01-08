Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000'

    resource '*',
             headers: :any,
             methods: [:post, :get, :put, :patch, :delete, :options, :head]
  end

  allow do
    origins 'http://127.0.0.1:3000'

    resource '*',
             headers: :any,
             methods: [:post, :get, :put, :patch, :delete, :options, :head]
  end
end

#Rails.application.config.middleware.insert_before 0, Rack::Cors do
#  allow do
#    origins 'http://localhost:3000'
#    resource '*',
#             headers: :any,
#             methods: [:post, :get, :put, :patch, :delete, :options, :head]
#  end

#  allow do
#    origins 'http://localhost:8080'
#    resource '*',
#             headers: :any,
#             methods: [:post, :get, :put, :patch, :delete, :options, :head]
#  end
#end