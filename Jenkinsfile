pipeline{
    agent any
    stages{
        stage('one'){
            steps{
                scm Checkout
                load 'seed.groovy'
            }
        }
    }
}