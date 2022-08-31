#!groovy

pipeline {
  environment {
    imageName = "remusnastasa/my-jenkins"
    dockerImage = ''
  }
  agent any
  stages {
    stage('Checkout') {
      steps {
      	checkout scm
      }
    }

    stage('Build') {
    	steps {
    		script {
			dockerImage = docker.build imageName
	    	}
	}
    }
    
    stage('Deploy') {
    	steps{
	    	script {
			docker.withRegistry('') {
				dockerImage.push('latest')
			}
	    	}
        }
    }
    stage('Cleanup') {
    	steps {
        	sh "docker rmi $imagename:latest --force"
    	}
    }
  }
}
