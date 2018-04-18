class myapp::role::app_server {
  # Global Baseline used by entire organization
  include profile::baseline
  # Profile generated specifically by myapp team
  include myapp::profile::application
}
