require 'langulator/translation'
require 'translation_interface'

describe Langulator::Translation do
  subject { Langulator::Translation.new(:location => 'spec/fixtures/whatever.yml') }

  it_behaves_like 'a translation'

  its(:path) { should eq('spec/fixtures/') }
  its(:location) { should eq('spec/fixtures/whatever.yml') }
  its(:filename) { should eq('whatever.yml') }

  describe "with a hyphen" do
  subject { Langulator::Translation.new(:location => 'spec/fixtures/nb-no.yml') }
    its(:filename) { should eq('nb-no.yml') }
  end

  describe "in the current directory" do
    subject { Langulator::Translation.new(:location => 'whatever.yml') }
    its(:path) { should eq('./') }
    its(:filename) { should eq('whatever.yml') }
  end

  describe 'with a missing file' do
    subject { Langulator::Translation.new(:location => 'spec/fixtures/does_not_exist.yml') }
    its(:path) { should eq('spec/fixtures/') }
    its(:filename) { should eq('does_not_exist.yml') }
    its(:translations) { should eq({}) }
  end

  describe "with a path and base filename" do
    subject { Langulator::Translation.new(:path => 'spec/fixtures/', :base_filename => 'whatever') }
    its(:path) { should eq('spec/fixtures/') }
    its(:location) { should eq('spec/fixtures/whatever.yml') }
    its(:filename) { should eq('whatever.yml') }
  end

  its(:translations) { should eq({"some" => {"stuff" => "yadda yadda"}}) }

  describe "with provided translations" do
    subject { Langulator::Translation.new(:location => './nonexistant.yml', :translations => {"do" => "something"}) }
    its(:translations) { should eq({"do" => "something"}) }
  end

  describe "#write" do
    let(:location) { 'spec/fixtures/xy.yml' }
    subject { Langulator::Translation.new(:location => location, :translations => {"some" => "stuff"}) }

    before(:each) { FileUtils.rm(location) if File.exists?(location) }
    after(:each) { FileUtils.rm(location) if File.exists?(location) }

    it "outputs the content to the given location" do
      subject.write

      Langulator::Translation.new(:location => location).translations.should eq({"some" => "stuff"})
    end
  end
end
