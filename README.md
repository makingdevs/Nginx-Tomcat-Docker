# README

## Docker Nginx - Tomcat 

Este repo contiene la instalacion con docker de Nginx y Tomcat, con dos virtual host llamado qa.makingdevs.com y stage.makingdevs.com

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

### Creando nuestro docker container con Nginx - Jenkins

Clonamos el repo y nos posicionamos dentro de el. El primer paso sera construir la imagen de docker la cual instalaremos a nuestra maquina previamente creada. Podremos nombrar nuestra imagen como queramos.

```
docker build -t <Nombre de la imagen> .
```

Una vez terminado tendremos lista nuestra imagen para ejecutarla.

```
docker run --name <Nombre del proceso> -p 80:80 -p 8080:8080 -d --env JAVA_OPTS="-Djava.util.logging.config.file=/logging.properties" <Nombre de la imagen>

docker ps 
```

Con `docker ps ` nos aseguramos de que el proceso se encuntre activo y listo con ellos ya tenemos un nginx y tomcat ejecutandose dentro de nuestra maquina. podremos ver nuestros tomcats.

qa.makingdevs.com 
stage.makingdevs.com

Si estas en una maquina virtual host agrega esto en tu archivo 'hosts' de tu maquina (en OSX es /private/etc/hosts)

```

127.0.0.1 qa.makingdevs.com
127.0.0.1 stage.makingdevs.com

```

### Log de Nginx, catalina y 

```
docker logs -f <Nombre del proceso> | grep nginx

docker logs -f <Nombre del proceso> | grep catalina
```

### Otros comandos utiles

```
docker stop <Nombre del proceso> --Para detener el proceso 
dokcer rm <Nombre del proceso> --Para eliminar el proceso 

docker run --name <Nombre del proceso> -d -v /Users/makingdevs/jenkins:/root/.jenkins --env JAVA_OPTS="-Djava.util.logging.config.file=/logging.properties" *Nombre-Imagen*
```

Este ultimo comando nos ayuda a correr la imagen, agregando un enlance de un directorio (Home de Jenkins) de docker a nuestra maquina en la cual estemaos ejecutando docker (Importante esto solo funciona en virtualbox no en amazon)

### Exportar o importar docker machiner

```
./docker-machine-export.sh <Nombre de Maquina>

./docker-machine-import.sh <zipMaquina.zip>
```
