//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

node{
    job('testjob'){
        steps{
            shell('echo "hello world"')
        }
    }
}



