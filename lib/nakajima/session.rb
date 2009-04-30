module Nakajima
  class Session
    attr_reader :description

    def initialize(description="")
      @description = description
    end

    def date
      start
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
    
    def complete?
      start and stop
    end
  end
end
