pipeline {
    agent any

    tools {
        sonarScanner 'sonarScanner'  // Assurez-vous que le nom ici correspond à l'outil configuré dans Jenkins
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Récupère le code source depuis le SCM
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Installe les dépendances avec Composer
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                // Rend le script PHPUnit exécutable
                sh 'chmod +x vendor/bin/phpunit'
                // Exécute les tests PHPUnit
                sh 'vendor/bin/phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQubeServer') { // Utilise le serveur SonarQube configuré
                    // Exécute l'analyse SonarQube avec l'outil sonarScanner installé
                    tool name: 'sonarScanner', type: 'SonarQubeScanner'
                    sh '''sonar-scanner \
                        -Dsonar.projectKey=tp \
                        -Dsonar.sources=./ \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=sonartk'''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    // Vérifie le statut de la Quality Gate dans un délai d'une minute
                    timeout(time: 1, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
    }
}
