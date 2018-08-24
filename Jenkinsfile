def registryCredentialId = "buildpipeline-acr-cred"
def slackChannel = 'sre-product-notify'
def slackTokenCredentialId = 'slack-token-bde-notifications'

pipeline {
  agent any
  environment {
      SCMVARS=['GIT_BRANCH:origin/support_multiple_dockerfiles', 'GIT_COMMIT:2552e5f5d92808e0cdac07fdf449b4eecc822386', 'GIT_PREVIOUS_COMMIT:3c33e7a80dd91a69daedbe6b977d2fc3c2f878fd', 'GIT_URL:git@scm.starbucks.com:build-images/node-build.git']
      GIT_COMMIT="${SCMVARS.GIT_COMMIT}"
      GIT_PREVIOUS_COMMIT= "${SCMVARS.GIT_PREVIOUS_COMMIT}"
  }
  stages {
    stage("Build") {
      steps {
        // Builds the actual docker image
          //sh 'printenv'
          echo "${SCMVARS}"

          echo GIT_COMMIT
          sh """

            # Files to build
            FILES=\$(git diff --name-only ${GIT_PREVIOUS_COMMIT} ${GIT_COMMIT})

            echo \$FILES

            """
      } // steps
    } // stage("Build")
    } // stages
} //pipeline