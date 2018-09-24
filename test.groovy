//def gitUrl = 'git://github.com/shawnj/kuber.git'
println("Test Job")

job('testjob') {
    steps {
        shell('echo "hello world"')
    }
}
