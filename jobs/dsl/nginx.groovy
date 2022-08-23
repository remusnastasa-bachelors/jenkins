pipelineJob('nginx') {

  def repo = 'https://github.com/remusnastasa-bachelors/nginx'

  triggers {
    scm('H/5 * * * *')
  }
  description("Pipeline for nginx")

  definition {
    cpsScm {
      scm {
        git {
          remote { url(repo) }
          branches('main')
          scriptPath('Jenkinsfile')
          extensions { }  // required as otherwise it may try to tag the repo, which you may not want
        }

        // the single line below also works, but it
        // only covers the 'master' branch and may not give you
        // enough control.
        // git(repo, 'master', { node -> node / 'extensions' << '' } )
      }
    }
  }
}
