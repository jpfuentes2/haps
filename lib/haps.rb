$: << File.dirname(__FILE__)

require 'logger'
require 'haps/configurable'

module HAPS
  autoload :Server, 'haps/server'
  autoload :Client, 'haps/client'
end
