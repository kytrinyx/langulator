# encoding: utf-8
require 'langulator/aggregate'

describe Langulator::Aggregate do
  let(:aggregate) do
    {
      :game => {
        :rock => {
          :english => "rock",
          :french => "pierre",
        },
        :paper => {
          :english => "paper",
          :french => "papier"
        },
        :scissors => {
          :english => "scissors",
          :french => "ciseau"
        },
        :other => {
          :deeply => {
            :english => "nested",
            :french => "imbriqué"
          }
        }
      }
    }
  end

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

  let(:french) do
    {
      :game => {
        :rock => "pierre",
        :paper => "papier",
        :scissors => "ciseau",
        :other => {:deeply => "imbriqué"}
      }
    }
  end

  context "with aggregated data" do
    subject { Langulator::Aggregate.new(aggregate, :languages => [:english, :french]) }

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

    it "filters out the english" do
      subject.separate[:english].should eq(english)
    end

    it "filters out the french" do
      subject.separate[:french].should eq(french)
    end
  end
end