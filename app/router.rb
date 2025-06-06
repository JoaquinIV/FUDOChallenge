require 'rack'
require_relative 'controllers/auth_controller'
require_relative 'controllers/products_controller'

class Router
  
  # El punto de entrada principal para el router, llamado por el servidor Rack.
  # @param env [Hash] El hash de entorno de Rack.
  # @return [Array] una respuesta estándar de Rack.
  def call(env)
    
    request = Rack::Request.new(env)
    path = request.path_info

    puts "INFO: Enrutando la solicitud para '#{request.request_method} #{path}'"

    case path
    when '/'
      [200, { 'content-type' => 'application/json' }, [{ message: "¡Bienvenido a la API de Rack!" }.to_json]]
    when '/authenticate'
      AuthController.new.authenticate(request)
    when '/products'
      ProductsController.new.create(request)
    when %r{/products/(.+)}
      # La expresión regular %r{/products/(.+)} captura el ID del producto de la URL.
      # $1 contiene el primer grupo de captura de la coincidencia de la expresión regular (el ID del producto).
      product_id = $1
      puts "DEBUG: ID de producto extraído '#{product_id}' de la ruta."
      ProductsController.new.show(request, product_id)
    else
      # Si ninguna ruta coincide, devolvemos una respuesta 404 No encontrado.
      puts "WARN: No se encontró ninguna ruta para la ruta: #{path}"
      [404, { 'content-type' => 'application/json' }, [{ message: "No encontrado: La ruta '#{path}' no existe." }.to_json]]
    end
  end
end 