require 'langulator/individual_translations'

describe Langulator::IndividualTranslations do
  subject { Langulator::IndividualTranslations.new }

  describe "collection" do
    let(:english) { stub(:english, :language => :en, :translations => {"stuff" => "whatever"}) }
    let(:french) { stub(:french, :language => :fr, :translations => {"truc" => "machin"}) }

    before(:each) do
      subject << english
      subject << french
    end

    it "can iterate through them" do
      subject.map(&:language).should eq([:en, :fr])
    end

  end
end
