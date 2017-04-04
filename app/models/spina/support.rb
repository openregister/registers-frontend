module Spina
  class Support
    include ActiveModel::Model

    attr_accessor :email, :name, :message, :subject

    validates_presence_of :email, :name, :message
  end
end
