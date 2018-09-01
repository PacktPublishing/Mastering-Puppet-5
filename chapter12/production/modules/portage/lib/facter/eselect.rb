if Facter.value(:operatingsystem) == 'Gentoo'
  eselect_modules = %x(eselect modules list).split('  ').reject! { |c| c.empty? }.delete_if { |c| c["\n"] }
  eselect_modules_blacklist = [
    'help', 'usage', 'version', 'bashcomp', 'env', 'fontconfig', 'modules',
    'news', 'rc',
  ]
  eselect_modules = eselect_modules - eselect_modules_blacklist
  eselect_modules_multitarget = {
    'php' => ['cli', 'apache2', 'fpm', 'cgi'],
  }

  def facter_add(name, output)
    Facter.add(name) do
      confine :operatingsystem => :gentoo
      setcode do
        output
      end
    end
  end

  eselect_modules.each do |eselect_module|
    if (submodules = eselect_modules_multitarget[eselect_module])
      submodules.each do |target|
        output = %x{eselect --brief --color=no #{eselect_module} show #{target}}.strip
        facter_add("eselect_#{eselect_module}_#{target}", output)
      end
    else
      output = %x{eselect --brief --color=no #{eselect_module} show}.strip.split(' ')[0]
      if not ['(none)', '(unset)'].include? output
        facter_add("eselect_#{eselect_module}", output)
      end
    end
  end
end
