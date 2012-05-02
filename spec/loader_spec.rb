# encoding: utf-8
require 'langulator/loader'

describe Langulator::Loader do

  let(:english) do
    {
      "spec/fixtures/" => {
        "food" => {
          "breakfast" => "yoghurt",
          "lunch" => "sandwich",
          "dinner" => {"main_course" => "steak", "side" => "baked potato", "desert" => "chocolate mousse"}
        }
      },
      "spec/fixtures/lang/" => {
        "volume" => {
          "sound" => "loud",
          "liquid" => "sloshing",
          "hair" => "because I'm worth it"
        }
      }
    }
  end

  let(:norwegian) do
    {
      "spec/fixtures/" => {
        "food" => {
          "lunch" => "smørbrød"
        }
      },
      "spec/fixtures/lang/" => {}
    }
  end

  let(:french) do
    {
      "spec/fixtures/" => {},
      "spec/fixtures/lang/" => {}
    }
  end

  subject { Langulator::Loader.new(:base_path => 'spec/fixtures/**/', :origin => 'english', :alternates => ['norsk', 'francais']) }

  its(:paths) { should eq(['spec/fixtures/', 'spec/fixtures/lang/']) }

  its(:source_translations) { should eq(english) }
  its(:destination_translations) { should eq({'norsk' => norwegian, 'francais' => french}) }
end
