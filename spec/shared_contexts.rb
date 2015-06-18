#!/usr/bin/env ruby

shared_context 'all emails' do
  let(:sourcepath) { 'spec/mocks/' }
  let(:mdpath) { 'spec/mocks/markdown/'}
  let(:email) { sourcepath + device + filename + '.eml' }
  let(:markdown) { mdpath + filename + '.md' }
  let(:no_subject_error) { "No subject" }
  let(:no_secret_error) { "Secret incorrect or missing" }
  let(:no_body_error) { "No body text" }
  before(:each) do
    @thismail = JekyllEmail.new(email)
  end
end

shared_context 'all posts' do
  before(:each) do
    @thispost = JekyllPost.new(@thismail.title, @thismail.body, @thismail.atts, '/tmp/jekyllblog', 'images', 'latest/_posts', { layout: 'post', categories: 'latest' })
  end
end