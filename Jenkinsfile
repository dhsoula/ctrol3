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
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                // Run PHPUnit tests
                sh 'vendor/bin/phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('mysonarqube') { // Utilise le serveur SonarQube configuré
                    sh '''
                    /path/to/sonar-scanner/bin/sonar-scanner \
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

