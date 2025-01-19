pipeline {
    agent any

    environment {
        REGISTRY = "mydockerhub/factorial-app"
        IMAGE_NAME = "factorial-app"
        SONARQUBE_URL = 'http://host.docker.internal:9000' // URL de votre serveur SonarQube
        SONARQUBE_CREDENTIALS_ID = 'jenkins-sonar' // L'ID des credentials pour le token SonarQube
    }

    tools {
        maven 'Maven 3.9'  // Le nom de l'outil Maven configuré
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                dir('backend') {  // Aller dans le répertoire 'backend' avant d'exécuter Maven
                    script {
                        // Vérifier la version Maven et construire l'application
                        sh 'mvn -version'
                        sh 'mvn clean install'
                        sh 'ls -l target' 
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir('backend') {  // Aller dans le répertoire 'backend' avant d'exécuter Maven test
                    script {
                        // Lancer les tests
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Compile') {
            steps {
                dir('backend') {
                    script {
                        // Compiler le projet
                        sh 'mvn clean compile'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('backend') {  // Aller dans le répertoire 'backend' avant d'exécuter l'analyse SonarQube
                    withSonarQubeEnv(installationName: 'sq1') {
                        script {
                            sh 'mvn clean verify sonar:sonar -Dsonar.java.binaries=target/classes'
                        }
                    }
                }
            }
        }

        

        //stage('Docker Build') {
        //    steps {
        //        dir('backend') {  // Aller dans le répertoire 'backend' avant de construire l'image Docker
        //            script {
        //                // Construire l'image Docker
        //                sh 'docker build -t $REGISTRY/$IMAGE_NAME .'
        //            }
        //        }
        //    }
        //}

        stage('Deploy Backend') {
            steps {
                script {
                    // Déployer l'application backend Spring Boot
                    sh 'java -jar backend/target/factorial-app.jar &'
                }
            }
        }

        stage('Deploy Frontend') {
            steps {
                script {
                    // Copier les fichiers du frontend (HTML, CSS, JS) dans le répertoire du serveur
                    // Exemple pour un déploiement simple avec un serveur Apache ou Nginx
                    sh '''
                    mkdir -p /var/www/html/factorial-app
                    cp -r frontend/* /var/www/html/factorial-app/
                    '''
                }
            }
        }
    }
}
