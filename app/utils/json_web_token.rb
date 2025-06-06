require 'jwt'

# Servicio para manejar la codificación y decodificación de JSON Web Tokens (JWT).
class JsonWebToken

  SECRET_KEY = ENV['JWT_SECRET_KEY']

  # Codifica un payload en un JWT.
  # @param payload [Hash] Los datos a incluir en el token.
  # @param exp [Time] El tiempo de expiración del token (por defecto 24 horas).
  # @return [String] El token JWT codificado.
  def self.encode(payload, exp = Time.now + 24 * 60 * 60)
    # Agrega la expiración al payload.
    payload[:exp] = exp.to_i
    # Codifica el payload usando la clave secreta y el algoritmo HS256.
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodifica un JWT.
  # @param token [String] El token JWT a decodificar.
  # @return [Hash, nil] El payload decodificado si el token es válido, de lo contrario nil.
  def self.decode(token)
    # Decodifica el token, especificando el algoritmo para mayor seguridad.
    body = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    # Las claves del payload son cadenas.
    body
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    # Captura errores si el token ha expirado o la firma es inválida.
    puts "ERROR: [JWT] Error de decodificación - #{e.message}"
    nil
  rescue JWT::DecodeError => e
    # Captura errores si el token está mal formado.
    puts "ERROR: [JWT] Error de formato - #{e.message}"
    nil
  end
end 