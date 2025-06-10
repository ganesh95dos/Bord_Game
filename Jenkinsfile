pipeline {
    agent any
    environment {
        SONAR_HOME = tool "sonar"
    }
    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/ganesh95dos/Bord_Game.git', branch: 'main'
            }
        }
        stage('SonarQube Quality Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh "${SONAR_HOME}/bin/sonar-scanner -Dsonar.projectName=Bord-Game -Dsonar.projectKey=Bord-game"
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'dc'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('SonarQube Quality Gate Scan') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        stage('Trivy File System Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-report.html .'
            }
        }

        stage('Deploy using Docker-compose'){
            sh 'docker-compose up -d' 
        }
    }
}
