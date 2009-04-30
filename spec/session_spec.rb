require File.dirname(__FILE__) + '/spec_helper'

describe Nakajima::Session do
  it "has a start time" do
    t = Time.now
    session = new_session
    session.start(t)
    session.start.should == t
  end

  it "has a stop time" do
    t = Time.now
    session = new_session
    session.stop(t)
    session.stop.should == t
  end

  it "has total time" do
    t = Time.now
    session = new_session
    session.start(t - 1000)
    session.stop(t)
    session.total.should == 1000
  end

  it "knows if complete" do
    session = new_session
    session.start(Time.now)
    session.should_not be_complete
    session.stop(Time.now)
    session.should be_complete
  end

  it "has a description" do
    session = new_session('building a feature')
    session.description.should == 'building a feature'
  end

  it "gets date from start time" do
    t = Time.now
    session = new_session
    session.start(t - 100000)
    session.date.should == t - 100000
  end
end
