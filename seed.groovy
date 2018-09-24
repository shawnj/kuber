#!/usr/bin/env groovy

import jenkins.model.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import groovy.json.JsonSlurper
import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

addSeedJob()

void addSeedJob() {
  def workspace = new File('.')
  def jobManagement = new JenkinsJobManagement(System.out, [:], workspace)
    println("Seed Job")
    new DslScriptLoader(jobManagement).runScript("""
      folder("bde") {
        displayName("bde")
        description("Folder for bde.")
      }
      job('testjob') {
        scm {
          git('https://github.com/shawnj/kuber.git')
        }

        triggers {
          //githubPush()
        }

        steps {
          dsl {
            text(readFileFromWorkspace('test.groovy'))
            ignoreExisting(true)
            removeAction('DELETE')
          }
       }
     }

        queue('bde/testjob')

        """)
}
