require 'govspeak'

module Spina
  ApplicationController.class_eval do
    helper_method :all_registers, :govspeak, :crest_class_name

    def all_registers
      Spina::Register.all
    end

    def govspeak(text)
      Govspeak::Document.new(text).to_html.html_safe
    end

    def crest_class_name(authority)
      case authority
      when "home-office"
        "crest-ho"
      when "ministry-of-defence"
        "crest-mod"
      when "hm-revenue-customs"
        "crest-hmrc"
      when "welsh-government"
        "crest-wales"
      when "department-for-business-innovation-and-skills"
        "crest-bis"
      when "the-office-of-the-leader-of-the-house-of-commons"
        "crest-portcullis"
      when "office-of-the-advocate-general-for-scotland"
        "crest-so"
      when "uk-atomic-energy-authority"
        "crest-ukaea"
      else
        "crest-org"
      end
    end
  end
end
