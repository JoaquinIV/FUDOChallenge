FROM ruby:3.1-slim

WORKDIR /usr/src/app


COPY Gemfile Gemfile.lock ./


RUN bundle install

# Copia el resto del código de la aplicación al directorio de trabajo
COPY . .

# Expone el puerto en el que se ejecuta la aplicación
EXPOSE 9292

# El comando principal para ejecutar la aplicación
# rackup iniciará el servidor usando el archivo config.ru por defecto
# --host 0.0.0.0 es crucial para que sea accesible desde fuera del contenedor
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"] 