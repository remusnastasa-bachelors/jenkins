#!groovy

job('demo') {
    steps {
        shell('echo Hello World!')
    }
}

