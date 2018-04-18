class myapp::profile::application {
  # Profile has some custom code from the Myapp Team
  include myapp::application
  # Profile also uses the standard Webserver profile of the organization
  include profile::webserver
}
