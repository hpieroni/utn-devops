#!/bin/bash

### Aprovisionamiento de software ###

# Actualizo los paquetes de la maquina virtual
apt-get update

#Desintalo el servidor web instalado previamente en la unidad 1,
# a partir de ahora va a estar en un contenedor de Docker.
if [ -x "$(command -v apache2)" ];then
	apt-get remove --purge apache2 -y
	apt autoremove -y
fi

# Directorio para los archivos de la base de datos Mongo. El servidor de la base de datos
# es instalado mediante una imagen de Docker. Esto está definido en el archivo
# docker-compose.yml
if [ ! -d "/var/db/mongo" ]; then
	mkdir -p /var/db/mongo
fi

# Muevo el archivo de configuración de firewall al lugar correspondiente
if [ -f "/tmp/ufw" ]; then
	mv -f /tmp/ufw /etc/default/ufw
fi

# Swap
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

######## Instalacion de DOCKER ########
#
# Esta instalación de docker es para demostrar el aprovisionamiento
# complejo mediante Vagrant. La herramienta Vagrant por si misma permite
# un aprovisionamiento de container mediante el archivo Vagrantfile. A fines
# del ejemplo que se desea mostrar en esta unidad que es la instalación mediante paquetes del
# software Docker este ejemplo es suficiente, para un uso más avanzado de Vagrant
# se puede consultar la documentación oficial en https://www.vagrantup.com
#
if [ ! -x "$(command -v docker)" ]; then
	apt-get install -y apt-transport-https ca-certificates curl software-properties-common

	##Configuramos el repositorio
	curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" > /tmp/docker_gpg
	apt-key add < /tmp/docker_gpg && rm -f /tmp/docker_gpg
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

	#Actualizo los paquetes con los nuevos repositorios
	apt-get update -y

	#Instalo docker desde el repositorio oficial
	apt-get install -y docker-ce docker-compose

	#Lo configuro para que inicie en el arranque
	systemctl enable docker
fi

## aplicación

TMP="/tmp"
APP_PATH="$TMP/utn-devops-app/"
cd $TMP
echo "clono el repositorio"
git clone https://github.com/hpieroni/utn-devops-app.git
cd $APP_PATH
git checkout unidad-2
