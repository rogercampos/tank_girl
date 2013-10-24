require 'spec_helper'

describe TankGirl::Configuration::OptionsMatcher do
  context do
    subject { TankGirl::Configuration::OptionsMatcher.new(a: 1, b: 2) }

    it "matches keys and values" do
      subject.should be_match(a: 1)
    end

    it "does not match if key value are different" do
      subject.should_not be_match(a: 2)
    end

    it "does not match if key is not defined" do
      subject.should_not be_match(c: 1)
    end
  end
end
