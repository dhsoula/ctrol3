pipeline {
    agent any

    environment {
        // Define necessary environment variables
        SONAR_TOKEN = credentials('sonartk')
    }

    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install the necessary dependencies using Composer
                    sh 'composer install --no-interaction --prefer-dist'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Make PHPUnit executable and run the tests
                    sh 'chmod +x vendor/bin/phpunit'
                    sh 'vendor/bin/phpunit --configuration phpunit.xml'
                }
            }
        }

        stage('Setup Sonar User and Group') {
            steps {
                script {
                    // Check if the sonar group exists
                    def groupExists = sh(script: "getent group sonar", returnStatus: true) == 0
                    if (!groupExists) {
                        echo "Group 'sonar' does not exist, skipping creation."
                    }

                    // Check if the sonar user exists
                    def userExists = sh(script: "id -u sonar", returnStatus: true) == 0
                    if (!userExists) {
                        echo "User 'sonar' does not exist, skipping creation."
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            when {
                expression { return currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    // Run the SonarQube analysis here
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Post Actions') {
            steps {
                script {
                    // Post-action scripts can go here, for example notifications
                    echo "Pipeline completed."
                }
            }
        }

        stage('Declarative: Post Actions') {
            steps {
                script {
                    // If pipeline fails, print a failure message
                    if (currentBuild.result == 'FAILURE') {
                        echo "Pipeline failed."
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed with status: ${currentBuild.result}"
        }

        success {
            echo "Pipeline succeeded."
        }
    }
}
