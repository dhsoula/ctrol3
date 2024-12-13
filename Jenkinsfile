pipeline {
    agent any

   

    environment {
        SONARQUBE_HOST_URL = 'http://localhost:9000'
        SONARQUBE_PROJECT_KEY = 'tp'
        SONARQUBE_LOGIN = credentials('sonartk') // Store token as Jenkins credential
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
                sh 'chmod +x vendor/bin/phpunit'
                sh 'vendor/bin/phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    
                        sh '''
                        sonar-scanner \
                            -Dsonar.projectKey=$SONARQUBE_PROJECT_KEY \
                            -Dsonar.sources=./ \
                            -Dsonar.host.url=$SONARQUBE_HOST_URL \
                            -Dsonar.login=$SONARQUBE_LOGIN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
