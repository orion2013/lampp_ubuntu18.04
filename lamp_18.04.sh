#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 18.04 Dev Server
# Ejecuta el scripts llamado lamp_18.04.sh
# La secuencia de comandos debe terminar automáticamente 

echo -e "\e[96m Preparando Sistema  \e[39m"
sudo apt-get update
sudo apt-get upgrade

echo -e "\e[96m Instalando Apache2  \e[39m"
sudo apt-get -y install apache2


echo -e "\e[96m Instalando php7  \e[39m"
sudo apt-get -y install php7.1 libapache2-mod-php7.1 

# Instalando algunas extensiones de php
sudo apt-get -y install curl mcrypt php7.1-mysql php7.1-mcrypt php7.1-curl php7.1-json php7.1-mbstring php7.1-gd php7.1-intl php7.1-xml php7.1-zip php-gettext php7.1-pgsql 
#sudo apt-get -y install php-xdebug
sudo phpenmod mcrypt
sudo phpenmod curl

# Habilitar algunos módulos de apache
sudo a2enmod rewrite
#sudo a2enmod headers

echo -e "\e[96m Reinicio del servidor apache para reflejar los cambios  \e[39m"
sudo service apache2 restart

echo -e "\e[96m Instalando Mysql Server  \e[39m"
echo -e "\e[93m Determinando Usuario: root, Contraseña: root por defecto  \e[39m"

# Instalando servidor MySQL en un modo no interactivo. La contraseña de usario "root" predeterminada será "root"
echo "mysql-server-5.7 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password root" | sudo debconf-set-selections
sudo apt-get -y install mysql-server-5.7

### Ejecute el siguiente comando en el servidor de producción
#sudo mysql_secure_installation

# Descargando y instalando composer (manejador de dependencias de php) 
echo -e "\e[96m Instalando composer \e[39m"
# Nota: El comando siguiente usa la opcion manual de instalacion
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer


# Comprueba la versión de php
php -v

# Comprueba la versión de apache
apachectl -v

# Comprueba la versión de mysql
mysql --version

# Comprueba si php está funcionando o no
php -r 'echo "\nTu instalación de PHP está funcionando bien.\n";'

# Arreglar los permisos de la carpeta del composer
#sudo chown -R $USER $HOME/.composer

# Comprueba la versión de composer
composer --version

echo -e "\e[96m Inicia la instalación silenciosa de phpMyAdmin \e[39m"

# Agregar phpMyAdmin PPA para la última versión (Disponible solo para ubuntu 16.04)
# ¡¡¡Advertencia!!! No agregue este PPA si está ejecutando php v5.6 
# sudo add-apt-repository -y ppa:nijel/phpmyadmin
# sudo apt-get update 

echo -e "\e[93m Determinando :Usuario: root, Contraseña: root por defecto \e[39m"
# Establecer modo no interactivo
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'﻿
# Instalancion phpmyadmin 
sudo apt-get -y install phpmyadmin

# Reiniciando servidor apache
sudo service apache2 restart

# Procesos pos.instalacion 
sudo apt-get update -y && echo "" && \
sudo apt-get dist-upgrade -y && echo "" && \
sudo apt-get upgrade -y && echo "" && \
sudo apt-get autoremove -y && echo "" && \
sudo deborphan | xargs sudo apt-get remove -y --purge && echo "" && \
sudo apt-get autoclean -y && echo "" && \

echo -e "\e[92m Proceso de instalacion de componentes terminado... \e[39m"
echo -e "\e[92m Escriba la siguiente dirección en su navegador http://localhost/ ,Verifica si apache esta trabajando correctamente o no. \e[39m"
echo -e "\e[92m Escriba la siguiente dirección en su navegador http://localhost/phpinfo.php para verificar version de php instalada \e[39m"
echo -e "\e[92m Escriba la siguiente dirección en su navegador http://localhost/phpmyadmin para entrar al servicio grafico de base de datos mysql \e[39m"

sudo apt-get clean

