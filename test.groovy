
import com.cloudbees.hudson.plugins.folder.*
import groovy.json.JsonSlurper
import hudson.*
import hudson.model.*
import jenkins.model.*

//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

def hello = 'echo hello there'

node{
    //job('testjob'){
    stage("one"){
        //steps{
            sh(hello)
        //}
    }
    //}
}



