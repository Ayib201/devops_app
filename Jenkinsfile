pipeline {
    agent any

    environment {
        REGISTRY = "mydockerhub/factorial-app"
        IMAGE_NAME = "factorial-app" 
	    
    }

    tools {
        maven 'Maven 3.6'  // Le nom de l'outil Maven configuré
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

        stage('SonarQube Analysis') {
            steps {
                dir('backend') {  // Aller dans le répertoire 'backend' avant d'exécuter l'analyse SonarQube
			def mvn = tool 'Default Maven';
                	withSonarQubeEnv(installationName: 'SonarQubeServer') {
				sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=factorial -Dsonar.projectName='factorial'"
	                }
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('backend') {  // Aller dans le répertoire 'backend' avant de construire l'image Docker
                    script {
                        // Construire l'image Docker
                        sh 'docker build -t $REGISTRY/$IMAGE_NAME .'
                    }
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
