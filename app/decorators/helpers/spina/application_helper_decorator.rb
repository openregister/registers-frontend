require 'govspeak'

module Spina
  ApplicationHelper.module_eval do
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
      when "nhs", "government-digital-service", "scottish-government"
        " "
      else
        "logo-with-crest crest-org"
      end
    end

    def registers_client
      RegistersClient::RegistersClientManager.new({ cache_duration: 600 })
    end

    def government_organisations
      register_data = registers_client.get_register('government-organisation', 'beta')
      return register_data.get_records
    end

    def beta_registers
      register_data = registers_client.get_register('register', 'beta')
      beta_registers = register_data.get_records
      return beta_registers
    end

    def phase_label(phase)
      case phase
      when 'Beta'
        'Ready to use'
      when 'Alpha'
        'Open for feedback'
      when 'Discovery'
        'In the backlog'
      when 'Backlog'
        'In the backlog'
      end
    end

    def formatted_date(date)
      DateTime.parse(date).strftime('%d/%m/%Y')
    end

    def sort_link(field_value, query_parameters)
      link_to field_value, register_path(@register.slug,
                                                   query_parameters.except(:sort_by, :sort_direction)
                                                   .to_h.merge(sort_direction: params[:sort_direction] == 'asc' && params[:sort_by] == field_value ? 'desc' : 'asc',
                                                   sort_by: field_value,
                                                   anchor: 'search_wrapper'))
    end
  end
end
