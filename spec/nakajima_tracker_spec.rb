require 'spec/spec_helper'

describe Nakajima::Tracker do
  def new_tracker
    Nakajima::Tracker.new
  end

  def new_project(name='client-a')
    Nakajima::Project.new(name)
  end

  def new_session
    Nakajima::Session.new
  end

  before(:each) do
    FileUtils.rm(ENV['HOME'] + "/.client-a") rescue nil
  end

  describe "Tracker" do
    it "finds project name from current directory" do
      stub(Dir).pwd { 'client-a' }
      new_tracker.project.should == 'client-a'
    end
  end

  describe "Session" do
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

    it "gets date from start time" do
      t = Time.now
      session = new_session
      session.start(t - 100000)
      session.date.should == Date.new((t - 100000).to_i)
    end
  end

  describe "Project" do
    it "has a name" do
      new_project('client-a').name.should == 'client-a'
    end

    it "has file path" do
      new_project('client-a').filepath.should == ENV['HOME'] + '/.client-a'
    end

    it "saves to .project-name" do
      project = new_project('client-a')
      File.exist?(project.filepath).should be_false
      new_project('client-a').save
      File.exist?(project.filepath).should be_true
    end

    it "has sessions" do
      project = new_project('client-a')
      project.sessions.should be_empty
      project.start! # Starting doesn't add to list
      project.sessions.should be_empty
      proc {
        project.stop!
      }.should change { project.sessions.size }
    end
  end
end
