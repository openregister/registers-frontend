module Spina
  ApplicationController.class_eval do
    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder
  end
end
