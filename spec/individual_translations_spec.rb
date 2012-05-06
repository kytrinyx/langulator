require 'langulator/translation'
require 'langulator/individual_translation'
require 'langulator/individual_translations'

describe Langulator::IndividualTranslations do

  describe "collection" do
    subject { Langulator::IndividualTranslations.new(:source_language => :en, :target_languages => [:fr]) }

    let(:english) { stub(:english, :language => :en, :translations => {"stuff" => "whatever"}) }
    let(:english2) { stub(:english2, :language => :en, :translations => {"more" => "stuff"}) }
    let(:french) { stub(:french, :language => :fr, :translations => {"truc" => "machin"}) }
    let(:french2) { stub(:french2, :language => :fr, :translations => {"autre" => "bidule"}) }

    before(:each) do
      subject << english
      subject << english2
      subject << french
      subject << french2
    end

    it "can accumulate many at a time" do
      subject << [stub(:language => :nl), stub(:language => :cz)]
      subject.map(&:language).uniq.should eq([:en, :fr, :nl, :cz])
    end

    it "can iterate through them" do
      subject.map(&:language).should eq([:en, :en, :fr, :fr])
    end

    it "selects a language" do
      subject.in(:en).should eq([english, english2])
    end

    it "provides the source_translations" do
      subject.source_translations.should eq([english, english2])
    end

    it "provides the target translations" do
      subject.target_translations.should eq([french, french2])
    end
  end

  describe "loading from a path" do
    let(:options) { {:source_language => :english, :target_languages => [:norsk], :base_path => 'spec/**/', :to => 'spec/fixtures/out.yml'} }
    subject { Langulator::IndividualTranslations.new(options) }

    its(:source_language) { should eq(:english) }
    its(:target_languages) { should eq([:norsk]) }
    its(:base_path) { should eq('spec/**/') }
    its(:aggregate_location) { should eq('spec/fixtures/out.yml') }

    it "loads the actual individual translations" do
      subject.map(&:language).uniq.should eq([:english, :norsk])
    end

  end
end
