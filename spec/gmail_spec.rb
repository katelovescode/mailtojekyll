require 'jekyllemail'

describe JekyllEmail do

  context 'given a message sent from Gmail' do
    let(:path) { "spec/mocks/gmail/" }

    context 'given an empty subject' do
      let(:email) { path + "no-subject.eml" }
      it 'raises an error' do
        expect{ JekyllEmail.new(email).p_sub }.to raise_error("No subject")
      end
    end
    
    context 'given the wrong secret' do
      let(:email) { path + "wrong-secret.eml" }
      it 'raises an error' do
        expect { JekyllEmail.new(email).p_sec }.to raise_error("Secret incorrect")
      end
    end
    
    context 'given no secret' do
      let(:email) { path + "no-secret.eml" }
      let(:email2) { path + "no-subject.eml" }
      it 'raises an error' do
        expect { JekyllEmail.new(email).p_sec }.to raise_error("Secret incorrect")
        expect { JekyllEmail.new(email2).p_sec }.to raise_error("Secret incorrect")
      end
    end
    
    context 'given no body' do
      let(:email) { path + "empty.eml"}
      it 'raises an error' do
        expect { JekyllEmail.new(email).p_bod }.to raise_error("No body text")
      end
    end

  end
  
end