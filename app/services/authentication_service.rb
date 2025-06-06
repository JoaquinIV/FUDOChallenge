require_relative '../utils/json_web_token'

# AuthenticationService encapsula la lógica de negocio para la autenticación de usuarios.
class AuthenticationService
  # Autentica a un usuario basándose en el nombre de usuario y la contraseña.
  # @param username [String] El nombre de usuario a autenticar.
  # @param password [String] La contraseña para el usuario.
  # @return [String, nil] Un token JWT si las credenciales son válidas, de lo contrario nil.
  def self.authenticate(username, password)
    puts "INFO: Autenticando al usuario '#{username}' a través del servicio."

    # En una aplicación real, esta lógica buscaría a un usuario en una base de datos
    # y compararía de forma segura una contraseña hash y username.
    # Para este ejemplo, estamos utilizando credenciales codificadas de variables de entorno.
    if username == ENV['API_USERNAME'] && password == ENV['API_PASSWORD']
      puts "INFO: Usuario '#{username}' autenticado con éxito."
      # Genera un token JWT para el usuario autenticado.
      JsonWebToken.encode(user_id: username)
    else
      puts "WARN: Intento de autenticación fallido para el usuario '#{username}'."
      nil
    end
  end
end 