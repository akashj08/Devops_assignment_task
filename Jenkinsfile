node {
    // reference to maven
    // ** NOTE: This 'maven-3.6.1' Maven tool must be configured in the Jenkins Global Configuration.   
    def mvnHome = tool 'maven-3.6.1'

    stage('CleanWorkspace') {
            cleanWs()
        } 
    stage('Checkout') {
            checkout scm
        }

    stage('Intization') {    
      mvnHome = tool 'maven-3.6.1'
    }    
  
    stage('Build Project') {
      // build project via maven
      sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean package"
    }
	
	stage('Publish Tests Results'){
      parallel(
        publishJunitTestsResultsToJenkins: {
          echo "Publish junit Tests Results"
		  junit '**/target/surefire-reports/TEST-*.xml'
		  archive 'target/*.jar'
        },
        publishJunitTestsResultsToSonar: {
          echo "This is branch b"
      })
    }
		
    stage('Build Docker Image') {
      // build docker image
      sh "whoami"
      //sh "mv ./target/hello*.jar ./data" 
      sh "sudo docker build -t akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER} ."  
      
    }
   
    stage('Push Docker Image'){
      
      // deploy docker image to nexus
      withCredentials([string(credentialsId: 'DOCKER_PASSWORD', variable: 'DOCKER_PASSWORD')]) {        
      echo "Docker Image Tag Name: akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER}"
      sh "sudo docker login -u akashj08 -p ${DOCKER_PASSWORD}"
      sh "sudo  docker push akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER}"
    }
    }
    stage ('Deploy to Docker Image') {
            echo "We are going to deploy service"
            sh "ssh app-server sudo docker pull akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER}"

            sh "ssh app-server sudo docker stop sprint-boot-app-ci-cd"
            
            sh "ssh app-server sudo docker rm sprint-boot-app-ci-cd"
            
            sh "ssh app-server sudo docker run --name sprint-boot-app-ci-cd -d -p 8080:8080 akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER}"
       }
  

      stage ('Sanity Check') {
            echo "We are going to deploy service"
            sleep (10)

            status = sh (
                        script: "ssh app-server curl localhost:8080", 
                                returnStdout: true
                            ).trim()
            echo "Curl Response: ${status}"
            //sh "ssh app-server curl localhost:8080 "

       }



}
