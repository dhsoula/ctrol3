pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonartk')
        SONAR_SCANNER_PATH = 'C:/Users/ADMIN/OneDrive/Bureau/AGIL/jenkins_home/workspace/ctr/sonar-scanner-6.2.1.4610-windows-x64/bin/sonar-scanner.bat' // Adjust path accordingly
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
                    sh 'composer install --no-interaction --prefer-dist'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'chmod +x vendor/bin/phpunit'
                    sh 'vendor/bin/phpunit --configuration phpunit.xml'
                }
            }
        }

        stage('Setup Sonar User and Group') {
            steps {
                script {
                    def groupExists = sh(script: "getent group sonar", returnStatus: true) == 0
                    if (!groupExists) {
                        echo "Group 'sonar' does not exist, skipping creation."
                    }

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
                    // Run SonarQube analysis using the specified path
                    echo "Running SonarQube Analysis..."
                    bat "\"${env.SONAR_SCANNER_PATH}\""
                }
            }
        }

        stage('Post Actions') {
            steps {
                script {
                    echo "Pipeline completed."
                }
            }
        }

        stage('Declarative: Post Actions') {
            steps {
                script {
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
