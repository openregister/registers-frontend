module Spina
  class Support < ActiveRecord::Base
    include MultiStepModel

    validates_presence_of :email, :name, :message, if: :step2?

    def self.total_steps
      2
    end
  end
end
