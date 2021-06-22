pipeline {
    agent any
    tools {
        maven 'Maven'
        jdk 'Java JDK'
        dockerTool 'Docker'
    }
    stages {
        stage('Clean and Test target') {
            steps {
                sh 'mvn clean test'
            }
        }
        stage('Test and Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Code Analysis: Sonarqube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Await Quality Gateway') {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }
        stage('Dockerize') {
            steps {
                script {
                    docker.build('openapi')
                }
            }
        }
        stage('Push ECR') {
            steps {
                script {
                    docker.withRegistry('https://241465518750.dkr.ecr.us-east-2.amazonaws.com', 'ecr:us-east-2:aws-ecr-creds') {
                        docker.image('openapi').push("${env.BUILD_NUMBER}")
                        docker.image('openapi').push('latest')
                    }
                }
            }
        }
        stage('Deploy') {
            echo 'Updating k8s image..'
            sh './kubectl set image deployment/openapi-service openapi-service=241465518750.dkr.ecr.us-east-2.amazonaws.com/openapi:latest'
        }
    }
    post {
        always {
            sh 'mvn clean'
        }
    }
}