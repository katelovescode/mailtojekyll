# require 'jekyllemail'
# 
# describe JekyllEmail do
#   let(:sourcepath) { 'spec/mocks/' }
#   
#   context 'given an email sent from gmail with' do
#     let(:device) { 'gmail/' }
#   
#     context 'no subject' do
#       let{:thismail} ( sourcepath + device + 'no-subject.eml')
#       before(:each) do
#         mail = JekyllEmail.new(thismail)
#       end
#       describe '#validate_subject' do
#         it { is_expected.to raise_error(no_subject_error) }
#       end
#       describe '#validate_secret' do
#         it { is_expected.to raise_error(no_secret_error) }
#       end
#       describe '#validate_body' do
#         it { is_expected.no_to raise_error(no_body_error) }
#       end
#     end
#     
#   end
# end