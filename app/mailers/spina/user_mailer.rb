module Spina
  class UserMailer < GovukNotifyRails::Mailer
    def forgot_password(user)
      @credentials = CF::App::Credentials.find_by_service_name('registers-product-site-environment-variables')
      set_template(@credentials['FORGOTTEN_PASSWORD_TETMPLATE_ID'])

      @user = user

      set_personalisation(
        user_full_name: @user.email,
        edit_password_url: spina.edit_admin_password_reset_url(@user.password_reset_token)
      )

      mail(
        to: @user.email,
        from: current_account.email,
        subject: t('spina.forgot_password.mail_subject')
      )
    end

    private

      def current_account
        Spina::Account.first
      end
  end
end
