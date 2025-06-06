# API de Productos con Rack

Esta es una API simple construida con Rack que expone endpoints para autenticación y gestión de productos.

## Configuración de Variables de Entorno

Antes de iniciar la aplicación, es necesario configurar las siguientes variables de entorno:

- `API_USERNAME`: El nombre de usuario para la autenticación en la API.
- `API_PASSWORD`: La contraseña para la autenticación en la API.
- `JWT_SECRET_KEY`: La clave secreta utilizada para firmar los JSON Web Tokens (JWT).

Se debe crear un archivo `.env` con las variables de entorno. (Se presenta un ejemplo en el archivo `.env.example`)

## Cómo Levantar el Proyecto

Hay dos maneras de levantar el proyecto: usando Ruby directamente o usando Docker.

### Usando Ruby

**Requisitos:**
- Ruby
- Bundler

**Pasos:**

1.  **Instalar dependencias:**
    
    ```bash
    bundle install
    ```
    
2.  **Iniciar el servidor:**
    
    ```bash
    bundle exec rackup
    ```
    
    El servidor se iniciará en `http://localhost:9292`.

### Usando Docker

**Requisitos:**
- Docker
- Docker Compose

**Pasos:**

1.  **Construir y levantar los contenedores:**
    
    ```bash
    docker-compose up
    ```
    
    El servidor estará disponible en `http://localhost:9292`.

## Endpoints de la API

### Autenticación

#### `POST /authenticate`

Autentica a un usuario y devuelve un token JWT para ser usado en las rutas protegidas.

**Request Body:**

```json
{
  "username": "admin",
  "password": "password"
}
```

**Response (200 OK):**

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE2OD...}"
}
```

### Productos

Estos endpoints requieren un token de autenticación. El token debe ser enviado en el encabezado `Authorization` como `Bearer <token>`.

#### `POST /products`

Crea un nuevo producto de forma asíncrona. La solicitud es aceptada y procesada en segundo plano.

**Headers:**

- `Authorization: Bearer <tu-jwt-aqui>`

**Request Body:**

Cualquier objeto JSON que represente un producto. Por ejemplo:

```json
{
  "name": "Laptop",
  "price": 1200
}
```

**Response (202 Accepted):**

Indica que la solicitud fue aceptada y está siendo procesada. Devuelve el ID del producto que será creado.

```json
{
  "message": "La solicitud de creación del producto se aceptó y se está procesando.",
  "product_id": "un-uuid-generado"
}
```

#### `GET /products/{id}`

Obtiene la información de un producto específico por su ID.

**Headers:**

- `Authorization: Bearer <tu-jwt-aqui>`

**URL Params:**

- `id`: El ID del producto a obtener.

**Response (200 OK):**

```json
{
  "id": "un-uuid-generado",
  "name": "Laptop",
  "price": 1200
}
```

**Response (404 Not Found):**

Si el producto con el ID especificado no existe.

```json
{
  "message": "Producto no encontrado"
}
```

### Otros

#### `GET /`

Endpoint de bienvenida. No requiere autenticación.

**Response (200 OK):**

```json
{
  "message": "¡Bienvenido a la API de Rack!"
}
```

#### `GET /openapi.yaml` y `GET /AUTHORS`

Sirve archivos estáticos. No requieren autenticación. 