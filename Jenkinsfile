pipeline {
  agent any
  stages {
    stage('Test') {
      when {
        anyOf {
          branch 'feature/*'
        }
      }
      steps {
        sh 'echo "Test Success"'
      }
    }
    
    stage('Build') {
//       when {
//         anyOf {
//           branch 'master'
//         }
//       }
      steps {
        sh 'docker build -t todo-app-py:V.$GIT_COMMIT .'
        echo "This is Build Based on Docker Image version $GIT_COMMIT"
   
      }
    }
      
      
    stage('Login Dockerhub') {
      steps {
        withCredentials([string(credentialsId: 'kingstorm_dh', variable: 'DOCKER_TOKEN')]) {
          sh "docker login -u himanshukingstorm -p $DOCKER_TOKEN"
        }
        echo "Logged In Successfully"
      }
    }
    stage('Push into Dockerhub') {
      steps {
        sh "docker tag todo-app-py:V.$BUILD_NUMBER himanshukingstorm/todo-app-py:V.$GIT_COMMIT"
        sh "docker push himanshukingstorm/todo-app-py:V.$GIT_COMMIT"
      
      echo "This is Push Based on Docker Image as Version :V.$GIT_COMMIT"
      }
      }

      stage('Deploy') {
      when {
        anyOf {
          branch 'production'
        }
      }
      
          steps{
      withCredentials([file(credentialsId: 'pp', variable: 'my_var')]) {
          sh "kubectl --kubeconfig=$my_var apply -f todo_app_deployment.yml"
//           sh "export SERVICE_URL= 'minikube service todo-app --url'"
//           sh "echo 'Project running on: $SERVICE_URL'"        
//           sh "kubectl --kubeconfig=$my_var expose deployment finalproject --type=LoadBalancer --port=8000"          
              }
      
      }
      
    
    }    
      
  }

}
