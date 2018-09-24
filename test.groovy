//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

node{
    //job('testjob'){
    stage("one"){
        //steps{
            sh('echo "hello world"')
        //}
    }
    //}
}



