pipeline {
    agent any

    environment {
        // Configuration SonarQube
        SONARQUBE_HOST_URL = 'http://localhost:9000'  // Adresse de SonarQube
        SONARQUBE_PROJECT_KEY = 'tp'  // Clé de votre projet
        SONARQUBE_LOGIN = credentials('sonartk')  // Jeton enregistré comme credential
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
                    withSonarQubeEnv('SonarQube') {  // Utilisation du plugin SonarQube
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
                    script {
                        def qualityGate = waitForQualityGate()
                        if (qualityGate.status != 'OK') {
                            error "Quality gate failed: ${qualityGate.status}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
