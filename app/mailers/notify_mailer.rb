class NotifyMailer < GovukNotifyRails::Mailer
  def api_key_confirmation(user)
    set_template('c8709881-610f-4618-8f8a-b3760721406a')

    set_personalisation(
      api_key: user.api_key
    )

    mail(to: user.email)
  end

  def new_api_key_request(user)
    set_template('926a72b2-1332-4e88-a322-adee7c522203')

    set_personalisation(
      email: user.email,
      api_key: user.api_key,
      department: user.department,
      service: user.service
    )

    mail(to: 'registerteam@digital.cabinet-office.gov.uk')
  end
end
