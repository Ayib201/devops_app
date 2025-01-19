pipeline {
    agent any

    environment {
        REGISTRY = "mydockerhub/factorial-app"
        IMAGE_NAME = "factorial-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                script {
                    // Entrer dans le répertoire backend avant d'exécuter la commande mvn
                    dir('backend') {
                        // Construire l'application
                        sh 'mvn clean install'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Entrer dans le répertoire backend pour lancer les tests
                    dir('backend') {
                        // Lancer les tests
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Entrer dans le répertoire backend pour analyser avec SonarQube
                    dir('backend') {
                        // Analyser le code avec SonarQube
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Construire l'image Docker
                    sh 'docker build -t $REGISTRY/$IMAGE_NAME .'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Déployer sur AWS avec Docker
                    sh 'docker run -d -p 8080:8080 $REGISTRY/$IMAGE_NAME'
                }
            }
        }
    }
}
