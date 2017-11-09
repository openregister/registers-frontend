[![Build Status](https://travis-ci.org/openregister/registers-frontend.svg?branch=master)](https://travis-ci.org/openregister/registers-frontend)

# Registers Frontend

Frontend for [GOV.UK Registers](https://registers.cloudapps.digital/)

## Prerequisites

This is a Rails 5 app using [Spina CMS](https://github.com/denkGroot/Spina)

1. Install [Ruby 2.4.1](https://www.ruby-lang.org/en/news/2017/03/22/ruby-2-4-1-released/)
2. Install [Rails 5.1.4](http://weblog.rubyonrails.org/2017/9/7/Rails-5-1-4-and-5-0-6-released/)
3. Install [PostgreSQL](https://www.postgresql.org/download/)

## Installing and running locally

Install the gem dependencies and setup the postgresql database

```bash
$ bundle install
$ rake db:create
$ rails g spina:install
$ rake db:seed
$ rails server
```

You can access the CMS via http://localhost:3000/admin

## Zendesk

If you need to use the Zendesk service you need to add 3 environment variables

1. `ZENDESK_TOKEN`
2. `ZENDESK_URL`
2. `ZENDESK_USERNAME`

## License

[MIT](LICENSE.txt).
