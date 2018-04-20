class UserMailer < GovukNotifyRails::Mailer
  def forgot_password(user)
    set_template(ENV['FORGOTTEN_PASSWORD_TEMPLATE_ID'])

    @user = user

    set_personalisation(
      user_full_name: @user.email,
      edit_password_url: edit_admin_password_reset_url(@user.password_reset_token)
    )

    mail(
      to: @user.email,
      from: 'registers@digital.cabinet-office.gov.uk',
      subject: t('forgot_password.mail_subject')
    )
  end
end
