DEPRECATED = {
  'information-sharing-agreement-powers-and-objectives-0001': 'https://registers.culture.gov.uk/',
  'information-sharing-agreement-specified-person-0001': 'https://registers.culture.gov.uk/',
  'information-sharing-agreement-0001': 'https://registers.culture.gov.uk/'
}.freeze

class DeprecatedRegisters
  def self.query(id)
    DEPRECATED[id.to_sym]
  end
end
