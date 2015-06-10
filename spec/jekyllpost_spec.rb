require 'jekyllemail'
require 'jekyllpost'

describe JekyllPost do

  # to reuse: change context title
  context 'given a message sent from Gmail' do
    # to reuse: change program path
    let(:mailpath) { "spec/mocks/gmail/" }
    let(:jpost) { JekyllPost.new(title,body,atts) }

    context 'with attached & inline images' do
      let(:fn) { 'attached-inline' }
      let(:email) { mailpath + fn + ".eml" }
      let(:title) { "Attached & Inline images from Gmail" }
      let(:body) { (<<-EOT)
Here's an inline BSG patch  
  
 ![](bsg_patch.png)  
  

And an inline Hermione ![](index.jpeg)  
​  
  

And next is Lord of the Rings as an attachment  
  

And also a huge pacific rim image  
  

What happens if your inline is too big?  
 ![](firefly-serenity-crew.jpg)  
​  

​  

![](Ringstrilogyposter.jpg)

![](background_45938.jpg)
EOT
}
      let(:atts) { {"bsg_patch.png"=>"ii_i9botsj60_14d257969cc30960", "index.jpeg"=>"ii_i9bou8pm1_14d2579bbaf84714", "firefly-serenity-crew.jpg"=>"ii_i9bowzlm4_14d257baee13b432", "Ringstrilogyposter.jpg"=>"", "background_45938.jpg"=>""} }
      let(:timepath) { "/" + Time.now.year.to_s + "/" + Time.now.month.to_s.rjust(2,'0') + "/" + Time.now.day.to_s.rjust(2,'0') + "/" }
      
      
      it 'should make the correct slug' do
        jpost.make_slug
        expect( jpost.path ).to eq(timepath + "attached-inline-images-from-gmail.md")
      end
      
      it 'should replace image filenames' do
        jpost.replace_images
        expect( jpost.post ).to include("firefly-serenity-crew.jpg")
      end

    end
    
  end
  
end