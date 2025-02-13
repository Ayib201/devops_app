pipeline {
    agent any

    environment {
        REGISTRY = "mydockerhub/factorial-app"
        IMAGE_NAME = "factorial-app"
        SONARQUBE_URL = 'http://host.docker.internal:9000' // URL de votre serveur SonarQube
        SONARQUBE_CREDENTIALS_ID = 'jenkins-sonar' // L'ID des credentials pour le token SonarQube
        AWS_REGION = 'eu-west-3c'  // Changer selon votre région AWS
        DOCKERHUB_CREDENTIALS = 'dockerhub' // ID des credentials configurés dans Jenkins
        DOCKER_IMAGE = 'julesbestdev176/factorial' // Nom de l'image Docker (DockerHub username/image)
        DOCKER_TAG = 'latest' // Tag de l'image
        
    }

    tools {
        maven 'Maven 3.9'  // Le nom de l'outil Maven configure
        terraform 'Terraform'
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
                        sh 'mvn clean install'
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

        stage('Compile') {
            steps {
                dir('backend') {
                    script {
                        sh 'mvn clean compile'
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
                dir('backend') {
                    script {
                        sh 'ls -l target/'
                        
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

        stage('Login to DockerHub') {
            steps {
                // Login using access token
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKERHUB_TOKEN')]) {
                    script {
                        // Connexion DockerHub avec le token sécurisé
                        sh "echo \$DOCKERHUB_TOKEN | docker login -u julesbestdev176 --password-stdin"
                    }
                }
            }
        }
        
        
        stage('Build Docker Image') {
            steps {
                dir('backend') {
                    script {
                        sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
                    }
                }   
            }
        }

        stage('Push Docker Image') {
            steps {
                    script {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }   
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    script {
                    // Initialiser Terraform
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    script {
                        // Voir les changements à appliquer (utile pour debug)
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    script {
                        // Appliquer la configuration Terraform pour déployer l'instance
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        stage('Docker Login') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKERHUB_TOKEN')]) {
                    script {
                        sh "echo \$DOCKERHUB_TOKEN | docker login -u julesbestdev176 --password-stdin"
                    }
                }
            }
        }
        stage('Deploy Application') {
            steps {
                script {
                    // Après avoir créé l'instance, déployez l'application via Docker
                    def public_ip = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()

                    // Cloner le dépôt et lancer Docker Compose
                    sh """
                    ssh -i /path/to/your/key.pem ubuntu@$public_ip << EOF
                    cd /home/ubuntu
                    git clone https://github.com/Ayib201/devops_app
                    cd devops_app
                    sudo docker-compose up --build -d
                    EOF
                    """
                }
            }
        }
    }
}
