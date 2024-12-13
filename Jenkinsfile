pipeline {
    agent any

    environment {
        SONARQUBE_HOST_URL = 'http://localhost:9000'  // Adjust if SonarQube is running on another host
        SONARQUBE_PROJECT_KEY = 'tp'  // Your project key in SonarQube
        SONARQUBE_LOGIN = credentials('sonartk')  // Store token as Jenkins credential
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm  // Checkout the code from your SCM (e.g., Git)
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'  // Install project dependencies using Composer (for PHP projects)
            }
        }

        stage('Run Tests') {
            steps {
                sh 'chmod +x vendor/bin/phpunit'  // Ensure PHPUnit is executable
                sh 'vendor/bin/phpunit --configuration phpunit.xml'  // Run PHPUnit tests
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Running the SonarScanner for code analysis
                    sh '''
                        /opt/sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner \
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
                timeout(time: 1, unit: 'MINUTES') {  // Wait for the quality gate status for 1 minute
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
}

