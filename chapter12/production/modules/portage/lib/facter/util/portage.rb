module Facter::Util::Portage
  module_function

  # @return [Hash<Symbol, String>]
  def emerge_info
    output = Facter::Core::Execution.exec('emerge --info')

    values = output.scan(/[0-9A-Z_]+=".+?"/)

    hash = values.inject({}) do |hash, string|
      match = string.match(/(.*)="(.*)"/)
      key = match[1].downcase
      val = match[2]
      hash[key] = val
      hash
    end
  end
end
