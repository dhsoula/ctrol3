

pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout the source code from SCM
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Run Composer to install dependencies
                bat 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                // Run PHPUnit tests
                bat 'vendor\\bin\\phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('mysonarqube') { // Utilise le serveur SonarQube configuré
                    bat """
                    C:\\sonar-scanner-6.2.1.4610-windows-x64\\bin\\sonar-scanner.bat ^
                    -Dsonar.projectKey=tp ^
                    -Dsonar.sources=./ ^
                    -Dsonar.host.url=http://localhost:9000 ^
                    -Dsonar.login=sonartk
                    """
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
