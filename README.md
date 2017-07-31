[![Build Status](https://travis-ci.org/openregister/register-status.svg?branch=master)](https://travis-ci.org/openregister/register-status)

# Register status

Frontend content management for [GOV.UK Open Registers](https://registers.cloudapps.digital/)

## Prerequisites

This is a Rails 5 app using [Spina CMS](https://github.com/denkGroot/Spina)

1. Install [Ruby 2.4.0](https://www.ruby-lang.org/en/news/2016/12/25/ruby-2-4-0-released/)
2. Install [Rails 5](http://weblog.rubyonrails.org/2017/3/1/Rails-5-0-2-has-been-released/)
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

## DeskPro

If you need to use the DeskPro service you need to add 2 environment variables

1. `DESKPRO_API_KEY`
2. `DESKPRO_API_BASE_URL` e.g. `https://openregisters.deskpro.com:443/api/`

## License

[MIT](LICENSE.txt).
