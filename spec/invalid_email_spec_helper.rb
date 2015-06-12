#!/usr/bin/env ruby

shared_examples 'a bad subject' do
  
    let{:thismail} ( sourcepath + device + filename)
    before(:each) do
      mail = JekyllEmail.new(thismail)
    end
    describe '#validate_subject' do
      it { is_expected.to raise_error(no_subject_error) }
    end
    describe '#validate_secret' do
      it { is_expected.to raise_error(no_secret_error) }
    end
    describe '#validate_body' do
      it { is_expected.no_to raise_error(no_body_error) }
    end
  end
  
  
  
  let(:acceleratable) { described_class.new }

  describe 'speed' do
    it 'is initially zero' do
      acceleratable.speed.should == 0
    end
  end
end