pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "oumaymazekri/cv-test:latest"
        SLACK_WEBHOOK = credentials('slack-webhook')
    }

    stages {

        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/oumaymazekri/cv-onepage.git',
                    branch: 'main',
                    credentialsId: 'github-credentials'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }

    post {

        success {
            script {
                sh """
                curl -X POST -H 'Content-type: application/json' --data "{
                    \\"text\\": \\":white_check_mark: SUCCESS - Job: ${env.JOB_NAME}, Build: #${env.BUILD_NUMBER}\\"
                }" ${SLACK_WEBHOOK}
                """
            }
        }

        failure {
            script {
                sh """
                curl -X POST -H 'Content-type: application/json' --data "{
                    \\"text\\": \\":x: FAILED - Job: ${env.JOB_NAME}, Build: #${env.BUILD_NUMBER}\\"
                }" ${SLACK_WEBHOOK}
                """
            }
        }
    }
}
