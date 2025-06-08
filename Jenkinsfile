pipeline {
    agent any
    environment{
        SONAR_HOME= tool"sonar"
    }
    stages {
        stage('clone') {
            steps {
                echo 'Cloning...'
                git url:"https://github.com/ganesh95dos/Bord_Game.git", branch:"main" 
            }
        }

        stage('Sonar Qube Quality Analysis') {
            steps {
                echo 'Sonar Qube Quality Analysis...'
                withSonarQubeEnv("sonar"){
                    sh"$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=Bord-Game -Dsonar.projectKey=Bord-game"
                }
            }
        }
        
        stage('Sonar Qube Quality Gate Scan'){
            steps{
                timeout(time:2, unit:"MINUTE")
                waitForQualityGate abortPipeline: false
            }
        }
        
        stage('OWAPS Dependancy Check'){
            steps{
                dependencyCheck additionalArguments:'--scan ./', odcInstallation:'dc'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml' 
            }
        }
        
        stage('Trivy File System Scan'){
            steps {
                sh 'trivy fs --format table -o trivy-fs-report.html .'  // moved inside steps block
            }
        }
    }
}
