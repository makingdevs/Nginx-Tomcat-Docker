# README

## Docker Tomcat 

Este repo contiene la instalación con docker de un Tomcat, elementos personalizables como la configuracion.

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

Listo, con ellos tendremos lista nuestra maquina para intalar la imagen.

### Creando nuestro docker container con Tomcat 

Clonamos el repo y nos posicionamos dentro de el. El primer paso sera construir la imagen de docker la cual instalaremos a nuestra maquina previamente creada. Podremos nombrar nuestra imagen como queramos.

Los elementos personalizables son los siguientes:

- URL_WAR=URL_DEL_WAR_A_DEPLOYAR 
- FILE_NAME_CONFIGURATION=ARCHIVO_CONF.groovy -- Este arhcivo debe de estar dentro del repo -- 
- PATH_NAME_CONFIGURATION=PATH_DE_LA_CONFIG_DEL_PROYECTO -- /root es el home del container

```
docker build --build-arg URL_WAR=http://url.com --build-arg FILE_NAME_CONFIGURATION=application.groovy --build-arg PATH_NAME_CONFIGURATION=/root/.config/ -t <Nombre de la imagen> .
```

Una vez terminado tendremos lista nuestra imagen para ejecutarla.

```
docker run --name <Nombre del proceso> -p 8080:8080 -d <Nombre de la imagen>

docker ps 
```

Con `docker ps ` nos aseguramos de que el proceso se encuntre activo y listo con ellos ya tenemos un tomcat ejecutandose dentro de nuestra maquina.

### Log del contenedor

```
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

### Crear tag de la imagen

Para crear un tag de la imagen con version ya se para subir la imagen para Docker Hub o los servicios de Google Cloud 

```
Servicios de Google Cloud

 docker tag nombre_imagen gcr.io/<nombre_proyecto>/<nombre_imagen>:<version>

Servicios de Docker Hub

  docker tag nombre_imagen <nombre_usuario>/<nombre_imagen>:<version>
```

Anteriormente se debe de loguear con docker con 'docker login'

y finalmente se empuja a los servicios correspondientes 

```
docker push gcr.io/<nombre_proyecto>/<nombre_imagen>:<version>

```
