module FormHelpers
  def set_government_orgs_local_authorities
    registers = {
        'government-organisation': 'name',
        'local-authority-eng': 'official-name',
        'local-authority-sct': 'official-name',
        'local-authority-nir': 'official-name',
        'principal-local-authority': 'official-name',
    }

    @government_orgs_local_authorities = registers.map { |k, v|
      Register.find_by(slug: k)&.records&.where(entry_type: 'user')&.current&.map { |r|
        [
          "#{k}:#{r.key}", r.data[v]
        ]
      }
    }.compact.flatten(1)
  end

  def set_is_government_boolean(params)
    params.merge!(is_government: case params[:is_government]
                                 when 'yes'
                                   true
                                 when 'no'
                                   false
                                 end)
  end
end

def post_to_endpoint(user, endpoint = 'users')
  @user = { email: user.is_government ? user.email_gov : user.email_non_gov,
            department: user.department,
            non_gov_use_category: user.non_gov_use_category,
            is_government: user.is_government,
            register: user.try(:register) }
            .compact
  uri = URI.parse("#{Rails.configuration.self_service_api_host}/#{endpoint}")
  options = {
    basic_auth: { username: Rails.configuration.self_service_http_auth_username, password: Rails.configuration.self_service_http_auth_password },
    body: @user
  }
  error_message = 'Something went wrong'
  begin
    HTTParty.post(uri, options)
  end
rescue StandardError => e
  # Fallback for socket errors etc...
  logger.error("#{endpoint} POST failed with exception: #{e}")
  flash.now[:alert] = error_message
  nil
end
