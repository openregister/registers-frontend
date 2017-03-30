module Spina
  class Support < ActiveRecord::Base
    include MultiStepModel

    attr_accessor :step_one, :step_two, :step_three

    validates_presence_of :email, :name, :message, if: :step3?

    def self.total_steps
      3
    end
  end
end
