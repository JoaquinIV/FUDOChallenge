require 'singleton'
require 'thread'

# ProductStore es un almacén de datos en memoria para productos.
# Está diseñado para ser seguro para subprocesos para manejar solicitudes concurrentes.
class ProductStore
  # Inicializa el almacén con un mutex para la seguridad de los subprocesos y un hash vacío para los datos.
  def initialize
    # Se utiliza un Mutex para garantizar que las escrituras en el hash @products sean atómicas,
    # evitando condiciones de carrera cuando varios subprocesos (p. ej., de trabajos en segundo plano)
    # intentan modificar el almacén al mismo tiempo.
    @mutex = Mutex.new
    @products = {}
    puts "INFO: ProductStore en memoria inicializado."
  end

  # Guarda un producto en el almacén.
  # @param id [String] El identificador único del producto.
  # @param data [Hash] Los datos del producto.
  def save(id, data)
    # El bloque `synchronize` garantiza que ningún otro subproceso pueda ejecutar el código
    # dentro de este bloque al mismo tiempo, lo que proporciona seguridad para los subprocesos.
    @mutex.synchronize do
      puts "INFO: Guardando el producto con ID #{id} en el almacén."
      @products[id] = data
    end
  end

  # Encuentra un producto por su ID.
  # @param id [String] El ID del producto a buscar.
  # @return [Hash, nil] Los datos del producto o nil si no se encuentran.
  def find(id)
    puts "INFO: Buscando producto con ID #{id} en el almacén."
    @products[id]
  end
end 