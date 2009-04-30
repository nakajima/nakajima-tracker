require 'rubygems'
require 'spec'
require 'cgi'
require 'rr'

def pre(str='', &block)
  val = block_given? ? block.call : str
  puts '<pre>' + CGI.escapeHTML(val) + '</pre>'
end

require File.dirname(__FILE__) + '/../lib/nakajima_tracker'

Spec::Runner.configure { |c| c.mock_with(:rr) }