require 'json'
require 'rack'
require_relative '../services/authentication_service'

# AuthController maneja la lógica de autenticación.
class AuthController
  # Maneja la solicitud de autenticación.
  # @param request [Rack::Request] El objeto de solicitud que contiene todos los datos de la solicitud HTTP.
  # @return [Array] Una respuesta estándar de Rack (estado, encabezados, cuerpo).
  def authenticate(request)
    unless request.post?
      puts "WARN: Se recibió una solicitud que no es POST para el punto final /authenticate."
      return [405, { 'content-type' => 'application/json' }, [{ message: 'Método no permitido' }.to_json]]
    end

    begin
      params = JSON.parse(request.body.read)
      username = params['username']
      password = params['password']
      
      puts "DEBUG: Parámetros analizados: username='#{username}'"
    rescue JSON::ParserError => e
      puts "ERROR: No se pudo analizar el cuerpo JSON: #{e.message}"
      return [400, { 'content-type' => 'application/json' }, [{ message: 'JSON no válido o mal formado en el cuerpo de la solicitud' }.to_json]]
    end

    # Delegar la lógica de negocio al AuthenticationService.
    token = AuthenticationService.authenticate(username, password)

    if token
      [200, { 'content-type' => 'application/json' }, [{ token: token }.to_json]]
    else
      [401, { 'content-type' => 'application/json' }, [{ message: 'Nombre de usuario o contraseña no válidos' }.to_json]]
    end
  end
end 