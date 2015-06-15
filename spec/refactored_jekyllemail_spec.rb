#!/usr/bin/env ruby

require 'jekyllemail'
require 'invalid_email_spec_helper'
require 'valid_email_spec_helper'
require 'shared_contexts'

describe JekyllEmail do
  include_context 'all emails'
  let(:sourcepath) { 'spec/mocks/' }
  
  context 'given an email sent from gmail' do
    let(:device) { 'gmail_desktop/' }
    let(:identification) { 'from Gmail Desktop' }
  
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
      it_behaves_like 'a valid email'
    end
    
  end
end