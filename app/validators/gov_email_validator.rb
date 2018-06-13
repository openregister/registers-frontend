class GovEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    gov_domains = [
      'gov.uk',
      'mod.uk',
      'mil.uk',
      'ddc-mod.org',
      'slc.co.uk',
      'gov.scot',
      'parliament.uk',
      'nhs.uk',
      'nhs.net',
      'police.uk',
      'dclgdatamart.co.uk',
      'ucds.email',
      'naturalengland.org.uk',
      'hmcts.net',
      'scotent.co.uk',
      'assembly.wales',
      'cjsm.net',
      'cqc.org.uk',
      'bl.uk',
      'wmfs.net',
      'bbsrc.ac.uk',
      'acas.org.uk',
      'gov.wales',
      'biglotteryfund.org.uk',
      'marinemanagement.org.uk',
      'britishmuseum.org',
      'derrystrabane.com',
      'highwaysengland.co.uk',
      'ac.uk',
      'esfrs.org',
      'tfgm.com',
      'nationalgalleries.org',
      'cynulliad.cymru',
      'llyw.cymru',
      'judiciary.uk'
    ]

    unless gov_domains.any? { |gd| value.end_with?(gd) }
      record.errors[attribute] << 'Enter a government email address'
    end
  end
end
