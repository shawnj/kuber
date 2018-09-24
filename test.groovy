//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

node{
    steps{
        shell('echo "hello world"')
    }
}



