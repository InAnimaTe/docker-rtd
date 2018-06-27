#!/bin/groovy
node {

    stage('checkout') {
        // Clone repo
        checkout([
            $class: 'GitSCM',
            doGenerateSubmoduleConfigurations: false,
            extensions: [
                [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: false]
            ],
            submoduleCfg: [],
            userRemoteConfigs: [[]]
        ])
    }

    stage('build') {
        sh "docker-compose build"
    }
}
