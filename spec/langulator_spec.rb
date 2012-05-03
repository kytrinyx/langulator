# encoding: utf-8
require 'langulator'

describe Langulator do
  let(:options) { {:base_path => 'spec/fixtures/**/', :origin => 'english', :alternates => ['norsk', 'francais']} }

  let(:aggregate_incomplete) do
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
    Langulator.munge(options).should eq(aggregate_incomplete)
  end

  let(:aggregate_complete) do
    {
      "spec/fixtures/" => {
        "food" => {
          "breakfast" => {"english" => "yoghurt", "norsk" => "joggurt", "francais" => "yaourt"},
          "lunch" => {"english" => "sandwich", "norsk" => "smørbrød", "francais" => "sandwich"},
          "dinner" => {
            "main_course" => {"english" => "steak", "norsk" => "steak", "francais" => "biffteak"},
            "side" => {"english" => "baked potato", "norsk" => "bakt potet", "francais" => "pomme de terre au four"},
            "desert" => {"english" => "chocolate mousse", "norsk" => "sjokolademousse", "francais" => "mousse au chocolat"}
          }
        }
      },
      "spec/fixtures/lang/" => {
        "volume" => {
          "sound" => {"english" => "loud", "norsk" => "høyt", "francais" => "fort"},
          "liquid" => {"english" => "sloshing", "norsk" => "skvulper", "francais" => "agité"},
          "hair" => {"english" => "because I'm worth it", "norsk" => "for det er jeg verdt", "francais" => "parce que je le vaux bien"}
        }
      }
    }
  end

  it "untangles" do
    expected = {
      "english" => {
        "spec/fixtures/" => {
          "food" => {"breakfast" => "yoghurt", "lunch" => "sandwich", "dinner" => {"main_course" => "steak", "side" => "baked potato", "desert" => "chocolate mousse"}}
        },
        "spec/fixtures/lang/" => {
          "volume" => {"sound" => "loud", "liquid" => "sloshing", "hair" => "because I'm worth it"}
        }
      },
      "norsk" => {
        "spec/fixtures/" => {
          "food" => {"breakfast" => "joggurt", "lunch" => "smørbrød", "dinner" => {"main_course" => "steak", "side" => "bakt potet", "desert" => "sjokolademousse"}}
        },
        "spec/fixtures/lang/" => {
          "volume" => {"sound" => "høyt", "liquid" => "skvulper", "hair" => "for det er jeg verdt"}
        }
      },
      "francais" => {
        "spec/fixtures/" => {
          "food" => {"breakfast" => "yaourt", "lunch" => "sandwich", "dinner" => {"main_course" => "biffteak", "side" => "pomme de terre au four", "desert" => "mousse au chocolat"}}
        },
        "spec/fixtures/lang/" => {
          "volume" => {"sound" => "fort", "liquid" => "agité", "hair" => "parce que je le vaux bien"}
        }
      }
    }
    Langulator.untangle(aggregate_complete, :languages => ["english", "norsk", "francais"]).should eq(expected)
  end

end
