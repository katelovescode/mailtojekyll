require 'mail'

class EmailParser

  def self.parse(email)
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

end
