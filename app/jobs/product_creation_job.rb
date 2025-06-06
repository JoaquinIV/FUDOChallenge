require 'sucker_punch'
require_relative '../stores/product_store'

# ProductCreationJob es un trabajo en segundo plano que se encarga de la creación de un producto.
# Incluye un retraso para simular una tarea asíncrona.
class ProductCreationJob
  include SuckerPunch::Job

  # El número de hilos de trabajo para iniciar para este trabajo.
  workers 2

  # La lógica principal del trabajo.
  # @param product_data [Hash] Los datos del producto que se creará.
  def perform(product_data)
    product_id = product_data['id']
    puts "INFO: [Job-#{self.class.name}] Se inició el procesamiento para el ID de producto: #{product_id}."

    # Simule un retraso de 5 segundos para el proceso de creación asíncrono.
    puts "INFO: [Job-#{self.class.name}] Simulando un retraso de creación de 5 segundos para el ID de producto: #{product_id}..."
    sleep 5

    # Accede a la instancia singleton de la tienda y guarda el producto.
    ProductStore.instance.save(product_id, product_data)
    
    puts "INFO: [Job-#{self.class.name}] Producto creado con éxito con ID: #{product_id}."
  end
end 