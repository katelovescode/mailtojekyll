require 'mail'

class EmailParser

  def self.read(email)
    unless email.nil? || email.empty?

      @keyvals = {}

      email = Mail.read(email)
      @subject = email.subject
      (@title, metadata) = @subject.split(/\|\|/)
      @title.strip!

      unless metadata.nil?
        meta = metadata.split('/')
        meta.each do |m|
          (key, val) = m.split(/:\s?/)
          key.strip!
          val.strip!
          @keyvals[key.to_sym] = val
        end
      end

      raise StandardError unless @keyvals[:secret] == "jekyllmail"

    end

  end

end
