require 'tmpdir'
require 'tempfile'
require 'fileutils'

module PuppetIntegration
  class TmpdirManager

    def self.instance
      @myself ||= self.new
    end

    def initialize
      @files = []
    end

    def prepare
      @root = Dir.mktmpdir
    end

    def tmpfile(prefix = 'puppet-integration')
      tmp = Tempfile.new(prefix, @root)
      # We need to hang onto the tmpfiles because Tempfile objects will be
      # deleted upon garbage collection
      @files << tmp
      tmp.path
    end

    def tmpdir(prefix = 'puppet-integration')
      tmp = Dir.mktmpdir(prefix, @root)
      tmp
    end

    def cleanup
      @files = []
      FileUtils.rm_rf @root, :secure => true
    end
  end
end
