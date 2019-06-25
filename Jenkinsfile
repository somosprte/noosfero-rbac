pipeline {
  agent any
  stages {
    stage('Git pull') {
      steps {
        sh 'cd noosfero-rbac/'
        sh 'git pull'
      }
    }
    stage('Build') {
      steps {
        sh 'sudo docker-compose -f dev.yml down'
      }
    }
    stage('Deploy') {
      steps {
        sh 'sudo docker-compose -f dev.yml up -d'
      }
    }
  }
  environment {
    CI = 'true'
  }
}