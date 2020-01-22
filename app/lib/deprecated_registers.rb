DEPRECATED = {
  "prison-estate": 'https://google.com'
}.freeze

class DeprecatedRegisters
  def self.query(id)
    DEPRECATED[id.to_sym]
  end
end
