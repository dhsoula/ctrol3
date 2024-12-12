pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonartk')  // SonarQube token
        SONAR_HOST_URL = 'http://localhost:9000'  // SonarQube server URL
        SONAR_SCANNER_PATH = 'sonar-scanner-6.2.1.4610-windows-x64/bin/sonar-scanner.bat'  // Relative path to Sonar Scanner in the repo
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm  // Checkout the source code from SCM
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'composer install --no-interaction --prefer-dist'  // For Unix-based systems
                    } else {
                        bat 'composer install --no-interaction --prefer-dist'  // For Windows systems
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'chmod +x vendor/bin/phpunit'  // Make the PHPUnit script executable
                    }
                    sh 'vendor/bin/phpunit --configuration phpunit.xml'  // Run PHPUnit tests
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Adjust path for Windows
                    bat """
                        ${SONAR_SCANNER_PATH} ^
                            -Dsonar.projectKey=tp ^
                            -Dsonar.sources=src ^
                            -Dsonar.host.url=${SONAR_HOST_URL} ^
                            -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'  // Display success message
        }
        failure {
            echo 'Pipeline failed.'  // Display failure message
        }
    }
}
