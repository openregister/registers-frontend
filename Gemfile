source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby File.read(".ruby-version").chomp

gem 'email_validator', github: 'mailtop/email_validator'
gem 'rails', '~> 5.2.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0', '>= 5.0.5'
gem 'jbuilder', '~> 2.8'

# HAML templating
gem 'haml-rails'

# GDS Frontend Toolkit, templates and elements
gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder.git'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template'
gem 'govuk-registers-api-client', '~> 2.0.0'

gem 'autoprefixer-rails'

# Zendesk
gem 'zendesk_api'

# Cloudfoundry ruby helper
gem 'cf-app-utils'
gem 'health_check', '~> 3.0'

# Pagination
gem 'kaminari'

# Job Scheduling
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.3'

# Database
gem 'activerecord-import'
gem 'scenic', '~> 1.5'

# Schedule
gem 'clockwork'

# Monitoring
gem 'gds_metrics', '~> 0.1.0'
gem 'prometheus_exporter', '~> 0.4.5'

# HTTP
gem 'httparty', '~> 0.17.0'

# Canonical meta tag
gem 'canonical-rails'

gem 'invisible_captcha'

# Datetime parsing
gem 'iso8601', '~> 0.12.1'

# MailChimp
gem 'gibbon', '~> 3.2'

# Markdown rendering
gem 'bluecloth'

# ODS
gem 'spreadsheet_architect', '~> 3.2'
gem 'axlsx', git: 'https://github.com/NoRedInk/axlsx.git',
             ref: '1a4a6387bf398e2782933ee6607e5589cd15bee3' # 2.1.0-pre-with-new-rubyzip, see https://github.com/randym/axlsx/issues/536

group :development, :test do
  gem 'govuk-lint', '~> 3.10'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  gem 'listen', '~> 3.1.5'
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
  gem 'lograge', '~> 0.10.0'
  gem 'logstash-event', '~> 1.2', '>= 1.2.02'
end
