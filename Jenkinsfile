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
    }
}
