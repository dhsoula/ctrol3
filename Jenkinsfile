pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonartk') // Replace with your SonarQube token credential ID
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    chmod +x vendor/bin/phpunit
                    vendor/bin/phpunit --configuration phpunit.xml
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Ensure the script runs for Unix systems.
                sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=your_project_key \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http:http://localhost:9000/ \
                    -Dsonar.login=$SONAR_TOKEN
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
