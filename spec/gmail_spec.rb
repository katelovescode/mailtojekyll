require "mailtojekyll"

describe 'mailtojekyll' do

  describe 'parse' do

    context 'given a single email' do

      context 'from gmail' do

        context 'sent as plain text' do
          let(:subject) { "Plain Text from Gmail || secret: jekyllmail" }
          let(:title) { "Plain Text from Gmail" }
          let(:secret) { "jekyllmail" }
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-plain-text.md").to_s }
          before(:each) do
            parse('spec/mocks/gmail-plain-text.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq(subject)
            expect(instance_variable_get(:@title)).to eq(title)
            expect(instance_variable_get(:@secret)).to eq(secret)
          end
          it 'outputs the body to markdown' do
            expect(instance_variable_get(:@body).to_s).to eq(bodytext)
          end
        end

        context 'sent as html' do
          let(:subject) { "HTML formatting from Gmail || secret: jekyllmail" }
          let(:title) { "HTML formatting from Gmail" }
          let(:secret) { "jekyllmail" }
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-html-format.md").to_s }
          before(:each) do
            parse('spec/mocks/gmail-html-format.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq(subject)
            expect(instance_variable_get(:@title)).to eq(title)
            expect(instance_variable_get(:@secret)).to eq(secret)
          end
          it 'outputs the body to markdown' do
            expect(instance_variable_get(:@body).to_s).to eq(bodytext)
          end
        end
        
        context 'sent as default: html with no special formatting' do
          let(:subject) { "HTML no formatting from Gmail || secret: jekyllmail" }
          let(:title) { "HTML no formatting from Gmail" }
          let(:secret) { "jekyllmail" }
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-html-no-format.md").to_s }
          before(:each) do
            parse('spec/mocks/gmail-html-no-format.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq(subject)
            expect(instance_variable_get(:@title)).to eq(title)
            expect(instance_variable_get(:@secret)).to eq(secret)
          end
          it 'outputs the body to markdown' do
            expect(instance_variable_get(:@body).to_s).to eq(bodytext)
          end
        end

        context 'sent with inline images' do
          let(:subject) { "Inline Images only from Gmail || secret: jekyllmail" }
          let(:title) { "Inline Images only from Gmail" }
          let(:secret) { "jekyllmail" }
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-inline-images-only.md").to_s }
          before(:each) do
            parse('spec/mocks/gmail-inline-images-only.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq(subject)
            expect(instance_variable_get(:@title)).to eq(title)
            expect(instance_variable_get(:@secret)).to eq(secret)
          end
          it 'outputs the body to markdown' do
            expect(instance_variable_get(:@body).to_s).to eq(bodytext)
          end
        end
        
        context 'sent with only attached images and no text' do
          let(:subject) { "Attached image no text only from Gmail || secret: jekyllmail" }
          let(:title) { "Attached image no text only from Gmail" }
          let(:secret) { "jekyllmail" }
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-attached-image-only.md").to_s }
          before(:each) do
            parse('spec/mocks/gmail-attached-image-only.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq(subject)
            expect(instance_variable_get(:@title)).to eq(title)
            expect(instance_variable_get(:@secret)).to eq(secret)
          end
          it 'outputs the body to markdown' do
            expect(instance_variable_get(:@body).to_s).to eq(bodytext)
          end
        end
        
        context 'sent with attached images with text' do
          let(:subject) { "Attached image with text from Gmail || secret: jekyllmail" }
          let(:title) { "Attached image with text from Gmail" }
          let(:secret) { "jekyllmail" }
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-attached-images-text.md").to_s }
          before(:each) do
            parse('spec/mocks/gmail-attached-images-text.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq(subject)
            expect(instance_variable_get(:@title)).to eq(title)
            expect(instance_variable_get(:@secret)).to eq(secret)
          end
          it 'outputs the body to markdown' do
            expect(instance_variable_get(:@body).to_s).to eq(bodytext)
          end
        end
        
        context 'with no body' do
          let(:bodytext) { bodytext = IO.binread("spec/mocks/gmail-empty.md").to_s }
          it 'outputs the body to markdown' do
            expect(email.instance_variable_get(:@body)).to eq(bodytext)
          end
          it 'exits the method with an error' do
            expect{ parse('spec/mocks/gmail-empty.eml') }.to raise_error
          end
        end

        context 'with incorrect secret' do
          it 'exits the method with an error' do
            expect{ parse('spec/mocks/gmail-wrong-secret.eml') }.to raise_error
            expect(instance_variable_get(:@secret)).not_to eq("jekyllmail")
          end
        end

        context 'with no secret' do
          it 'exits the method with an error' do
            expect{ parse('spec/mocks/gmail-no-secret.eml') }.to raise_error
            expect(instance_variable_get(:@secret)).not_to eq("jekyllmail")
          end
        end

        context 'with no subject' do
          it 'exits the method with an error' do
            expect{ parse('spec/mocks/gmail-no-subject.eml') }.to raise_error
            expect(instance_variable_get(:@subject)).to be_nil
            expect(instance_variable_get(:@secret)).not_to eq("jekyllmail")
          end
        end

      end # end of gmail context

    end # end of single email context

  end

end
