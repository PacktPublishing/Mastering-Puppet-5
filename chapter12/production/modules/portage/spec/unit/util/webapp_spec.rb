require 'spec_helper'

require 'puppet/util/webapp'

describe Puppet::Util::Webapp do
  describe "valid_name?" do

    valid_names = [
      'localhost::',
      'localhost::/',
      'localhost::app/foo',
      'localhost::/app/foo',
      'www.foo.com::',
      'www.foo.com::/',
      'www.foo.com::/site/bar/',
    ]

    invalid_names = [
      '',
      ':',
      '::',
      '::/',
      'localhost',
    ]

    valid_names.each do |name|
      it "should accept '#{name}' as a valid name" do
        Puppet::Util::Webapp.valid_name?(name).should be_true
      end
    end

    invalid_names.each do |name|
      it "should reject '#{name}' as an invalid name" do
        Puppet::Util::Webapp.valid_name?(name).should be_false
      end
    end
  end

  describe "valid_path?" do

    valid_paths = [
      '/var/www/localhost/htdocs',
      '/var/www/localhost/htdocs-secure',
      '/www/localhost/htdocs/app',
      '/mnt/www.foo.com/htdocs-secure/',
      '/mnt/www-data/www.foo.com/htdocs/site/bar',
    ]

    invalid_paths = [
      '/var/www',
      '/var/www/localhost',
      '/mnt/localhost/app',
      '/var/www/localhost/htdocs-insecure/app',
    ]

    valid_paths.each do |path|
      it "should accept '#{path}' as a valid path" do
        Puppet::Util::Webapp.valid_path?(path).should be_true
      end
    end

    invalid_paths.each do |path|
      it "should reject '#{path}' as an invalid path" do
        Puppet::Util::Webapp.valid_path?(path).should be_false
      end
    end
  end

  describe "valid_app?" do

    valid_apps = [
      'django 1.4.5',
      'phpmyadmin 3.5.8',
    ]

    invalid_apps = [
      'django',
      '1.4.5',
      'phpmyadmin  3.5.3',
    ]

    valid_apps.each do |app|
      it "should accept '#{app}' as a valid app" do
        Puppet::Util::Webapp.valid_app?(app).should be_true
      end
    end

    invalid_apps.each do |app|
      it "should reject '#{app}' as an invalid app" do
        Puppet::Util::Webapp.valid_app?(app).should be_false
      end
    end
  end

  describe "fix_dir" do

    fixed_dirs = {
      nil     => '/',
      ''      => '/',
      '/'     => '/',
      '/var/' => '/var/',
    }

    fixed_dirs.each do |dir, fixed|
      it "should fix '#{dir}' to '#{fixed}'" do
        Puppet::Util::Webapp.fix_dir(dir).should == fixed
      end
    end
  end

  describe "build_opts" do

    built_opts = {
      {} =>
        [],
      {:secure => :yes, :soft => :no} =>
        ['--secure'],
      {:host => 'www.foo.com'} =>
        ['--host', 'www.foo.com'],
      {:host => 'localhost', :dir => '/app', :secure => :yes} =>
        ['--host', 'localhost', '--dir', '/app', '--secure'],
    }

    built_opts.each do |webapp, opts|
      it "should build '#{opts}' for '#{webapp}'" do
        Puppet::Util::Webapp.build_opts(webapp).should =~ opts
      end
    end
  end

  describe "parse_name" do

    valid_names = [
      {
        :name => 'localhost::/app/foo',
        :expected => {
          :host => 'localhost',
          :dir => '/app/foo',
        }
      },
      {
        :name => 'www.foo.com::',
        :expected => {
          :host => 'www.foo.com',
          :dir => '/',
        }
      },
    ]

    valid_names.each do |name|
      name_str = name[:name]
      name_hash = name[:expected]
      it "should parse '#{name_str}' as '#{name_hash}'" do
        Puppet::Util::Webapp.parse_name(name_str).should == name_hash
      end
    end

    invalid_names = [
      '',
      '::',
      'localhost',
    ]

    invalid_names.each do |name|
      it "should raise an error when parsing '#{name}'" do
        expect {
          Puppet::Util::Webapp.parse_name(name)
        }.to raise_error, Puppet::Util::Webapp::WebappError
      end
    end
  end

  describe "parse_path" do

    valid_paths = [
      {
        :path => '/var/www/localhost/htdocs',
        :expected => {
          :name => 'localhost::/',
          :host => 'localhost',
          :dir => '/',
          :secure => :no,
        },
      },
      {
        :path => '/www/localhost/htdocs-secure/app',
        :expected => {
          :name => 'localhost::/app',
          :host => 'localhost',
          :dir => '/app',
          :secure => :yes,
        },
      },
      {
        :path => '/mnt/www-data/www.foo.com/htdocs/site/bar',
        :expected => {
          :name => 'www.foo.com::/site/bar',
          :host => 'www.foo.com',
          :dir => '/site/bar',
          :secure => :no,
        },
      },
    ]

    valid_paths.each do |path|
      path_str = path[:path]
      path_hash = path[:expected]
      it "should parse '#{path_str}' as '#{path_hash}'" do
        Puppet::Util::Webapp.parse_path(path_str).should == path_hash
      end
    end

    invalid_paths = [
      '/var/www',
      '/var/www/localhost',
      '/mnt/localhost/app',
      '/var/www/localhost/htdocs-insecure/app',
    ]

    invalid_paths.each do |path|
      it "should raise an error when parsing '#{path}'" do
        expect {
          Puppet::Util::Webapp.parse_path(path)
        }.to raise_error, Puppet::Util::Webapp::WebappError
      end
    end
  end

  describe "parse_app" do

    valid_apps = [
      {
        :app => 'django 1.4.5',
        :expected => {
          :appname => 'django',
          :appversion => '1.4.5',
        }
      },
    ]

    valid_apps.each do |app|
      app_str = app[:app]
      app_hash = app[:expected]
      it "should parse '#{app_str}' as '#{app_hash}'" do
        Puppet::Util::Webapp.parse_app(app_str).should == app_hash
      end
    end

    invalid_apps = [
      'django',
      '1.4.5',
      'phpmyadmin  3.5.3',
    ]

    invalid_apps.each do |app|
      it "should raise an error when parsing '#{app}'" do
        expect {
          Puppet::Util::Webapp.parse_app(app)
        }.to raise_error, Puppet::Util::Webapp::WebappError
      end
    end
  end

  describe "format_webapp" do
    formatted_webapps = {
      {
        :host => 'localhost',
        :dir => '/',
      } => 'localhost::/',
      {
        :host => 'www.foo.com',
        :dir => '/app',
        :secure => :yes,
      } => 'www.foo.com::/app',
    }

    formatted_webapps.each do |webapp, formatted|
      it "should format '#{webapp}' as '#{formatted}'" do
        Puppet::Util::Webapp.format_webapp(webapp).should == formatted
      end
    end
  end
end
