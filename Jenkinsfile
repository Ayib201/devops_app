pipeline {
    agent {
        docker {
            image 'maven:3.8-jdk-21'
            args '-v /root/.m2:/root/.m2'  // Pour persister le cache de Maven entre les builds
        }
    }

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
                    // Vérifier la version Maven et construire l'application
                    sh 'mvn -version'
                    sh 'mvn clean install'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Lancer les tests
                    sh 'mvn test'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Analyser le code avec SonarQube
                    sh 'mvn sonar:sonar'
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
