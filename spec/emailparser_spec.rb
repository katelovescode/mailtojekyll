require "emailparser"

describe 'EmailParser' do

  # reading emails
  describe '.parse' do

    context 'given no emails' do
      it 'returns nil' do
        expect(EmailParser.parse("")).to be_nil
      end
    end

    context 'given a single email' do

      context 'from gmail sent as plain text' do
        before(:each) do
          EmailParser.parse('spec/mocks/gmail-plain-text.eml')
        end
        it 'parses the subject correctly' do
          expect(EmailParser.instance_variable_get(:@subject)).to eq("Plain Text from Gmail || secret: jekyllmail")
          expect(EmailParser.instance_variable_get(:@title)).to eq("Plain Text from Gmail")
          expect(EmailParser.instance_variable_get(:@keyvals)).to include(:secret => "jekyllmail")
        end
      end

      context 'from gmail sent with html format' do
        before(:each) do
          EmailParser.parse('spec/mocks/gmail-html-format.eml')
        end
        it 'parses the subject correctly' do
          expect(EmailParser.instance_variable_get(:@subject)).to eq("HTML formatting from Gmail || secret: jekyllmail")
          expect(EmailParser.instance_variable_get(:@title)).to eq("HTML formatting from Gmail")
          expect(EmailParser.instance_variable_get(:@keyvals)).to include(:secret => "jekyllmail")
        end
      end

      context 'from gmail with wrong secret' do
        # before(:each) do
        #   EmailParser.read('spec/mocks/gmail-wrong-secret.eml')
        # end
        it 'exits the method with an error' do
          expect{ EmailParser.parse('spec/mocks/gmail-wrong-secret.eml') }.to raise_error
          expect(EmailParser.instance_variable_get(:@keyvals)).not_to include(:secret => "jekyllmail")
        end
      end

    end

  end

end
