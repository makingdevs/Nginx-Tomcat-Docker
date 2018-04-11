# README

## Docker Nginx - Tomcat 

Este repo contiene la instalación con docker de Nginx y Tomcat, elementos personalizables como virtualhost y configuracion

### Prepación

Tenemos que tener instalado:

```
- brew install docker
- brew install docker-machine 
```

### Creacion de docker machine 

Primeramente tenmos que tener una maquina de docker, esta puede ser virtualbox o amazon(ec2). `--driver virtualbox` o `--driver amazonec2`.

```
docker-machine create --driver virtualbox <nombre de la maquina>
```

En el caso de virtualbox no necesitamos mucho mas que el nombre y listo. En el caso de amazon necesitamos algunos parametros mas, como son el id de la vpc y la region (estos facilmente los podras encontrar desde la consola de amazon).

```
docker-machine create --driver amazonec2 --amazonec2-region us-east-1 --amazonec2-vpc-id vpc-12345617 <Nombre de la maquina>
```

En el caso de amazon es necesario tener nuestro archvio `~/.aws/credentials`

```
[default]
aws_access_key_id = <aws_access_key_id>
aws_secret_access_key = <aws_secret_access_key>
```

Con ls nos mostrara las maquinas creadas, con el nombre asignado e ip asignada

```
docker-machine ls
```
Para conectarte a la maquina basta con ingresar el siguiente comando.

```
docker-machine env <Nombre de la maquina>
```

Si no tenemos los parametros de entorno cargados, podemos ejecutar el siguiente comando 

```
eval $(docker-machine env <Nombre de maquina>)
```

Listo, con ellos tendremos lista nuestra maquina para intalar la imagen de nginx - jenkins en ella.

### Creando nuestro docker container con Nginx - Tomcat 

Clonamos el repo y nos posicionamos dentro de el. El primer paso sera construir la imagen de docker la cual instalaremos a nuestra maquina previamente creada. Podremos nombrar nuestra imagen como queramos.

Los elementos personalizables son los siguientes:

- URL_WAR=URL_DEL_WAR_A_DEPLOYAR 
- FILE_NAME_CONFIGURATION=ARCHIVO_CONF.groovy -- Este arhcivo debe de estar dentro del repo -- 
- PATH_NAME_CONFIGURATION=PATH_DE_LA_CONFIG_DEL_PROYECTO -- /root es el home del container
- HOST_NAME=web.domain.com -- Dominio de nginx

```
docker build --build-arg URL_WAR=http://url.com --build-arg FILE_NAME_CONFIGURATION=application.groovy --build-arg PATH_NAME_CONFIGURATION=/root/.config/ --build-arg HOST_NAME=web.domain.com -t <Nombre de la imagen> .
```

Una vez terminado tendremos lista nuestra imagen para ejecutarla.

```
docker run --name <Nombre del proceso> -p 80:80 -d <Nombre de la imagen>

docker ps 
```

Con `docker ps ` nos aseguramos de que el proceso se encuntre activo y listo con ellos ya tenemos un nginx y tomcat ejecutandose dentro de nuestra maquina.

Si estas en una maquina virtual host agrega esto en tu archivo 'hosts' de tu maquina (en OSX es /private/etc/hosts)

```

127.0.0.1 qa.dominio.com (127.0.0.1 remplazalo por la ip de la maquina de docker, con docker-machine ls puedes ver la ip)

```

### Log de Nginx, catalina y 

```
docker logs -f <Nombre del proceso> | grep nginx

docker logs -f <Nombre del proceso> | grep catalina
```

### Otros comandos utiles

```
docker stop <Nombre del proceso> --Para detener el proceso 
docker rm <Nombre del proceso> --Para eliminar el proceso 
docker exec -i -t <Nombre del proceso> /bin/bash
```

### Exportar o importar docker machiner

```
./docker-machine-export.sh <Nombre de Maquina>

./docker-machine-import.sh <zipMaquina.zip>
```
