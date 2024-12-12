pipeline {
    agent any

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
                withSonarQubeEnv('MySonarQubeServer') { // Remplacez 'MySonarQubeServer' par le nom exact de votre serveur SonarQube configuré
                    sh '''
                    sonar-scanner \
                        -Dsonar.projectKey=tp \
                        -Dsonar.sources=./ \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=sonartk
                    '''
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

