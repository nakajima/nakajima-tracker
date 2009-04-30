require 'rubygems'
require 'nakajima'
require 'fileutils'
require 'yaml'

module Nakajima
  class Tracker
    def project
      Dir.pwd
    end
  end

  class Session
    def date
      Date.new(start.to_i)
    end

    def total
      stop - start
    end

    def start(time=nil)
      time ? (@start = time) : @start
    end

    def stop(time=nil)
      time ? (@stop = time) : @stop
    end
  end

  class Project
    attr_reader :name, :sessions

    def initialize(name)
      @name = name
      @sessions = []
    end

    def times
      Hash[*@times].inject([]) do |res,(start,stop)|
        res << stop - start
        res
      end
    end

    def start!
      @current_session = Session.new
      @current_session.start(Time.now)
    end

    def stop!
      @current_session.stop(Time.now)
      @sessions << @current_session
      @current_session = nil
    end

    def filepath
      File.join(ENV['HOME'], '.' + name)
    end

    def save
      File.open(filepath, 'w+') do |f|
        f << { :saved => true }.to_yaml
      end
    end
  end
end
