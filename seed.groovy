#!/usr/bin/env groovy

import jenkins.model.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.microsoftopentechnologies.windowsazurestorage.helper.*
import groovy.json.JsonSlurper
import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement
import com.microsoftopentechnologies.windowsazurestorage.*

addSeedJob()

void addSeedJob() {
  def workspace = new File('.')
  def jobManagement = new JenkinsJobManagement(System.out, [:], workspace)
    new DslScriptLoader(jobManagement).runScript("""
      folder("bde") {
        displayName("bde")
        description("Folder for bde.")
      }
      job('bde/testjob') {
        scm {
          git('https://github.com/shawnj/kuber.git')
        }

        triggers {
          githubPush()
        }

        steps {
          dsl {
            external("test.groovy")
            ignoreExisting(true)
            removeAction('DELETE')
          }
       }
     }

        queue('bde/testjob')

        """)
}
