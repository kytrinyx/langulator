require 'langulator/munger'

describe Langulator::Munger do

  let(:english) do
    {
      :game => {
        :rock => "rock",
        :paper => "paper",
        :scissors => "scissors",
        :other => {:deeply => "nested"}
      }
    }
  end

  let(:english_remapped) do
    {
      :game => {
        :rock => {:english => "rock"},
        :paper => {:english => "paper"},
        :scissors => {:english => "scissors"},
        :other => {
          :deeply => {:english => "nested"}
        }
      }
    }
  end

  let(:french) { {:game => {:paper => 'papier', :other => {:not => 'included'}}} }

  let(:combined) do
    {
      :game => {
        :rock => {
          :english => "rock",
          :french => nil
        },
        :paper => {
          :english => "paper",
          :french => "papier"
        },
        :scissors => {
          :english => "scissors",
          :french => nil
        },
        :other => {
          :deeply => {
            :english => "nested",
            :french => nil
          }
        }
      }
    }
  end

  context "partial munges" do
    subject { Langulator::Munger.new }

    it "remaps a source dictionary" do
       subject.transform(:english, english).should eq(english_remapped)
    end

    it "inserts an alternate language" do
      subject.insert(:french, french, english_remapped).should eq(combined)
    end
  end

  it "munges" do
    munger = Langulator::Munger.new(:language => :english, :translations => english, :alternates => {:french => french})
    munger.munge.should eq(combined)
  end

end
