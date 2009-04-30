require 'spec/spec_helper'

describe Nakajima::Tracker do
  describe "Tracker" do
    it "finds project name from current directory" do
      stub(Dir).pwd { 'client-a' }
      new_tracker.project.should == 'client-a'
    end
  end
end
