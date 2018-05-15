# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include module::strings
class module::strings {

# lint:ignore:140chars
  notify {'Long String A': 
    message =>'This is the string that never ends. Yes it goes on and on my friends. Some developer just started writing without line breaks not knowing what they do, so this string will go on forever just because this is the string that never ends...'
  }

  notify {'Long String B': 
    message =>'This is another string that never ends. Yes it goes on and on my friends. Some developer just started writing without line breaks not knowing what they do, so this string will go on forever just because this is the string that never ends...'
  }

# lint:endignore

}
