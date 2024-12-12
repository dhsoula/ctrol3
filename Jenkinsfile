pipeline {
    agent any
    
    environment {
        SONARQUBE_URL = 'http://your-sonarqube-url' // Set your SonarQube URL
        SONAR_TOKEN = credentials('your-sonar-token-id') // Set your SonarQube token as Jenkins credentials
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install Composer dependencies
                    sh 'composer install --no-interaction --prefer-dist'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run PHPUnit tests
                    sh 'chmod +x vendor/bin/phpunit'
                    sh 'vendor/bin/phpunit --configuration phpunit.xml'
                }
            }
        }

        stage('Setup Sonar User and Group') {
            steps {
                script {
                    // Create the sonar user and group if they don't exist (no sudo required)
                    sh '''
                    if ! getent group sonar > /dev/null; then
                        groupadd sonar  # Add sonar group
                    fi
                    if ! id -u sonar > /dev/null 2>&1; then
                        useradd -r -m -g sonar sonar  # Add sonar user
                    fi
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    sh '''
                    sonar-scanner \
                        -Dsonar.projectKey=your_project_key \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONARQUBE_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    '''
                }
            }
        }

        stage('Post Actions') {
            steps {
                script {
                    echo 'Pipeline completed.'
                }
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed.'
        }
    }
}
