$LOAD_PATH.unshift(File.dirname(__FILE__) << "/../lib")
require 'rubygems'
require 'fiveruns/dash/activerecord'

require 'test/unit'

begin
  require 'redgreen'
rescue LoadError
end

require 'activerecord'
require 'shoulda'