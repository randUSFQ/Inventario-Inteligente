# Usar una imagen base de Ubuntu estable
FROM ubuntu:24.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar repositorios e instalar Apache 2.4 y dependencias básicas
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    gnupg \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Configurar el repositorio oficial de Oracle para instalar MySQL 9.7 LTS
RUN curl -OL https://mysql.com \
    && dpkg -i mysql-apt-config_0.8.32-1_all.deb \
    && apt-get update \
    && apt-get install -y mysql-server \
    && rm -f mysql-apt-config_0.8.32-1_all.deb

# Exponer los puertos de Apache (80) y MySQL (3306)
EXPOSE 80 3306

# Crear un script de inicio para arrancar ambos servicios simultáneamente
RUN echo '#!/bin/bash\n\
service mysql start\n\
echo "Arrancando Apache..." \n\
exec apache2ctl -D FOREGROUND' > /usr/local/bin/start-services.sh \
    && chmod +x /usr/local/bin/start-services.sh

# Definir el script como el punto de entrada predeterminado
CMD ["/usr/local/bin/start-services.sh"]
