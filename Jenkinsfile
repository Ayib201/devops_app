pipeline {
    agent any

    environment {
        REGISTRY = "mydockerhub/factorial-app"
        IMAGE_NAME = "factorial-app"
        SONARQUBE_URL = 'http://host.docker.internal:9000' // URL de votre serveur SonarQube
        SONARQUBE_CREDENTIALS_ID = 'jenkins-sonar' // L'ID des credentials pour le token SonarQube
        AWS_REGION = 'eu-west-3c'  // Changer selon votre région AWS
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
                dir('backend') {
                    script {
                        // Vérifier la version Maven et construire l'application
                        sh 'mvn -version'
                        sh 'mvn clean compile'
                        sh 'ls -l target' 
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir('backend') {
                    script {
                        // Lancer les tests
                        sh 'mvn test'
                    }
                }
            }
        }


        stage('SonarQube Analysis') {
            steps {
                dir('backend') {
                    withSonarQubeEnv(installationName: 'sq1') {
                        script {
                            sh 'mvn clean verify sonar:sonar -Dsonar.java.binaries=target/classes'
                        }
                    }
                }
            }
        }

        stage('Publish to Nexus') {
            steps {
                nexusArtifactUploader artifacts: [[
                    artifactId: 'factorial', 
                    classifier: '', 
                    file: 'target/factorial-0.0.1.jar', 
                    type: 'jar'
                ]], 
                credentialsId: 'nexus', 
                groupId: 'com.groupeisi', 
                nexusUrl: 'host.docker.internal:8081', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: 'nexus-release', 
                version: '0.0.1'
            }
        }

        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             // Attendre les résultats des quality gates de SonarQube
        //             waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonar'
        //         }
        //     }
        // }

        stage('Deploy Infrastructure with Terraform') {
            steps {
                script {
                    // Utiliser Docker pour exécuter Terraform
                    sh """
                    docker run --rm -v \$(pwd)/terraform:/workspace -w /workspace hashicorp/terraform:latest init
                    docker run --rm -v \$(pwd)/terraform:/workspace -w /workspace hashicorp/terraform:latest apply -auto-approve
                    """
                }
            }
        }

        stage('Deploy Backend') {
            steps {
                script {
                    // Récupérer l'IP publique de l'instance et déployer l'application backend sur cette instance
                    def public_ip = sh(script: "docker run --rm -v \$(pwd)/terraform:/workspace -w /workspace hashicorp/terraform:latest output -raw public_ip", returnStdout: true).trim()
                    // Transférer le fichier JAR de l'application backend
                    sh """
                    scp -i /terraform/terraformkey.pem backend/target/factorial-app.jar ec2-user@$public_ip:/home/ec2-user/
                    ssh -i /terraform/terraformkey.pem ec2-user@$public_ip 'nohup java -jar /home/ec2-user/factorial-app.jar &'
                    """
                }
            }
        }

        stage('Deploy Frontend') {
            steps {
                script {
                    // Récupérer l'IP publique de l'instance et déployer les fichiers frontend
                    def public_ip = sh(script: "docker run --rm -v \$(pwd)/terraform:/workspace -w /workspace hashicorp/terraform:latest output -raw public_ip", returnStdout: true).trim()
                    // Copier les fichiers du frontend sur le serveur EC2
                    sh """
                    scp -i /terraform/terraformkey.pem -r frontend/* ec2-user@$public_ip:/var/www/html/factorial-app/
                    """
                }
            }
        }
    }
}
