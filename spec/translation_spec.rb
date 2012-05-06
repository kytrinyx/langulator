require 'langulator/translation'
require 'translation_interface'

describe Langulator::Translation do
  subject { Langulator::Translation.new('spec/fixtures/whatever.yml') }

  it_behaves_like 'a translation'

  its(:path) { should eq('spec/fixtures/') }
  its(:location) { should eq('spec/fixtures/whatever.yml') }
  its(:filename) { should eq('whatever.yml') }

  describe "with a hyphen" do
    before(:each) do
      subject.location = 'spec/fixtures/nb-no.yml'
    end
    its(:filename) { should eq('nb-no.yml') }
  end

  describe "in the current directory" do
    before(:each) do
      subject.location = 'whatever.yml'
    end
    its(:path) { should eq('./') }
    its(:filename) { should eq('whatever.yml') }
  end

  its(:translations) { should eq({"some" => {"stuff" => "yadda yadda"}}) }

  describe "with provided translations" do
    subject { Langulator::Translation.new('./nonexistant.yml', :translations => {"do" => "something"}) }
    its(:translations) { should eq({"do" => "something"}) }
  end

  describe "#write" do
    let(:filename) { 'spec/fixtures/xy.yml' }
    subject { Langulator::Translation.new(filename, :translations => {"some" => "stuff"}) }

    before(:each) { FileUtils.rm(filename) if File.exists?(filename) }
    after(:each) { FileUtils.rm(filename) if File.exists?(filename) }

    it "outputs the content to the given location" do
      subject.write

      Langulator::Translation.new(filename).translations.should eq({"some" => "stuff"})
    end
  end
end
