#!/usr/bin/env ruby

require 'blogsetup'
require 'jekyllemail'
require 'jekyllpost'
require 'invalid_email_spec_helper'
require 'valid_email_spec_helper'
require 'shared_contexts'

# TODO: [:atts, :body, :markdown, :blanktest] 
# TODO: All client sources (not just gmail)

include BlogSetup
create_dirs('/tmp/jekyllblog/images','/tmp/jekyllblog/latest/_posts')

describe JekyllEmail do
  let(:sourcepath) { 'spec/mocks/' }
  
  context 'given an email sent from iOS Mail' do
    
    let(:device) { 'ios_mail/' }
    let(:identification) { ' from iOS Mail' }
   
    context 'with no subject' do
      let(:filename) {'no-subject.eml'}
      it_behaves_like 'a bad subject'
    end
    
    context 'with no secret' do
      let(:filename) {'no-secret.eml'}
      it_behaves_like 'a bad secret'
    end
    
    context 'with the wrong secret' do
      let(:filename) {'wrong-secret.eml'}
      it_behaves_like 'a bad secret'
    end
    
    context 'with no body text' do
      let(:filename) {'empty.eml'}
      it_behaves_like 'an empty email'
    end
    
    context 'as plain text' do
      let(:filename) {'plain-text.eml'}
      let(:thistitle) {'Plain text' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with no attachments'
    end
    
    context 'with attached and inline images' do
      let(:filename) {'attached-inline.eml'}
      let(:thistitle) {'Attached inline' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end

    context 'with attached images and text' do
      let(:filename) {'attached-text.eml'}
      let(:thistitle) {'Attached with text' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
    
    context 'with attached images and no text' do
      let(:filename) {'attached-no-text.eml'}
      let(:thistitle) {'Attached with no text' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
    
    context 'with inline images' do
      let(:filename) {'inline.eml'}
      let(:thistitle) {'Inline' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
    
    context 'as html with formatting' do
      let(:filename) {'html-format.eml'}
      let(:thistitle) {'HTML with formatting' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with no attachments'
    end
    
    context 'as html with no formatting' do
      let(:filename) {'html-no-format.eml'}
      let(:thistitle) {'HTML with no formatting' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with no attachments'
    end
    
    context 'with emoji' do
      let(:filename) {'emoji.eml'}
      let(:thistitle) {'Emoji' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
    
    context 'with bold-italic-underline formatting' do
      let(:filename) {'bold-italic-underline.eml'}
      let(:thistitle) {'Bold italic underline' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with no attachments'
      
    end
    
    context 'with links' do
      let(:filename) {'links.eml'}
      let(:thistitle) {'Links' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with no attachments'
    end
    
    context 'with the image tag method and attached images' do
      let(:filename) {'peter-method-attached.eml'}
      let(:thistitle) {'Peter\'s method attached' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
    
    context 'with the image tag method and copy-pasted images' do
      let(:filename) {'peter-method-copy-paste.eml'}
      let(:thistitle) {'Peter\'s method copy-paste' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
    
    context 'with the image tag method and inline images' do
      let(:filename) {'peter-method-inline.eml'}
      let(:thistitle) {'Peter\'s method inline' + identification }
      it_behaves_like 'a valid email'
      it_behaves_like 'an email with attachments'
    end
  end
end