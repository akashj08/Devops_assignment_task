node {
    // reference to maven
    // ** NOTE: This 'maven-3.6.1' Maven tool must be configured in the Jenkins Global Configuration.   
    def mvnHome = tool 'maven-3.6.1'
    
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
      sh "mv ./target/hello*.jar ./data" 
      sh "docker build -t akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER} ."  
      
    }
   
    stage('Push Docker Image'){
      
      // deploy docker image to nexus
      withCredentials([string(credentialsId: 'DOCKER_PASSWORD', variable: 'DOCKER_PASSWORD')]) {        
      echo "Docker Image Tag Name: akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER}"
      sh "docker login -u akashj08 -p ${DOCKER_PASSWORD}"
      sh "docker push akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER}"
    }
    }
    stage ('Deploy to k8s') {
            echo "We are going to deploy service"
            sh "kubectl set image deployment/spring-boot-app spring-boot-app=akashj08/sprint-boot-app-ci-cd:${BUILD_NUMBER} -n test "
            sh "kubectl rollout status deployment/spring-boot-app -n test "
        }



}
