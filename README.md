# Register status

Frontend content management for [GOV.UK Open Registers](https://registers.cloudapps.digital/)

## Prerequisites

1. Install [Ruby 2.4.0](https://www.ruby-lang.org/en/news/2016/12/25/ruby-2-4-0-released/)
2. Install bundle: `gem install bundle` 

## Getting started

1. `bundle`
2. `rails g spina:install`
3. `rake db:seed`

after these succeed you can run the server anytime with:
 
`rails s`

> you can change page contents by going to the admin console http://localhost:3000/admin

## DeskPro

If you need to use the DeskPro service you need to add 2 environment variables
 
1. `DESKPRO_API_KEY`
2. `DESKPRO_API_BASE_URL` e.g. `https://openregisters.deskpro.com:443/api/`
