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
$ rails db:setup
$ rake registers_frontend:populate_db:fetch_now
$ rails server
```

You can access the CMS via http://localhost:3000/admin

## Running with Docker

Instead of the above, you can use [Docker](https://docs.docker.com) as
follows:

```bash
$ docker-compose build
$ docker-compose run --rm web rails db:setup
$ docker-compose up -d
```

And access it normally via http://localhost:3000

To stop it, run `docker-compose stop`.

NOTE: If you have changed your working directory (e.g. checkout a branch, edit
a file) you have to rerun `docker-compose build` before running
`docker-compose up -d` to ensure all changes are picked up.


## Zendesk

If you need to use the Zendesk service you need to add 3 environment variables

1. `ZENDESK_TOKEN`
2. `ZENDESK_URL`
2. `ZENDESK_USERNAME`

## License

[MIT](LICENSE.txt).
