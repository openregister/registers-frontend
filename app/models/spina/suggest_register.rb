module Spina
  class SuggestRegister
    include ActiveModel::Model

    attr_accessor :email, :name, :message, :subject, :register_name

    validates_presence_of :email, :name, :message, :register_name
  end
end
