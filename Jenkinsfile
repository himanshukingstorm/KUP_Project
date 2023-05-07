pipeline  {
  agent any
  
//   triggers  {
//     githubPullRequest (
//       triggerOnPush: true,
//       triggerOnSchedule: false,
//       triggerOnPoll: false,
//       branchFilterType: 'All',
//       cron: ''
//                       )
//             }
  
  stages    {
   stage('Build') {
                  when {
                    anyOf {
                      branch 'feature/*'
//                       branch 'develop'
                          }
                       }
                     steps {
                        sh 'docker build -t todo-app-py:V.$GIT_COMMIT .'
                        echo "This is Build Based on Docker Image version $GIT_COMMIT"
                        echo "Build Success"
                           }
                  }

      
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
      
    stage('Login Dockerhub') {
                  when {
                    anyOf {
                      branch 'develop'
                          }
                       }

                    steps {
                      withCredentials([string(credentialsId: 'kingstorm_dh', variable: 'DOCKER_TOKEN')]) {
                        sh "docker login -u himanshukingstorm -p $DOCKER_TOKEN"}                    
                          echo "Logged In Successfully into Dockerhub"
                          }
                  }
    
    stage('Push into Dockerhub') {
                  when {
                    anyOf {
                      branch 'develop'
                          }
                       }

                    steps {
                      sh "docker tag todo-app-py:V.$BUILD_NUMBER himanshukingstorm/todo-app-py:V.$GIT_COMMIT"
                      sh "docker push himanshukingstorm/todo-app-py:V.$GIT_COMMIT"

                        echo "This Push is Based on Docker Image as Version :V.$GIT_COMMIT"
                        echo "Pushed with Success into Dockerhub"
                          }
                  }

    stage('Deploy') {
                    when {
                      anyOf {
                        branch 'main'
                            }
                          }
                    steps {
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
