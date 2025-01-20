# Utilisation de l'image officielle Nginx
FROM nginx:alpine

# Définissez le répertoire de travail
WORKDIR /usr/share/nginx/html

# Copiez les fichiers de construction de votre application frontend dans le répertoire par défaut de Nginx
COPY . .

# Exposez le port 80 pour le serveur HTTP
EXPOSE 80

# Commande pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
