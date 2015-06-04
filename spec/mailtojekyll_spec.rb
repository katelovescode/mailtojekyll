require "mailtojekyll"

describe 'mailtojekyll' do

  describe 'parse' do

    # TODO: this may not be necessary.  We can put the logic in to not run parse if the emails list is empty
    # context 'given no emails' do
    #   it 'raises an error' do
    #     expect(parse("")).to raise_error
    #   end
    # end

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

        context 'sent with inline images' do
          before(:each) do
            parse('spec/mocks/gmail-inline-images-only.eml')
          end
          it 'formats the body stripping all tags except image tags and br tags' do
            expect(instance_variable_get(:@body)).to eq('Here are some inline images.<br><br>On its own line:<br><img src="cid:ii_i9bo30jv0_14d256658f97bbac" height="534" width="361"><br><br>On the same line:<img src="cid:ii_i9bo6dkp1_14d2568bcb70655a" height="128" width="128"><br>​<br><br>')
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
