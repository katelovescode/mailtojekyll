require "mailtojekyll"

describe 'mailtojekyll' do

  describe 'parse' do

    context 'given no emails' do
      it 'returns nil' do
        expect(parse("")).to be_nil
      end
    end

    context 'given a single email' do

      context 'from gmail' do

        context 'sent as plain text' do
          before(:each) do
            parse('spec/mocks/gmail-plain-text.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq("Plain Text from Gmail || secret: jekyllmail")
            expect(instance_variable_get(:@title)).to eq("Plain Text from Gmail")
            expect(instance_variable_get(:@secret)).to eq("jekyllmail")
          end
        end

        context 'sent as html' do
          before(:each) do
            parse('spec/mocks/gmail-html-format.eml')
          end
          it 'parses the subject correctly' do
            expect(instance_variable_get(:@subject)).to eq("HTML formatting from Gmail || secret: jekyllmail")
            expect(instance_variable_get(:@title)).to eq("HTML formatting from Gmail")
            expect(instance_variable_get(:@secret)).to eq("jekyllmail")
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
          end
        end

      end # end of gmail context

    end # end of single email context

  end

end
