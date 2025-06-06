require 'dotenv'
Dotenv.load

require_relative 'app/router'
require_relative 'app/middleware/authentication'
require_relative 'app/middleware/cache_control'

puts "INFO: Aplicación iniciándose en modo #{ENV['RACK_ENV'] || 'desarrollo'}."

# --- Pila de middleware ---
# 0. Servir archivos estáticos
# Rack::Static sirve archivos desde el directorio 'public'.
# La opción `urls` especifica qué rutas activarán el servicio de archivos estáticos.
# La opción `root` especifica el directorio desde el cual servir los archivos.
use Rack::Static, urls: ["/openapi.yaml", "/AUTHORS"], root: 'public'
puts "INFO: Middleware Rack::Static habilitado para servir archivos desde el directorio 'public'."

# 1. Compresión Gzip
# Rack::Deflater comprimirá automáticamente las respuestas con Gzip
# si el cliente envía el encabezado 'Accept-Encoding: gzip'.
# Esta debe ser una de las capas exteriores para comprimir la respuesta final.
use Rack::Deflater
puts "INFO: Middleware Rack::Deflater (compresión Gzip) habilitado."

# 2. Control de Cache
use CacheControl
puts "INFO: Middleware de CacheControl personalizado habilitado."

# 3. Autenticación
use Authentication
puts "INFO: Middleware de autenticación personalizado habilitado."


run Router.new 