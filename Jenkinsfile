pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main', url: 'https://github.com/your-username/your-laravel-app.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the Docker image...'
                script {
                    dockerImage = docker.build("my-laravel-app:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit and feature tests...'
                script {
                    dockerImage.inside('-u root:sudo') {
                        sh 'composer install --no-dev'
                        sh 'php artisan migrate --force'
                        sh 'vendor/bin/phpunit'
                    }
                }
            }
        }

        stage('Push to Registry') {
            steps {
                echo 'Pushing image to Docker Hub...'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to the production server...'
                sshagent(['production-server-key']) {
                    sh 'ssh -o StrictHostKeyChecking=no user@your-server-ip "cd /var/www/your-app && docker-compose pull && docker-compose up -d --build"'
                }
            }
        }
    }
}
