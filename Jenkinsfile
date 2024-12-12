pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonartk') // Replace with your SonarQube token credential ID
        SONAR_SCANNER_HOME = '/opt/sonar-scanner' // Set the SonarScanner home directory
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

        stage('Setup Sonar User and Group') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            # Add the sonar group if it doesn't exist
                            if ! getent group sonar > /dev/null; then
                                sudo addgroup sonar
                                echo "Group 'sonar' created."
                            else
                                echo "Group 'sonar' already exists."
                            fi

                            # Add the sonar user if it doesn't exist
                            if ! id -u sonar > /dev/null 2>&1; then
                                sudo useradd -s $(which bash) -d ${SONAR_SCANNER_HOME} -g sonar sonar
                                echo "User 'sonar' created."
                            else
                                echo "User 'sonar' already exists."
                            fi

                            # Set permissions for the SonarScanner directory
                            sudo chown -R sonar:sonar ${SONAR_SCANNER_HOME}
                            sudo chmod -R 755 ${SONAR_SCANNER_HOME}
                        '''
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            # Run SonarScanner as the 'sonar' user
                            sudo -u sonar ${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=tp \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=$SONAR_TOKEN
                        '''
                    } else {
                        bat '''
                            echo "Windows environment is not yet configured for SonarScanner execution."
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
