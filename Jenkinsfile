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
                // Récupérer le code source depuis le SCM
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Installer les dépendances avec Composer
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                // Rendre le script PHPUnit exécutable
                sh 'chmod +x vendor/bin/phpunit'
                // Exécuter les tests PHPUnit
                sh 'vendor/bin/phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Using SonarScanner Docker container
                    docker.image('sonarsource/sonar-scanner-cli:4.8').inside {
                        // Run SonarQube Analysis
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
                script {
                    timeout(time: 1, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
    }
}
