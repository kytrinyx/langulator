shared_examples_for "a translation" do
  it { subject.should respond_to(:filename) }
  it { subject.should respond_to(:location) }
  it { subject.should respond_to(:path) }
  it { subject.should respond_to(:translations) }
  it { subject.should respond_to(:write) }
end
