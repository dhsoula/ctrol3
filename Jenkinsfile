pipeline {
    agent any

    tools {
        // Déclarez le SonarQube Scanner avec le nom configuré dans Jenkins
        sonarQube 'SonarScanner'  // Assurez-vous que le nom correspond à celui configuré dans l'image
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
                withSonarQubeEnv('MySonarQubeServer') { // Assurez-vous que ce nom est celui de votre serveur SonarQube configuré
                    // Exécutez l'analyse avec le scanner SonarQube
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
                    // Vérifiez la Quality Gate avec un délai maximum
                    timeout(time: 1, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
    }
}

