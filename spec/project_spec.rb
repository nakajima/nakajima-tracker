require File.dirname(__FILE__) + '/spec_helper'

describe Nakajima::Project do
  describe "Project" do
    it "has a name" do
      new_project('client-a').name.should == 'client-a'
    end

    it "has file path" do
      new_project('client-a').filepath.should == File.join(ENV['HOME'], '.client-a.nkt')
    end

    it "saves to .project-name" do
      project = new_project('client-a')
      File.exist?(project.filepath).should be_false
      new_project('client-a').save
      File.exist?(project.filepath).should be_true
    end

    describe "total_time" do
      before(:each) do
        @t = Time.now
        @project = new_project('client-a')

        @first_session = new_session
        @first_session.start(@t - 1000)
        @first_session.stop(@t - 900)

        @second_session = new_session
        @second_session.start(@t - 300)
        @second_session.stop(@t - 200)

        @project.sessions = [@first_session, @second_session]
      end

      it "adds session times" do
        @project.total_time.should == 200
      end

      it "can filter by time" do
        @project.total_time(:since => (@t - 500)).should == 100
      end
    end

    describe "sessions list" do
      it "starts with none" do
        project = new_project('client-a')
        project.sessions.should be_empty
      end

      it "gets added when finished" do
        project = new_project('client-a')
        project.start!
        proc { project.stop! }.should change {
          project.sessions.size
        }
      end

      it "gets saved" do
        project = new_project('client-a')
        project.start! 'working on feature'
        project.stop!
        project.save

        loaded = YAML.load_file(project.filepath)
        loaded.should have(1).session
        loaded.first.description.should == 'working on feature'
      end
    end
  end
end
