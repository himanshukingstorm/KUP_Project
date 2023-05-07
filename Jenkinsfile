pipeline  {
  agent any
  
  triggers  {
    githubPush (
//       triggerOnPush: true,
//       triggerOnSchedule: false,
//       triggerOnPoll: false,
//       branchFilterType: 'All',
//       cron: ''
                      )
            }
  
  stages    {
    stage('Test') {
                    when {
                      anyOf {
                        branch 'feature/*'
//                         branch 'develop'
                        branch 'main'
                            }
                         }
                    steps {
                      sh 'echo "Test Success"'
                          }
                  }
   stage('Build') {
                  when {
                    anyOf {
//                       branch 'feature/*'
//                       branch 'develop'

                      branch 'main'
                          }
                       }
                     steps {
                        echo "Build Number:  $BUILD_NUMBER  Build ID: $BUILD_ID BUILD_TAG: $BUILD_TAG"
                        echo "GIT_COMMIT: $GIT_COMMIT JOB_NAME: $JOB_NAME"
                       
                        sh 'docker build -t todo-app-py:v$BUILD_ID .'
                        echo "This is Build Based on Docker Image version v$BUILD_ID"
                        echo "Build Success"
                           }
                  }

      
    stage('Login Dockerhub') {
                  when {
                    anyOf {
//                    branch 'develop'
                      branch 'main'
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
//                    branch 'develop'
                      branch 'main'
                          }
                       }

                    steps {
                      sh "docker tag todo-app-py:v$BUILD_ID himanshukingstorm/todo-app-py:v$BUILD_ID"
                      sh "docker push himanshukingstorm/todo-app-py:v$BUILD_ID"

                        echo "This Push is Based on Docker Image as Version :v$BUILD_ID"
                        echo "Pushed with Success into Dockerhub"
                          }
                  }

    stage ('Update Manifest'){
           when {
                  anyOf {
                    branch 'main'
                         }
                }
           
//        steps {
//                 script {
//                     // Read the original YAML file
//                     def yamlContent = readFile 'todo_app_deployment.yml'
                    
//                     // Modify the YAML content using Jenkins environment variables
//                     def modifiedYamlContent = yamlContent.replace('image: himanshukingstorm/todo-app-py:v${BUILD_ID}', 'image: himanshukingstorm/todo-app-py:v' + env.BUILD_ID)
                    
//                     // Write the modified YAML back to the file
//                     writeFile file: 'todo_app_deployment.yml', text: modifiedYamlContent
//                        }
//               }      
      
           steps {
//                 sh "echo $BUILD_ID"

// sh "sed -i 's|image: himanshukingstorm/todo-app-py:v\$BUILD_ID|image: himanshukingstorm/todo-app-py:v\${env.BUILD_ID}|' todo_app_deployment.yml"
     sh "echo $BUILD_ID > build_id.txt"
     sh "cat build_id.txt"        
//                sh "sed -i 's|${BUILD_ID}|$(cat build_id.txt)|' todo_app_deployment.yml"
//              sh "sed -i \"s|\\\${BUILD_ID}|$(cat build_id.txt)|\" todo_app_deployment.yml"
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
                          script{
                            sh "kubectl --kubeconfig=$my_var apply -f todo_app_deployment.yml"
                            sh 'kubectl --kubeconfig=$my_var set image deployment/todo-app todo-app=himanshukingstorm/todo-app-py:v$BUILD_ID'
                          }
                  //           sh "export SERVICE_URL= 'minikube service todo-app --url'"
                  //           sh "echo 'Project running on: $SERVICE_URL'"        
                  //           sh "kubectl --kubeconfig=$my_var expose deployment finalproject --type=LoadBalancer --port=8000"          
                                                                                          }
                          }  
                    }    
            }
       }
