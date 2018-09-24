//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

node{
    freeStyleJob('testjob'){
        steps{
            shell('echo "hello world"')
        }
    }
}



