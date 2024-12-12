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
                script {
                    def process = ['composer', 'install', '--no-interaction', '--prefer-dist'].execute()
                    process.waitFor()
                    if (process.exitValue() != 0) {
                        error "Composer install failed with error: ${process.err.text}"
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run PHPUnit tests
                script {
                    def process = ['vendor\\bin\\phpunit', '--configuration', 'phpunit.xml'].execute()
                    process.waitFor()
                    if (process.exitValue() != 0) {
                        error "PHPUnit tests failed with error: ${process.err.text}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('mysonarqube') { // Use the configured SonarQube server
                    script {
                        def sonarCommand = [
                            'C:\\sonar-scanner-6.2.1.4610-windows-x64\\bin\\sonar-scanner.bat',
                            '-Dsonar.projectKey=tp',
                            '-Dsonar.sources=./',
                            '-Dsonar.host.url=http://localhost:9000',
                            '-Dsonar.login=sonartk'
                        ]
                        def process = sonarCommand.execute()
                        process.waitFor()
                        if (process.exitValue() != 0) {
                            error "SonarQube analysis failed with error: ${process.err.text}"
                        }
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
