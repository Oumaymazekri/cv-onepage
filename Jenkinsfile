pipeline {
    agent any

    environment {
        DOCKER_HUB_CRED = credentials('dockerhub-credentials')
        SLACK_WEBHOOK = credentials('slack-webhook')
        IMAGE_NAME = "oumayma/cv-onepage"
        IMAGE_TAG = "latest"
    }

    triggers {
        pollSCM('H/5 * * * *') // Vérifie les changements toutes les 5 minutes
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Oumaymazekri/cv-onepage.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKER_HUB_CRED') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        success {
            slackSend(
                channel: '#general',
                color: 'good',
                message: "Pipeline réussie : Image Docker ${IMAGE_NAME}:${IMAGE_TAG} publiée !"
            )
        }
        failure {
            slackSend(
                channel: '#general',
                color: 'danger',
                message: "Pipeline échouée ! Vérifie Jenkins."
            )
        }
    }
}
