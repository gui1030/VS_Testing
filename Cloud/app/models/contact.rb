class Contact < MailForm::Base
  attribute :name,  validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject, validate: true
  attribute :message, validate: true
  attribute :file, attachment: true

  def headers
    {
      subject: subject,
      to: 'support@verisolutions.co',
      reply_to: %("#{name}" <#{email}>),
      from: %("Verisolutions Support" <donotreply@verisolutions.co>)
    }
  end
end
