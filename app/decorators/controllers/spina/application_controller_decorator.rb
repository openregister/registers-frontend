require 'govspeak'

module Spina
  ApplicationController.class_eval do
    helper_method :all_registers, :govspeak

    def all_registers
      Spina::Register.all
    end

    def govspeak(text)
      Govspeak::Document.new(text).to_html.html_safe
    end
  end
end
