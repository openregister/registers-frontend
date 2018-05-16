class DownloadUser < ApplicationRecord
  before_save :set_email
  attr_accessor :email_gov, :email_non_gov
  include FormValidations

private

  def set_email
    self.email = [email_non_gov, email_gov].find(&:present?)
  end
end
