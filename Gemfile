source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby File.read(".ruby-version").chomp

gem 'email_validator', github: 'mailtop/email_validator'
gem 'rails', '~> 5.2.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0', '>= 5.0.5'
gem 'jbuilder', '~> 2.5'
gem 'http', '2.2.1'

# HAML templating
gem 'haml-rails'

# GDS Frontend Toolkit, templates and elements
gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder.git'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template'
gem 'govuk-registers-api-client', '~> 1.2.2'

gem 'autoprefixer-rails'

# Zendesk
gem 'zendesk_api'

# Cloudfoundry ruby helper
gem 'cf-app-utils'
gem 'health_check', '~> 2.7'

# Email and Text Notifications
gem 'govuk_notify_rails'

# Pagination
gem 'kaminari'

# Job Scheduling
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.3'

# Database
gem 'activerecord-import'
gem 'scenic', '~> 1.4', '>= 1.4.1'

# Schedule
gem 'clockwork'

# Monitoring
gem 'gds_metrics', '~> 0.1.0'

# Encrypted password
gem 'bcrypt'

# HTTP
gem 'httparty', '~> 0.16.2'

# Canonical meta tag
gem 'canonical-rails'

gem 'invisible_captcha'

# Datetime parsing
gem 'iso8601', '~> 0.11.0'

# MailChimp
gem 'gibbon', '~> 3.2'

group :development, :test do
  gem 'govuk-lint', '~> 3.8'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'webmock'
end

group :production do
  gem 'lograge', '~> 0.9.0'
  gem 'logstash-event', '~> 1.2', '>= 1.2.02'
end
