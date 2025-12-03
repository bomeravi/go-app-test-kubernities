pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'bomeravi'
        IMAGE_NAME = 'go-app-test'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Logging in to DockerHub and pushing image..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                                 usernameVariable: 'USER', 
                                                 passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
                sh 'docker push $DOCKERHUB_USER/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                // Apply deployment
                sh 'kubectl apply -f k8s/deployment.yaml'
                // Apply service
                sh 'kubectl apply -f k8s/service.yaml'
                // Optional: check pods
                sh 'kubectl get pods -o wide'
            }
        }

    }

    post {
        success {
            echo '✅ Deployment succeeded!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
