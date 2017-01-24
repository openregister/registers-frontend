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
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# Nested forms
gem 'cocoon'

# HAML templating
gem 'haml-rails'

# GDS Frontend Toolkit, templates and elements
gem 'govuk_frontend_toolkit', git: 'https://github.com/alphagov/govuk_frontend_toolkit_gem.git', submodules: true
gem 'govuk_template'
gem 'govuk_elements_rails'
gem 'govspeak', '~> 3.4.0'

# Spina CMS
gem 'spina', github: 'denkGroot/Spina', branch: 'master'
gem 'globalize', github: 'globalize/globalize', branch: 'master'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Nicer UI for debugging errors
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
