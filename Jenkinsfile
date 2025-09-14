pipeline {
    agent any

    environment {
        IMAGE_NAME = "aamirdockerr/python-flask-app"
    }

    stages {
        stage('Build Docker image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push Docker image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Dockerhub-token-for-jenkins',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Port Forwarding') {
            steps {
                sh '''
                    # Kill old port-forward if running
                    pkill -f "kubectl port-forward" || true

                    # Start new port-forward in background
                    nohup kubectl port-forward svc/myapp-service 5000:5000 > port-forward.log 2>&1 &
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
