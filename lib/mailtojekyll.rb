require 'mail'

# use or mixin the emailparser module? or include the emailparser code here
# loop through emails to create multiple Post objects (based on Post Class)
# each Post instantiates multiple Image objects (based on Image Class)

# Post has: Title, Date, Body, Images, Markdown file (save location)
# Image has: Alt text (maybe), file (save location)





# KATE'S LIST
# convert emailparser to mailtojekyll.rb (that's the actual program, it's the action)
# class for images, class for posts
# use "let" for rspec testing variables, like in rbemail
# body tests - check to make sure it exists, and check to make sure it is *exactly* what I want it to be (copy-paste the body of the email and format to final result, then code to make it pass)
# what order do the images come in?
# strip all html tags *except* img? Keep CID logic from JekyllMail?


def parse(email)
  unless email.nil? || email.empty?

    email = Mail.read(email)

    # parse the subject to create the title
    @subject = email.subject
    (@title, secret) = @subject.split(/\|\|/)
    @title.strip!

    raise StandardError, "No subject" if @subject.nil? || @subject.empty?

    # parse the metadata to check for the secret and create additional key/value pairs
    unless secret.nil?
      (key, @secret) = secret.split(/:\s?/)
      @secret.strip!
    end

    raise StandardError, "Secret incorrect" unless @secret == "jekyllmail"

  end

end
