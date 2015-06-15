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
    it 'does not raise a body error' do
      expect{ @thismail.validate_body }.not_to raise_error
    end
  end
  describe '.title' do
    subject { @thismail.title }
    it { is_expected.to eq(thistitle) }
  end
  describe '.body' do
    subject { @thismail.body }
    it { is_expected.not_to eq("") }
  end
end

shared_examples 'an email with attachments' do
  include_context 'all emails'
  include_context 'all valid emails'  
  describe '.atts' do
    subject { @thismail.atts.length }
    it { is_expected.to be > 0 }
  end
end

shared_examples 'an email with no attachments' do
  include_context 'all emails'
  include_context 'all valid emails'
  describe '.atts' do
    subject { @thismail.atts.length }
    it { is_expected.to eq(0) }
  end
end