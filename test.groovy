#!/usr/bin/env groovy

import com.cloudbees.hudson.plugins.folder.*
import groovy.json.JsonSlurper
import hudson.*
import hudson.model.*
import jenkins.model.*
import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement


//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

freeStyleJob('test-job') {
    steps {
        shell('echo "hello world"')
    }
}
