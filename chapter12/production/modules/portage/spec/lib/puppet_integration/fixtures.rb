module PuppetIntegration
  module Fixtures
    def fixture_data_path(path)
      @path = path
    end

    def fixture_data(name)
      full_path = File.join(@path, name)
      puts "reading full path #{full_path}"
      File.read full_path
    end

    def self.included(klass)
      klass.extend self
    end
  end
end
