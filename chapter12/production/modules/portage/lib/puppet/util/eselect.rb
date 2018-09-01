module Puppet::Util::Eselect
  # Util methods for Eselect types and providers.
  #

  extend self

  COMMANDS = {
    :eselect    => '/usr/bin/eselect',
    :gcc_config => '/usr/bin/gcc-config'
  }

  # Builds a module combining the default and special modules
  #
  # @param [String] name The name of the module
  #
  # @return [Hash]:
  #   * command [Symbol] The command used to manage this module
  #   * flags [Array<String>] The flags to pass to the command
  #   * param [String] The param to be passed after flags, or nil
  #   * get [Array[String]] The flags to be passed to get the state of the module
  #   * set [Array[String]] The flags to be passed to set the state of the module
  #   * parse [Proc] The function to parse the command output
  def module(name)
    default_module(name).merge(CUSTOM_MODULES[name])
  end

  # Builds a default module
  #
  # @param [String] name The name of the module
  #
  # @return [Hash] The module
  #
  # @api private
  private
  def default_module(name)
    {
      :command => :eselect,
      :flags => ['--brief', '--color=no'],
      :param => "#{name}",
      :get => ['show'],
      :set => ['set'],
      :parse => Proc.new { |x| x.strip },
    }
  end

  # Builds the custom modules
  #
  # @return [Hash<Symbol,Hash>] The custom modules
  #
  # @api private
  private
  def build_custom_modules
    modules = {
      'gcc' => {
        :command => :gcc_config,
        :flags   => ['--nocolor'],
        :param   => nil,
        :get     => ['-c'],
        :set     => ['-f'],
      },
      'ruby' => {
        :parse => Proc.new { |x| x.split.first.strip },
      },
      'java-vm' => {
        :get => ['show', 'system'],
        :set => ['set', 'system'],
      },
    }.merge(Hash[
      ['python2','python3'].map { |x|
        ['python::'+x, {
          :param => 'python',
          :get   => ['show', '--'+x],
          :set   => ['set', '--'+x],
        }]
      }]
    ).merge(Hash[
      ['cli','apache2','fpm','cgi'].map { |x|
        ['php::'+x, {
          :param => 'php',
          :get   => ['show', x],
          :set   => ['set', x],
        }]
      }]
    )
    modules.default = {}
    modules
  end

  CUSTOM_MODULES = build_custom_modules()
end
