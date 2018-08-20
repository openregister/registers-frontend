FROM ruby:2.5.1

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
COPY .ruby-version /usr/src/app/.ruby-version

RUN npm install
RUN bundle install
COPY . /usr/src/app

RUN sed -i "s/default: \&default/default: \&default\n  username: openregister-info\n  host: db\n  password:/" /usr/src/app/config/database.yml

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
