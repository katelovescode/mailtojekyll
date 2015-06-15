#!/usr/bin/env ruby

require 'blogsetup'
require 'jekyllemail'
require 'jekyllpost'
require 'invalid_email_spec_helper'
require 'valid_email_spec_helper'
require 'shared_contexts'

include BlogSetup
create_dirs('/tmp/jekyllblog/images','/tmp/jekyllblog/latest/_posts')

describe JekyllEmail do
  include_context 'all emails'
  let(:sourcepath) { 'spec/mocks/' }
  
  context 'given an email sent from gmail' do
    let(:device) { 'gmail_desktop/' }
    let(:identification) { 'from Gmail Desktop' }
  
    context 'that is invalid' do
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
    end
    
    context 'that is valid' do
      include_context 'all valid emails'
      context 'as plain text' do
        let(:filename) {'plain-text.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with attached and inline images' do
        let(:filename) {'attached-inline.eml'}
        it_behaves_like 'a valid email'
      end

      context 'with attached images and text' do
        let(:filename) {'attached-text.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with attached images and no text' do
        let(:filename) {'attached-no-text.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with inline images' do
        let(:filename) {'inline.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'as html with formatting' do
        let(:filename) {'html-format.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'as html with no formatting' do
        let(:filename) {'html-no-format.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with emoji' do
        let(:filename) {'emoji.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with bold-italic-underline formatting' do
        let(:filename) {'bold-italic-underline.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with links' do
        let(:filename) {'links.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with the image tag method and attached images' do
        let(:filename) {'peter-method-attached.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with the image tag method and copy-pasted images' do
        let(:filename) {'peter-method-copy-paste.eml'}
        it_behaves_like 'a valid email'
      end
      
      context 'with the image tag method and inline images' do
        let(:filename) {'peter-method-inline.eml'}
        it_behaves_like 'a valid email'
      end
    end
  end
end