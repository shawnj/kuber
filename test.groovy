#!/usr/bin/env groovy

import com.cloudbees.hudson.plugins.folder.*
import groovy.json.JsonSlurper
import hudson.*
import hudson.model.*
import jenkins.model.*


//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

job('testjob') {
    steps {
        shell('echo "hello world"')
    }
}
