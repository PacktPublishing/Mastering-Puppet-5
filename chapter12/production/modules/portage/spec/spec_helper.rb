dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$LOAD_PATH.unshift(dir, dir + 'lib', dir + '../lib')

spec_libdir = File.expand_path('lib', File.dirname(__FILE__))
$LOAD_PATH.unshift spec_libdir
require 'puppet_integration'

require 'mocha'
require 'puppet'

PROJECT_ROOT = File.expand_path('..', File.dirname(__FILE__))

RSpec.configure do |config|
  config.mock_with :mocha

  # (portage-#38) specs fail when /etc/portage/package.use/* files cannot be
  # chmodded. This isn't the best location for these stubs, but right now
  # they're pretty tightly integrated into the portagefile provider. Since
  # the portagefile provider is pretty universal across these specs, this will
  # do for now.
  config.before do
    Dir.stubs(:mkdir)
    File.stubs(:chmod)
  end
end

##
# This method loads system atoms under /usr/portage in an array.
#
# This is useful for fuzzy testing the atom validation and writing new test
# cases.
#
def system_atoms
  atoms = []

  Dir.glob('/usr/portage/*/*').each do |dir|
    next unless File.directory? dir
    atoms << dir.split('/').slice(3,4).join('/')
  end

  atoms
end
