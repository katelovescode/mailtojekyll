require 'jekyllemail'

describe JekyllEmail do

  context 'given a message sent from Android (5.0.2) LG Mail app' do
    let(:path) { "spec/mocks/lgmail/" }

    context 'with an empty subject' do
      let(:email) { path + "no-subject.eml" }
      it 'raises an error' do
        expect{ JekyllEmail.new(email).v_sub }.to raise_error("No subject")
      end
    end
    
    context 'with the wrong secret' do
      let(:email) { path + "wrong-secret.eml" }
      it 'raises an error' do
        expect { JekyllEmail.new(email).v_sec }.to raise_error("Secret incorrect")
      end
    end
    
    context 'with no secret' do
      let(:email) { path + "no-secret.eml" }
      let(:email2) { path + "no-subject.eml" }
      it 'raises an error' do
        expect { JekyllEmail.new(email).v_sec }.to raise_error("Secret incorrect")
        expect { JekyllEmail.new(email2).v_sec }.to raise_error("Secret incorrect")
      end
    end
    
    context 'with no body' do
      let(:email) { path + "empty.eml"}
      it 'raises an error' do
        expect { JekyllEmail.new(email).v_bod }.to raise_error("No body text")
      end
    end
    
    context 'with attached & inline images' do
      let(:email) { path + "attached-inline.eml" }
      let(:title) { "Attached and inline images with text" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with attached images & text' do
      let(:email) { path + "attached-text.eml" }
      let(:title) { "Attached with text Android mail app" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with attached images & no text' do
      let(:email) { path + "attached-no-text.eml" }
      let(:title) { "Attached images no text android mail app" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with inline images only' do
      let(:email) { path + "inline.eml" }
      let(:title) { "Inline only Android mail" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with emoji' do
      let(:email) { path + "emoji.eml" }
      let(:title) { "Emoji Android mail" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with html formatted text' do
      let(:email) { path + "html-format.eml" }
      let(:title) { "Html format Android mail" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with html text with no special formatting' do
      let(:email) { path + "html-no-format.eml" }
      let(:title) { "Regular HTML Android mail" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end
    
    context 'with plain text' do
      let(:email) { path + "plain-text.eml" }
      let(:title) { "Plain text maybe? Android mail" }
      it 'does not raise an error on subject, secret, or body' do
        expect { JekyllEmail.new(email).v_sub }.not_to raise_error
        expect { JekyllEmail.new(email).v_sec }.not_to raise_error
        expect { JekyllEmail.new(email).v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( JekyllEmail.new(email).v_sub ).to eq(title)
      end
    end

  end
  
end