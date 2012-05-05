require 'langulator/aggregate'

describe Langulator::Aggregate do

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

  let(:klingon) { {"spec/fixtures/" => {"words" => {"affirmative" => "HISlaH", "negative" => "ghobe'", "hello" => "nuqneH"}}} }
  let(:lolcode) { {"spec/fixtures/" => {"words" => {"affirmative" => "YA RLY", "negative" => "NO WAI", "hello" => "O HAI"}}} }

  describe "combining individual translations" do
    let(:klingon_as_aggregate) do
      {
        "spec/fixtures/" => {
          "words" => {
            "affirmative" => { :klingon => "HISlaH" },
            "negative" => { :klingon => "ghobe'" },
            "hello" => { :klingon => "nuqneH" }
          }
        }
      }
    end

    let(:outfile) { 'spec/fixtures/output.yml' }

    let(:compile_options) do
      {
        :source_language => :klingon,
        :target_languages => :lolcode,
        :individual_translations => {:klingon => klingon, :lolcode => lolcode},
        :to => outfile
      }
    end

    subject { Langulator::Aggregate.new(compile_options) }

    its(:source_language) { should eq(:klingon) }
    its(:target_languages) { should eq([:lolcode]) }
    its(:languages) { should eq([:klingon, :lolcode]) }
    its(:individual_translations) { should eq({:klingon => klingon, :lolcode => lolcode}) }
    its(:aggregate_file_path) { should eq(outfile) }
    its(:aggregate) { should eq(aggregate) }

    it "remappes the source language to initialize aggregate" do
      subject.to_aggregate(:klingon, subject.individual_translations[:klingon]).should eq(klingon_as_aggregate)
    end

    it "inserts a target language into the aggregate" do
      subject.insert(:lolcode, lolcode, klingon_as_aggregate).should eq(aggregate)
    end

    it "loads an aggregate" do
      subject = Langulator::Aggregate.from_file(:from => 'spec/fixtures/translations.yml', :languages => [:klingon, :lolcode])
      subject.aggregate.should eq(aggregate)
    end

    context "writing an aggregate" do
      before(:each) do
        FileUtils.rm(outfile) if File.exists? outfile
      end

      after(:each) do
        FileUtils.rm(outfile) if File.exists? outfile
      end

      it "compiles" do
        subject.compile
        YAML.load(File.read(outfile)).should eq(aggregate)
      end
    end
  end

  describe "de-aggregating translations" do
    subject { Langulator::Aggregate.new(:languages => [:english]) }

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

  context "with aggregated data" do
    subject { Langulator::Aggregate.new(:aggregate_translations => aggregate, :languages => [:klingon, :lolcode]) }

    it "filters out the klingon" do
      subject.individual_translations[:klingon].should eq(klingon)
    end

    it "filters out the lolcode" do
      subject.individual_translations[:lolcode].should eq(lolcode)
    end
  end

  context "writing individual translations" do
    let(:klingon_file) { "spec/fixtures/klingon.yml" }
    let(:lolcode_file) { "spec/fixtures/lolcode.yml" }

    subject { Langulator::Aggregate.new(:aggregate_translations => aggregate, :languages => [:klingon, :lolcode]) }

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
      YAML.load(File.read(klingon_file)).should eq(klingon["spec/fixtures/"])
      YAML.load(File.read(lolcode_file)).should eq(lolcode["spec/fixtures/"])
    end
  end
end
