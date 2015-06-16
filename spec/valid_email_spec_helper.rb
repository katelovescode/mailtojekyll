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
    subject { @thismail }
    it 'sets the title correctly' do
      expect(subject.title).to eq(thistitle)
    end
  end
  describe '.body' do
    subject { @thismail }
    it 'has a body' do
      expect(subject.body).not_to eq("")
      expect(subject.body).not_to be_nil
    end
  end
end

shared_examples 'an email with attachments' do
  include_context 'all emails'
  describe '.atts' do
    subject { @thismail }
    it 'has attachments' do
      expect(subject.atts).not_to be_empty, "expected attachments, got #{subject.inspect}"
    end
  end
end

shared_examples 'an email with no attachments' do
  include_context 'all emails'
  describe '.atts' do
    subject { @thismail }
    it 'has attachments' do
      expect(subject.atts).to be_empty
    end
  end
end