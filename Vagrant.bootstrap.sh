#!/bin/bash

### Aprovisionamiento de software ###

# Actualizo los paquetes de la maquina virtual
apt-get update

# Instalo un servidor web
apt-get install -y apache2 

### Configuración del entorno ###

## Genero una partición swap. Previene errores de falta de memoria
if [ ! -f "/swapdir/swapfile" ]; then
	mkdir /swapdir
	cd /swapdir
	dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=2000000
	mkswap -f  /swapdir/swapfile
	chmod 600 /swapdir/swapfile
	swapon swapfile
	echo "/swapdir/swapfile       none    swap    sw      0       0" | tee -a /etc/fstab /etc/fstab
	sysctl vm.swappiness=10
	echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
fi

# ruta raíz del servidor web
APACHE_ROOT="/var/www"
# ruta de la aplicación
APP_PATH="$APACHE_ROOT/utn-devops-app"


## configuración servidor web
# copio el archivo de configuración del repositorio en la configuración del servidor web
if [ -f "/tmp/devops.site.conf" ]; then
	echo "Copio el archivo de configuracion de apache"
	mv /tmp/devops.site.conf /etc/apache2/sites-available
	# activo el nuevo sitio web
	a2ensite devops.site.conf
	# desactivo el default
	a2dissite 000-default.conf
	# refresco el servicio del servidor web para que tome la nueva configuración
	service apache2 reload
fi
	
## aplicación

# descargo la app del repositorio
if [ ! -d "$APP_PATH" ]; then
	echo "clono el repositorio"
	cd $APACHE_ROOT
	git clone https://github.com/hpieroni/utn-devops-app.git
	cd $APP_PATH
	git checkout unidad-1
fi