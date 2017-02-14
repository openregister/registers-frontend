require 'govspeak'

module Spina
  ApplicationHelper.module_eval do
    def sort_link(column, title = nil)
      title ||= column.titleize
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
      css_class = sort_direction == "asc" ? "sorting-up" : "sorting-down"
      css_class = column == sort_column ? css_class : ""
      link_to title, request.query_parameters.merge({ column: column, direction: direction }), class: css_class
    end

    def govspeak(text)
      Govspeak::Document.new(text).to_html.html_safe
    end

    def crest_class_name(authority)
      case authority
      when "home-office"
        "logo-with-crest crest-ho"
      when "ministry-of-defence"
        "logo-with-crest crest-mod"
      when "hm-revenue-customs"
        "logo-with-crest crest-hmrc"
      when "welsh-government"
        "logo-with-crest crest-wales"
      when "department-for-business-innovation-and-skills"
        "logo-with-crest crest-bis"
      when "the-office-of-the-leader-of-the-house-of-commons"
        "logo-with-crest crest-portcullis"
      when "office-of-the-advocate-general-for-scotland"
        "logo-with-crest crest-so"
      when "uk-atomic-energy-authority"
        "logo-with-crest crest-ukaea"
      when "nhs", "government-digital-service"
        " "
      else
        "logo-with-crest crest-org"
      end
    end
  end
end
