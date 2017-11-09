[![Build Status](https://travis-ci.org/openregister/registers-frontend.svg?branch=master)](https://travis-ci.org/openregister/registers-frontend)

# Registers Frontend

Frontend for [GOV.UK Registers](https://registers.cloudapps.digital/)

## Prerequisites

This is a Rails 5 app using [Spina CMS](https://github.com/denkGroot/Spina)

1. Install Ruby 2.4.2
2. Install Rails 5.1.4
3. Install PostgreSQL 9.6+

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
