# syntax=docker/dockerfile:1
FROM ruby:3.0.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client curl jq

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY app /myapp/app
COPY bin /myapp/bin
COPY config /myapp/config
COPY db /myapp/db
COPY lib /myapp/lib
COPY public /myapp/public
COPY vendor /myapp/vendor
COPY config.ru /myapp
COPY Rakefile /myapp

RUN RAILS_ENV=production SECRET_KEY_BASE=key bundle exec rake assets:precompile

# Add a script to be executed every time the container starts.
COPY ./script script
RUN chmod +x -R script

ENTRYPOINT ["script/docker-entrypoint.sh"]
EXPOSE 80

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]
