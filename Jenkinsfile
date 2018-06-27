#!/bin/groovy
node {

    stage('checkout') {
        // Clone repo
        checkout scm
    }

    stage('build') {
        sh "docker-compose build"
    }
}
