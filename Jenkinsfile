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
        stage('SonarQube Quality Gate Scan') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {        // ✅ Correct block
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'dc'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Trivy File System Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-report.html .'
            }
        }
    }
}
