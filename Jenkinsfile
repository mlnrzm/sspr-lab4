pipeline {
    agent any
    
    stages {
        stage('Cloning Git') {
          steps {
              git([url: 'https://github.com/mlnrzm/sspr-lab4.git', branch: 'master'])
          }
        }
        stage('Build') {

			steps {
				bat 'docker build -t mlnrzm/sspr4:latest .'
			}
		}
        stage('Test') {
            steps {
				bat 'FOR /F "tokens=*" %%i IN (\'docker ps -a -q\') DO docker stop %%i'
				bat 'docker rm "test_sspr"'
				bat 'docker run -d --name "test_sspr" mlnrzm/sspr4:latest bash'
				bat 'docker exec "test_sspr" sh -c "dotnet vstest TestProject.dll"'
				bat 'docker stop "test_sspr"'
            }
        }

        stage("Push Image To Docker Hub") {
            steps {
                withCredentials([string(credentialsId: 'sspr_4', variable: 'sspr4')]) {
                    bat "docker login --username mlnrzm --password ${sspr4}"
                    bat 'docker push mlnrzm/sspr4:latest'
                }
            }
        }
    }
    post {
		always {
			script {
				node {
					bat 'docker logout'
				}
            }
		}
	}
}
