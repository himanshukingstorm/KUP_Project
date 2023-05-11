pipeline  {
  agent any
    
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
                      echo "Test Success"
                      echo "Build Number:  $BUILD_NUMBER  Build ID: $BUILD_ID BUILD_TAG: $BUILD_TAG"
                      echo "GIT_COMMIT: $GIT_COMMIT JOB_NAME: $JOB_NAME"
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
                        sh 'docker build -t todo-app-py-flask:v.$BUILD_ID .'
                        echo "This is Build Based on Docker Image version v.$BUILD_ID"
                        echo "Build Success"
                           }
                  }

stage('Generate Artifact'){
                    when {
                    anyOf {
                   branch 'develop'
//                       branch 'main'
                          }
                       }
  
    steps{
     script{
      sh '''
       tar -cf app.v$BUILD_ID.tar ./
         '''
           }
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
                      sh "docker tag todo-app-py-flask:v.$BUILD_ID himanshukingstorm/todo-app-py-flask:v.$BUILD_ID"
                      sh "docker push himanshukingstorm/todo-app-py-flask:v.$BUILD_ID"

                        echo "This Push is Based on Docker Image as Version :v.$BUILD_ID"
                        echo "Pushed with Success into Dockerhub"                          }
                  }

    stage ('Update Manifest'){
           when {
                  anyOf {
                    branch 'main'
                         }
                }
                 
           steps {
              sh "sed -i 's/version/${BUILD_ID}/g' todo_app_deployment.yml"
              echo "YAML File Updated with current Build"
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
                                }
                                                                                          }
                          }  
                    }    
            }
       }
