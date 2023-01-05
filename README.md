**Docker - TP 1**

**5**. Exécuter un serveur web (apache, nginx, …) dans un conteneur docker

- Récupérer l’image sur le Docker Hub
docker pull nginx (*afin de récupérer nginx depuis le hub de Docker*)


- Vérifier que cette image est présente en local
docker images | docker image ls

 - Créer un fichier index.html simple
cd /usr/share/
sudo mkdir nginx
cd /usr/share/nginx
sudo nano index.html

<html>
<body>
<b>TEST</b>
<center>TP DOCKER</center>
</body>
</html>

- Démarrer un conteneur et servir la page html créée précédemment à l’aide d’un volume (option -v de docker run)
docker run -d -p 8080:80 -v /usr/share/nginx:/usr/share/nginx/html nginx

- Supprimer le conteneur précédent et arriver au même résultat que précédemment à l’aide de la commande docker cp
docker stop "nom du containers"
docker rm "nom du containers"

  - Il faut tout dabord créer un nouveau container
docker run -d -p 80:80 nginx

  - Puis on exécute la commande
docker cp usr/share/nginx/index.html a6939024d7d7:/usr/share/nginx/html/index.html

**6**. Builder une image

- A l’aide d’un Dockerfile, créer une image (commande docker build)
cd /usr/share/dock
sudo nano tp1
"FROM nginx:latest
COPY index.html /usr/share/nginx"
docker build -t tp1 .

- Exécuter cette nouvelle image de manière à servir la page html (commande docker run)
docker run -p 8080:80 -d tp1

- Quelles différences observez-vous entre les procédures 5. et 6. ? Avantages et inconvénients de l’une et de l’autre méthode ? (Mettre en relation ce qui est observé avec ce qui a été présenté pendant le cours)

La différence entre les deux est qu'**un fichier dockerfile** permet d'y ajouter une configuration afin de générer une image et la **commande cp** permet de copier des fichiers.

**7**. Utiliser une base de données dans un conteneur docker

- Récupérer les images mysql:5.7 et phpmyadmin/phpmyadmin depuis le Docker Hub
docker pull mysql:5.7
docker pull phpmyadmin/phpmyadmin

- Exécuter deux conteneurs à partir des images et ajouter une table ainsi que quelques enregistrements dans la base de données à l’aide de phpmyadmin
docker run --name mysqlynov -e MYSQL_ROOT_PASSWORD=Ynov -d mysql:5.7
docker run --name phpmyadminynov --link mysqlynov -p 8080:80 -d phpmyadmin/phpmyadmin


Se connecter à la bdd: 
docker exec -it mysqlynov mysql -u -root -p

**8**. Faire la même chose que précédemment en utilisant un fichier
docker-compose.yml

version: '3'
services:
  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=Ynov
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    links:
      - mysql:db
    ports:
      - 8080:80

Correction: 
apt install docker-compose
docker-compose up (exec tous les fichier yml)

![](https://codimd.s3.shivering-isles.com/demo/uploads/1feea6c2-6bf4-4003-93fc-188593de7ab9.png)

   
- Qu’apporte le fichier docker-compose par rapport aux commandes docker run
? Pourquoi est-il intéressant ? (cf. ce qui a été présenté pendant le cours)
Le fichier docker-compose.yml facilite la gestion et les diverses exécutions entre plusieurs conteneurs au lieu de les créer un par un, il suffit de les centraliser et d'exécuter le fichier docker-compose.

- Quel moyen permet de configurer (premier utilisateur, première base de
données, mot de passe root, …) facilement le conteneur mysql au lancement ?
C'est l'option "e" en début de commande qui permet de configurer facilement le conteneur mysql au lancement. 

**9**. Observation de l’isolation réseau entre 3 conteneurs

- A l’aide de docker-compose et de l’image praqma/network-multitool
disponible sur le Docker Hub créer 3 services (web, app et db) et 2 réseaux(frontend et backend). Les services web et db ne devront pas pouvoir effectuer de ping de l’un vers l’autre.

version: '3'
services:
  app:
    image: praqma/network-multitool
    networks:
      - backend
      - frontend
  web:
    image: nginx
    ports:
      - "80:80"
    networks:
      - frontend
  db:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=Ynov2022!
	  - MYSQL_DATABASE=db
      - MYSQL_USER=ynov
      - MYSQL_PASSWORD=Ynov2022!
    networks:
      - backend
networks:
  backend:
  frontend:
 

- Quelles lignes du résultat de la commande docker inspect justifient ce
comportement ?

- Dans quelle situation réelles (avec quelles images) pourrait-on avoir cette configuration réseau ? Dans quel but ?
