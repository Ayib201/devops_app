# Utiliser une image Java de base
FROM openjdk:21-jdk-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR dans le conteneur
COPY target/factorial-0.0.1.jar factorial-app.jar

# Exposer le port
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["java", "-jar", "factorial-app.jar"]
