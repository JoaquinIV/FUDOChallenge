require 'securerandom'
require_relative '../jobs/product_creation_job'
require_relative '../stores/product_store'

# ProductService encapsula la lógica de negocio para gestionar productos.
class ProductService
  # Inicia el proceso de creación asíncrono de un producto.
  # Asigna un ID único y pone en cola un trabajo en segundo plano para procesarlo.
  # @param product_data [Hash] Los datos del producto recibidos de la solicitud.
  # @return [String] El ID único asignado al nuevo producto.
  def self.create_async(product_data)
    product_data['id'] = SecureRandom.uuid
    puts "DEBUG: Datos del producto preparados para el trabajo en segundo plano: #{product_data}"

    ProductCreationJob.perform_async(product_data)
    puts "INFO: ProductCreationJob en cola para el ID de producto: #{product_data['id']}"

    product_data['id']
  end

  # Busca un producto por su ID.
  # @param product_id [String] El ID del producto a buscar.
  # @return [Hash, nil] El producto encontrado, o nil si no existe.
  def self.find(product_id)
    puts "INFO: Buscando producto con ID '#{product_id}' a través del servicio."
    ProductStore.instance.find(product_id)
  end
end 