module Nakajima
  class Project
    EXTENSION = '.nkt'
    
    attr_reader :name
    attr_writer :sessions

    def initialize(name)
      @name = name
      @sessions = []
    end

    def total_time(opts={})
      sessions(opts).inject(0) do |sum, session|
        sum + session.total
      end
    end
    
    def sessions(opts={})
      (since = opts[:since]) ?
         sessions.select { |session| session.date > since } :
        @sessions.select { |session| session.complete? }
    end

    def start!(description='')
      @current_session = Session.new(description)
      @current_session.start(Time.now)
    end

    def stop!
      @current_session.stop(Time.now)
      @sessions << @current_session
      @current_session = nil
    end

    def filepath
      File.join(ENV['HOME'], '.' + name + EXTENSION)
    end

    def save
      File.open(filepath, 'w+') do |f|
        f << sessions.to_yaml
      end
    end
  end
end