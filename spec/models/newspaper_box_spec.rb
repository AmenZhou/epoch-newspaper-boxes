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
  
  context "calc_paper_amount without argument testing" do
    before do
      5.times do |index|
        FactoryGirl.create(:newspaper_box)
      end
    end
    it "should return an Array" do
      NewspaperBox.calc_paper_amount.should be_an_instance_of Array
    end
    it "should include 1 element" do
      NewspaperBox.calc_paper_amount.count.should == 1
    end
    it "should include a element which mon is 500" do
      NewspaperBox.calc_paper_amount.first.mon.should == 500
    end
    it "should include a element which sum is the sum of all other days" do
      #mon 100 * 5  + tue 200 * 5  +  wed 150 * 5  +  thu 50 * 5  +  fri 300 * 5 +  sat 500 * 5
      summary = 500 + 1000 + 750 + 250 + 1500 + 2500
      NewspaperBox.calc_paper_amount.first.sum.should == summary
    end
  end
  
  context "calc_paper_amount with argument testing" do
    before do
      %w(Brooklyn Flushing Elmhurst Manhattan LongIsland).each do |city|
        n = FactoryGirl.create(:newspaper_box)
        n.city = city
        n.save
      end
      @reports = NewspaperBox.calc_paper_amount(:city)
    end
    it "should has five elements in the return array" do
      @reports.count.should == 5
    end
    it "should has a city attr of each elements in the return array" do
      @reports.each { |report| report.city.should_not be_nil }
    end
    it "should has 5 different cities" do
      @reports.map { |report| report.city }.uniq.count.should == 5
    end
    it "should has sum" do
      @reports.map { |report| report.sum.should == report.mon + report.tue + report.wed + report.thu + report.fri + report.sat + report.sun}
    end
  end
end