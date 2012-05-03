# encoding: utf-8
require 'langulator'

describe Langulator do
  let(:options) { {:base_path => 'spec/fixtures/**/', :origin => 'english', :alternates => ['norsk', 'francais']} }

  let(:combined) do
    {
      "spec/fixtures/" => {
        "food" => {
          "breakfast" => {"english" => "yoghurt", "norsk" => nil, "francais" => nil},
          "lunch" => {"english" => "sandwich", "norsk" => "smørbrød", "francais" => nil},
          "dinner" => {
            "main_course" => {"english" => "steak", "norsk" => nil, "francais" => nil},
            "side" => {"english" => "baked potato", "norsk" => nil, "francais" => nil},
            "desert" => {"english" => "chocolate mousse", "norsk" => nil, "francais" => nil}
          }
        }
      },
      "spec/fixtures/lang/" => {
        "volume" => {
          "sound" => {"english" => "loud", "norsk" => nil, "francais" => nil},
          "liquid" => {"english" => "sloshing", "norsk" => nil, "francais" => nil},
          "hair" => {"english" => "because I'm worth it", "norsk" => nil, "francais" => nil}
        }
      }
    }
  end

  it "loads and munges" do
    Langulator.munge(options).should eq(combined)
  end
end
