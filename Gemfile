source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'

gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'http', '2.2.1'

# Nested forms
gem 'cocoon'

# HAML templating
gem 'haml-rails'

# GDS Frontend Toolkit, templates and elements
gem 'govuk_frontend_toolkit'
gem 'govuk_template'
gem 'govuk_elements_rails'
gem 'govspeak', '~> 3.4.0'
gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder.git'
gem 'openregister-ruby', git: 'https://github.com/openregister/openregister-ruby'

# Spina CMS
gem 'spina', github: 'denkGroot/Spina', branch: 'master'
gem 'fog'

# Ransack
gem 'ransack', github: 'activerecord-hackery/ransack'

gem 'httparty'

# Zendesk
gem 'zendesk_api'

# Cloudfoundry ruby helper
gem 'cf-app-utils'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-byebug'

  # Nicer UI for debugging errors
  gem 'better_errors'
  gem 'binding_of_caller'
end
