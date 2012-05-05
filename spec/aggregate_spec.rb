# encoding: utf-8
require 'langulator/aggregate'

describe Langulator::Aggregate do

  describe "de-aggregating translations" do
    subject { Langulator::Aggregate.new({}, :languages => [:english]) }

    it 'extracts English' do
      input = {:rock => {:english => "rock"}, :paper => {:english => "paper"}}
      expected_output = {:rock => "rock", :paper => "paper"}
      subject.extract(:english, input).should eq(expected_output)
    end

    it "extracts complicated English" do
      input = {:a => {:really => {:deeply => {:nested => {:game => {:rock => {:english => "rock"}, :paper => {:english => "paper"}}}}}}}
      expected_output = {:a => {:really => {:deeply => {:nested => {:game => {:rock => "rock", :paper => "paper"}}}}}}
      subject.extract(:english, input).should eq(expected_output)
    end
  end

  let(:aggregate) do
    {
      "spec/fixtures/" => {
        "words" => {
          "affirmative" => {
            :klingon => "HISlaH",
            :lolcode => "YA RLY"
          },
          "negative" => {
            :klingon => "ghobe'",
            :lolcode => "NO WAI"
          },
          "hello" => {
            :klingon => "nuqneH",
            :lolcode => "O HAI"
          }
        }
      }
    }
  end

  let(:klingon) { {"words" => {"affirmative" => "HISlaH", "negative" => "ghobe'", "hello" => "nuqneH"}} }
  let(:lolcode) { {"words" => {"affirmative" => "YA RLY", "negative" => "NO WAI", "hello" => "O HAI"}} }

  context "with aggregated data" do
    subject { Langulator::Aggregate.new(aggregate, :languages => [:klingon, :lolcode]) }

    it "filters out the klingon" do
      subject.individual_translations[:klingon].should eq("spec/fixtures/" => klingon)
    end

    it "filters out the lolcode" do
      subject.individual_translations[:lolcode].should eq("spec/fixtures/" => lolcode)
    end
  end

  context "writing individual translations" do
    let(:klingon_file) { "spec/fixtures/klingon.yml" }
    let(:lolcode_file) { "spec/fixtures/lolcode.yml" }

    subject { Langulator::Aggregate.new(aggregate, :languages => [:klingon, :lolcode]) }

    before(:each) do
      FileUtils.rm(klingon_file) if File.exists? klingon_file
      FileUtils.rm(lolcode_file) if File.exists? lolcode_file
    end

    after(:each) do
      FileUtils.rm(klingon_file) if File.exists? klingon_file
      FileUtils.rm(lolcode_file) if File.exists? lolcode_file
    end

    it "decompiles" do
      subject.decompile
      YAML.load(File.read(klingon_file)).should eq(klingon)
      YAML.load(File.read(lolcode_file)).should eq(lolcode)
    end
  end
end
