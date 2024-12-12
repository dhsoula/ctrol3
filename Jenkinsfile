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
                // Run PHPUnit tests (no chmod needed on Windows)
                bat 'vendor\\bin\\phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    bat """
                    C:\\sonar-scanner-6.2.1.4610-windows-x64\\bin\\sonar-scanner.bat ^
                    -Dsonar.projectKey=MyNodeApp ^
                    -Dsonar.sources=./ ^
                    -Dsonar.host.url=http://localhost:9000 ^
                    -Dsonar.login=sqp_7d10091a032da7d22b4973fc23adea79fd55ac3b
                    """
                }
            }
        }
    }
}

