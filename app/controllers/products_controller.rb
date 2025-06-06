require 'json'
require_relative '../services/product_service'

# ProductsController maneja las solicitudes HTTP relacionadas con los productos.
# Es responsable de orquestar la creación y recuperación de productos.
class ProductsController
  # Maneja la creación asíncrona de un nuevo producto.
  # @param request [Rack::Request] El objeto de solicitud entrante.
  # @return [Array] Una respuesta estándar de Rack.
  def create(request)
    unless request.post?
      puts "WARN: Se recibió una solicitud que no es POST para el punto final /products."
      return [405, { 'content-type' => 'application/json' }, [{ message: 'Método no permitido' }.to_json]]
    end

    begin
      product_data = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      puts "ERROR: No se pudo analizar el cuerpo JSON para la creación del producto: #{e.message}"
      return [400, { 'content-type' => 'application/json' }, [{ message: 'JSON no válido en el cuerpo de la solicitud' }.to_json]]
    end

    # Delegar la lógica de negocio al ProductService.
    product_id = ProductService.create_async(product_data)

    response_body = {
      message: 'La solicitud de creación del producto se aceptó y se está procesando.',
      product_id: product_id
    }
    [202, { 'content-type' => 'application/json' }, [response_body.to_json]]
  end

  # Recupera un producto por su ID.
  # @param request [Rack::Request] El objeto de solicitud entrante.
  # @param product_id [String] El ID del producto a recuperar.
  # @return [Array] Una respuesta estándar de Rack.
  def show(request, product_id)
    # Delegar la lógica de negocio al ProductService.
    product = ProductService.find(product_id)

    if product
      puts "INFO: Producto con ID #{product_id} encontrado."
      [200, { 'content-type' => 'application/json' }, [product.to_json]]
    else
      puts "WARN: Producto con ID #{product_id} no encontrado."
      [404, { 'content-type' => 'application/json' }, [{ message: 'Producto no encontrado' }.to_json]]
    end
  end
end 