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
                script {
                    if (isUnix()) {
                        sh 'composer install --no-interaction --prefer-dist'
                    } else {
                        bat 'composer install --no-interaction --prefer-dist'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            chmod +x vendor/bin/phpunit
                            vendor/bin/phpunit --configuration phpunit.xml
                        '''
                    } else {
                        bat 'vendor\\bin\\phpunit --configuration phpunit.xml'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    if (isUnix()) {
                        // Check if the sonar-scanner exists
                        sh '''
                            if [ -f /opt/sonar-scanner/bin/sonar-scanner ]; then
                                echo "SonarQube scanner exists."
                                chmod +x /opt/sonar-scanner/bin/sonar-scanner
                                /opt/sonar-scanner/bin/sonar-scanner \
                                -Dsonar.projectKey=tp \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://localhost:9000 \
                                -Dsonar.login=$SONAR_TOKEN
                            else
                                echo "SonarQube scanner does not exist at /opt/sonar-scanner/bin/sonar-scanner"
                            fi
                        '''
                    } else {
                        bat '''
                            C:\\path\\to\\sonar-scanner-6.2.1.4610-windows-x64\\bin\\sonar-scanner-debug.bat ^
                            -Dsonar.projectKey=tp ^
                            -Dsonar.sources=. ^
                            -Dsonar.host.url=http://localhost:9000 ^
                            -Dsonar.login=%SONAR_TOKEN%
                        '''
                    }
                }
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
