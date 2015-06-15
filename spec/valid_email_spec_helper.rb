#!/usr/bin/env ruby

require 'shared_contexts'

shared_examples 'a valid email' do
  include_context 'all emails'
  include_context 'all valid emails'
  describe '#validate_subject' do
    it 'does not raise a subject error' do
      expect{ @thismail.validate_subject }.not_to raise_error
    end
  end
  describe '#validate_secret' do
    it 'does not raise a secret error' do
      expect{ @thismail.validate_secret }.not_to raise_error
    end
  end
  describe '#validate_body' do
    it 'does not raise a no body error' do
      expect{ @thismail.validate_body }.not_to raise_error
    end
  end
end