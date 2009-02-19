$LOAD_PATH.unshift(File.dirname(__FILE__) << "/../lib")
require 'fiveruns/dash/recipes/activerecord'

require 'test/unit'

begin
  require 'redgreen'
rescue LoadError
end

require 'activerecord'
require 'shoulda'