require 'rubygems'
require 'fileutils'
require 'yaml'

require 'session'
require 'project'

module Nakajima
  class Tracker
    def project
      Dir.pwd
    end
  end
end
