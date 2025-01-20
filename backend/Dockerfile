# Utiliser une image Java de base
FROM openjdk:21-jdk-slim

# Définir le répertoire de travail
WORKDIR /app

# Variables d'environnement pour Nexus
ARG NEXUS_USERNAME
ARG NEXUS_PASSWORD
ARG JAR_URL=http://host.docker.internal:8081/repository/nexus-release/com/groupeisi/factorial/0.0.1/factorial-0.0.1.jar

# Installer curl pour télécharger le JAR
RUN apt-get update && apt-get install -y curl && \
    curl -u $NEXUS_USERNAME:$NEXUS_PASSWORD $JAR_URL -o factorial-app.jar

# Exposer le port
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["java", "-jar", "factorial-app.jar"]
