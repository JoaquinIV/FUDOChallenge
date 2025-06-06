require 'json'
require_relative '../utils/json_web_token'

# Middleware de autenticación para proteger ciertas rutas.
# Comprueba si hay un token de portador válido en el encabezado de autorización.
class Authentication
  # Rutas incluidas en la lista blanca que no requieren autenticación.
  NON_PROTECTED_PATHS = Set.new(['/', '/authenticate'])

  # @param app [Object] El siguiente middleware o aplicación en la pila de Rack.
  def initialize(app)
    @app = app
    puts "INFO: Middleware de autenticación inicializado."
  end

  # La lógica principal del middleware.
  # @param env [Hash] El entorno de Rack.
  # @return [Array] Una respuesta estándar de Rack.
  def call(env)
    path = env['PATH_INFO']

    # Si la ruta no está protegida, pase la solicitud a la pila inmediatamente.
    if NON_PROTECTED_PATHS.include?(path)
      puts "DEBUG: [Auth] La ruta '#{path}' no está protegida. Omitiendo autenticación."
      return @app.call(env)
    end

    # Para rutas protegidas, verificamos el encabezado de autorización.
    auth_header = env['HTTP_AUTHORIZATION']
    puts "DEBUG: [Auth] Comprobando la autenticación para la ruta protegida: '#{path}'"

    # Verificamos si el encabezado está presente y formateado correctamente como "Bearer <token>".
    unless auth_header && auth_header.start_with?('Bearer ')
      puts "WARN: [Auth] Falta el encabezado de autorización o está mal formado."
      return [401, { 'content-type' => 'application/json' }, [{ message: 'Falta el encabezado de autorización o no es válido' }.to_json]]
    end

    token = auth_header.split(' ').last

    decoded_token = JsonWebToken.decode(token)
    if decoded_token
      puts "INFO: [Auth] El token es válido. Payload: #{decoded_token}. Permitiendo el acceso a '#{path}'."
      @app.call(env) 
    else
      puts "WARN: [Auth] Se recibió un token no válido o caducado."
      [401, { 'content-type' => 'application/json' }, [{ message: 'Token no válido o caducado' }.to_json]]
    end
  end
end 