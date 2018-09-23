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
import hudson.maven.MavenModule
import hubson.matrix.MatrixConfiguration

node {
   echo 'Hello World'
}

jenkins.model.Jenkins.getInstance().getAllItems().each {
  // MavenModule is superfluous project returned by getAllItems()
  if (!(it instanceof hudson.maven.MavenModule || 
        it instanceof hudson.matrix.MatrixConfiguration)) {
      println it
  }
}