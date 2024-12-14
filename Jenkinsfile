pipeline {
    agent any

    environment {
        // Define SonarQube credentials or parameters here
        SONARQUBE_ENV = credentials('SonarQube') // Replace 'SonarQube' with your Jenkins credential ID
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    chmod +x vendor/bin/phpunit
                    vendor/bin/phpunit --configuration phpunit.xml
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { // Replace 'SonarQube' with your SonarQube server name in Jenkins
                    sh '''
                        export PATH=/opt/sonar-scanner-4.8.0.2856-linux/bin:$PATH
                        sonar-scanner \
                            -Dsonar.projectKey=tp \
                            -Dsonar.sources=./ \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=$SONARQUBE_ENV
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 1, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after pipeline completes
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
