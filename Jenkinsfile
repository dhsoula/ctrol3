pipeline {
    agent any

    tools {
        // Ensure the SonarQube Scanner is installed in Jenkins
        sonarQubeScanner 'SonarQubeScanner'  // Name of the installed SonarQube Scanner tool
    }

    environment {
        // Set environment variables for SonarQube
        SONARQUBE_HOST_URL = 'http://localhost:9000'  // Adjust if SonarQube is running on another host
        SONARQUBE_PROJECT_KEY = 'tp'  // Your project key in SonarQube
        SONARQUBE_LOGIN = credentials('sonartk')  // Store token as Jenkins credential
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout the code from your SCM (e.g., Git)
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Install project dependencies (for PHP projects in this case)
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                // Ensure PHPUnit is executable and run tests
                sh 'chmod +x vendor/bin/phpunit'
                sh 'vendor/bin/phpunit --configuration phpunit.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run the SonarScanner for code analysis
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

        stage('Quality Gate') {
            steps {
                // Wait for the Quality Gate status (1-minute timeout)
                timeout(time: 1, unit: 'MINUTES') {
                    script {
                        def qualityGate = waitForQualityGate()  // Wait for SonarQube Quality Gate status
                        if (qualityGate.status != 'OK') {
                            error "Quality gate failed: ${qualityGate.status}"  // Fail the build if Quality Gate fails
                        }
                    }
                }
            }
        }
    }

    post {
        // Clean up after the pipeline run
        always {
            cleanWs()  // Clean workspace after the build
        }
    }
}

