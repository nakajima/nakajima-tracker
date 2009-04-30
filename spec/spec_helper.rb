require 'rubygems'
require 'spec'
require 'cgi'
require 'rr'

def pre(str='', &block)
  val = block_given? ? block.call : str
  puts '<pre>' + CGI.escapeHTML(val) + '</pre>'
end

$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[.. lib nakajima])

require File.dirname(__FILE__) + '/../lib/nakajima-tracker'

Spec::Runner.configure { |c|
  c.mock_with(:rr)
  c.include(Module.new {
    def new_tracker
      Nakajima::Tracker.new
    end

    def new_project(name='client-a')
      Nakajima::Project.new(name)
    end

    def new_session(description='')
      Nakajima::Session.new(description)
    end
  })
  
  c.before(:each) do
    FileUtils.rm(ENV['HOME'] + "/.client-a.nkt") rescue nil
  end

  c.after(:all) do
    FileUtils.rm(ENV['HOME'] + "/.client-a.nkt") rescue nil
  end
}