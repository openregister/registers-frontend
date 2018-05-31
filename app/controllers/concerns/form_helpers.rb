module FormHelpers
  def government_orgs_local_authorities
    registers = {
        'government-organisation': 'name',
        'local-authority-eng': 'official-name',
        'local-authority-sct': 'official-name',
        'local-authority-nir': 'official-name',
        'principal-local-authority': 'official-name',
    }

    registers.map { |k, v|
      Register.find_by(slug: k)&.records&.where(entry_type: 'user')&.current&.map { |r|
        [
          "#{k}:#{r.key}", r.data[v]
        ]
      }
    }.compact.flatten(1)
  end
end

def post_to_endpoint(user, endpoint = 'users')
  @user = { email: user.email,
            is_government: user.is_government_boolean,
            register: user.try(:register) }
            .compact
  uri = URI.parse("#{Rails.configuration.self_service_api_host}/#{endpoint}")
  options = {
    basic_auth: { username: Rails.configuration.self_service_http_auth_username, password: Rails.configuration.self_service_http_auth_password },
    body: @user
  }
  begin
    HTTParty.post(uri, options)
  end
rescue StandardError => e
  # Fallback for socket errors etc...
  logger.error("#{endpoint} POST failed with exception: #{e}")
  flash.now[:alert] = 'Something went wrong'
  nil
end
