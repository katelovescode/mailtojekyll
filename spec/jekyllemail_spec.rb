require 'jekyllemail'

describe JekyllEmail do

  context 'given a message sent from Gmail' do

    context 'given an empty subject' do
      let(:email) { "spec/mocks/gmail-no-subject.eml" }
      it 'raises an error' do
        expect{ JekyllEmail.new(email).p_sub }.to raise_error
      end
    end
    
    context 'given the wrong secret' do
      let(:email) { "spec/mocks/gmail-wrong-secret.eml" }
      it 'raises an error' do
        expect { JekyllEmail.new(email).p_sec }.to raise_error
      end
    end

  end
  
end