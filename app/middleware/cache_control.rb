require 'rack'

class CacheControl
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    path = env['PATH_INFO']

    if path == '/openapi.yaml'
      headers['Cache-Control'] = 'no-cache'
    elsif path == '/AUTHORS'
      headers['Cache-Control'] = 'public, max-age=86400'
    end

    [status, headers, response]
  end
end 