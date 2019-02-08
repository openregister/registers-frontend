module ApplicationHelper
  def page_entries_info(collection, options = {})
    raw super(collection, options).gsub(/(\d{4,})/) { |m| number_with_delimiter(m) }
  end

  def crest_class_name(authority)
    case authority
    when 'home-office'
      'logo-with-crest crest-ho'
    when 'ministry-of-defence'
      'logo-with-crest crest-mod'
    when 'hm-revenue-customs'
      'logo-with-crest crest-hmrc'
    when 'department-for-business-innovation-and-skills'
      'logo-with-crest crest-bis'
    when 'the-office-of-the-leader-of-the-house-of-commons'
      'logo-with-crest crest-portcullis'
    when 'office-of-the-advocate-general-for-scotland'
      'logo-with-crest crest-so'
    when 'uk-atomic-energy-authority'
      'logo-with-crest crest-ukaea'
    when 'nhs', 'scottish-government', 'welsh-government', 'office-for-national-statistics', 'nhs-digital'
      ' '
    else
      'logo-with-crest crest-org'
    end
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
    Date.parse(date).strftime('%d/%m/%Y') # eg 03/08/2015
  end

  def human_readable_date(date)
    Date.parse(date).strftime('%e %B %Y') # eg 3 August 2015
  end

  def humanize_with_dashes(string)
    string
      .humanize
      .tr('-', ' ')
  end

  def make_urls_wrappable(string)
    # Assumes a full stop with a lowercase letter, number, or an underscore on
    # both sides is part of a URL; then adds an invisible breaking space to
    # allow wrapping.
    # eg:
    #  - Apples. Oranges. Pears. => Apples. Oranges. Pears.
    #  - GOV.UK => GOV.UK
    #  - registers.service.gov.uk => registers.&#8203;service.&#8203;gov.&#8203;uk
    string
      .gsub(/([a-z0-9_])\.([a-z0-9_])/, '\1.&#8203;\2')
      .html_safe
  end

  def records_table_header(field_value)
    wrapper_css_class = params[:sort_by] == field_value ? 'table-header active' : 'table-header'

    content_tag 'th', class: "#{field_value} #{wrapper_css_class}" do
      field_value.tr('-', ' ').humanize
    end
  end
end
