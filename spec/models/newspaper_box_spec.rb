require 'rails_helper'

describe NewspaperBox do
  context "generate geografi coordinates" do
    let(:newspaper_box) { FactoryGirl.create(:newspaper_box)}
    subject { newspaper_box }
    
    it { should be_valid }
    its(:longitude) { should_not be_nil }
    its(:latitude) { should_not be_nil }
  end
  
  context "generate history records after generate newspaper box" do
    it "" do
      expect {
        FactoryGirl.create(:newspaper_box)
      }.to change { History.count }.by(1)
    end
  end
  
  context "report testing" do
    5.times do |index|
      FactoryGirl.create(:newspaper_box)
    end
    p NewspaperBox.report
    it "should return an Array" do
      NewspaperBox.report.should be_an_instance_of Array
    end
    it "should include 5 elements" do
      NewspaperBox.report.count.should == 5 
    end
  end
end