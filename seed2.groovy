// This script takes in a JSON file, and creates the respective folders / jobs from the content.
import com.cloudbees.hudson.plugins.folder.*
import groovy.json.JsonSlurper
import hudson.*
import hudson.model.*
import jenkins.model.*

pipelineJob("TestJob2") {
    description "New Job"
    displayName("TestJob2")
    disabled(false)
    triggers {
        githubPush()
        scm('')
    }

    definition {
        cps {
            script(readFileFromWorkspace('test.groovy'))
        }
    } // definition
} 