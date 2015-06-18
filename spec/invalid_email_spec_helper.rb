#!/usr/bin/env ruby

require 'shared_contexts'

shared_examples 'a bad subject' do
  include_context 'all emails'
  describe '#validate_subject' do
    it 'raises a subject error' do
      expect{ @thismail.validate_subject }.to raise_error("#{no_subject_error}")
    end
  end
  describe '#validate_secret' do
    it 'raises a secret error' do
      expect{ @thismail.validate_secret }.to raise_error("#{no_secret_error}")
    end
  end
  describe '#validate_body' do
    it 'does not raise a body error' do
      expect{ @thismail.validate_body }.not_to raise_error
    end
  end
end

shared_examples 'a bad secret' do
  include_context 'all emails'
  describe '#validate_subject' do
    it 'does not raise a subject error' do
      expect{ @thismail.validate_subject }.not_to raise_error
    end
  end
  describe '#validate_secret' do
    it 'raises a secret error' do
      expect{ @thismail.validate_secret }.to raise_error("#{no_secret_error}")
    end
  end
  describe '#validate_body' do
    it 'does not raise a body error' do
      expect{ @thismail.validate_body }.not_to raise_error
    end
  end
end

shared_examples 'an empty email' do
  include_context 'all emails'
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
    it 'raises a body error' do
      expect{ @thismail.validate_body }.to raise_error("#{no_body_error}")
    end
  end
  describe '.body' do
    subject { @thismail.body }
    it { is_expected.to eq("") }
  end
end