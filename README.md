[![Build Status](https://travis-ci.org/openregister/registers-frontend.svg?branch=master)](https://travis-ci.org/openregister/registers-frontend)

# Registers Frontend

Frontend for [GOV.UK Registers](https://www.registers.service.gov.uk/)

## Prerequisites

1. Install Ruby 2.5.5
2. Install Rails 5.2.2
3. Install PostgreSQL 9.6+
4. Install Node 10+

## Installing and running locally

Download the GOV.UK frontend design system

```bash
$ npm install
```

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

## Populating the database with register data on PaaS

Add any registers using the `/admin` UI.

### prod

When running in production the `registers-frontend-scheduler` app periodically calls `rake registers_frontend:populate_db:fetch_later` which adds a job to a queue maintained by the `registers-frontend-queue` app. When the job runs it refreshes the data for all registers listed in the database.  

### sandbox

It's also possible to manually populate the database without running the `registers-frontend-scheduler` and `registers-frontend-queue` apps using `cf run-task`. This may fail for large registers if the task runs out of memory.
We might do this for a `registers-frontend-research` app for example.

```
cf run-task registers-frontend-research "bundle exec rake registers_frontend:populate_db:fetch_now" -m 1G --name fetch
```

Then you can see the result of the task using:

```
cf tasks registers-frontend-research
cf logs registers-frontend-research | grep fetch
```

### Updating Register metadata

If you update Register metadata using the [deployment scripts](https://github.com/openregister/deployment/tree/master/scripts) for example updating the `register-name` or field descriptions, these will not be automatically be picked up by the scheduled task, as it only picks up new `user` entries.

In order to get metadata changes to appear on the frontend, you must run the force full reload task:

1) Run `cf login` and select the `openregister` `prod` space
1) Run:  
```
cf run-task registers-frontend-queue "bundle exec rake registers_frontend:populate_db:force_full_register_download[ID]"
``` 
where `ID` is the ID of the register with changed metadata for example `country`.

## License

[MIT](LICENSE.txt).
