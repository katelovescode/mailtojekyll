require 'jekyllemail'

describe JekyllEmail do

  # to reuse: change context title
  context 'given a message sent from Gmail app on Android' do
    # to reuse: change program path
    let(:prog) { "droidgmail/" }
    
    let(:mocks) { "spec/mocks/" }
    let(:path) { mocks + prog }
    let(:jmail) { JekyllEmail.new(email) }
    let(:jmail2) { JekyllEmail.new(email2) }

    context 'with an empty subject' do
      let(:email) { path + "no-subject.eml" }
      let(:error) { "No subject" }
      it 'raises an error' do
        expect{ jmail.v_sub }.to raise_error(error)
      end
    end
    
    context 'with the wrong secret' do
      let(:email) { path + "wrong-secret.eml" }
      let(:error) { "Secret incorrect" }
      it 'raises an error' do
        expect { jmail.v_sec }.to raise_error(error)
      end
    end
    
    context 'with no secret' do
      let(:email) { path + "no-secret.eml" }
      let(:email2) { path + "no-subject.eml" }
      let(:error) { "Secret incorrect" }
      it 'raises an error' do
        expect { jmail.v_sec }.to raise_error(error)
        expect { jmail2.v_sec }.to raise_error(error)
      end
    end
    
    context 'with no body' do
      let(:email) { path + "empty.eml"}
      let(:error) { "No body text" }
      it 'raises an error' do
        expect { jmail.v_bod }.to raise_error(error)
        expect( jmail.body ).to eq("")
      end
    end
    
    context 'with attached & inline images' do
      #to reuse: change email title variable
      let(:title) { "Attached & Inline images from Android Gmail app" }
      
      let(:fn) { 'attached-inline' }
      let(:email) { path + fn + ".eml" }
      it 'does not raise an error on subject, secret, or body' do
        expect { jmail.v_sub }.not_to raise_error
        expect { jmail.v_sec }.not_to raise_error
        expect { jmail.v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( jmail.v_sub ).to eq(title)
      end
    end
    
    context 'with attached images & text' do
      #to reuse: change email title variable
      let(:title) { "Attached images with text from Android Gmail app" }
      
      let(:fn) { 'attached-text' }
      let(:email) { path + fn + ".eml" }
      it 'does not raise an error on subject, secret, or body' do
        expect { jmail.v_sub }.not_to raise_error
        expect { jmail.v_sec }.not_to raise_error
        expect { jmail.v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( jmail.v_sub ).to eq(title)
      end
    end
    
    context 'with attached images & no text' do
      #to reuse: change email title variable
      let(:title) { "Attached images no text" }
      
      let(:fn) { 'attached-no-text' }
      let(:email) { path + fn + ".eml" }
      it 'does not raise an error on subject, secret, or body' do
        expect { jmail.v_sub }.not_to raise_error
        expect { jmail.v_sec }.not_to raise_error
        expect { jmail.v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( jmail.v_sub ).to eq(title)
      end
    end
    
    context 'with inline images only' do
      #to reuse: change email title variable
      let(:title) { "Inline only from Android Gmail app" }
      
      let(:fn) { 'inline' }
      let(:email) { path + fn + ".eml" }
      it 'does not raise an error on subject, secret, or body' do
        expect { jmail.v_sub }.not_to raise_error
        expect { jmail.v_sec }.not_to raise_error
        expect { jmail.v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( jmail.v_sub ).to eq(title)
      end
    end
    
    context 'with emoji' do
      #to reuse: change email title variable
      let(:title) { "Emoji from Android Gmail app" }
      
      let(:fn) { 'emoji' }
      let(:email) { path + fn + ".eml" }
      it 'does not raise an error on subject, secret, or body' do
        expect { jmail.v_sub }.not_to raise_error
        expect { jmail.v_sec }.not_to raise_error
        expect { jmail.v_bod }.not_to raise_error
      end
      it 'creates the correct title' do
        expect( jmail.v_sub ).to eq(title)
      end
    end

  end
  
end