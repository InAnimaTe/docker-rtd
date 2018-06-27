#!/bin/groovy
node {

    stage('checkout') {
        // Clone repo
        checkout([
            $class: 'GitSCM',
            branches: scm.branches,
            doGenerateSubmoduleConfigurations: false,
            extensions: [
                [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: false]
            ],
        ])
    }

    stage('build') {
        sh "docker-compose build"
    }
}
