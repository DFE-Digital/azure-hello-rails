# syntax=docker/dockerfile:1
FROM ruby:3.0.1
RUN apt-get update -qq && \
  apt-get install -y \
  nodejs \
  postgresql-client \
  curl \
  jq \
  openssh-server \
  && echo "root:Docker!" | chpasswd

# SSH Setup
# See https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh
COPY ./script/azure-tools/ssh/sshd_config /etc/ssh/
# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ./script/azure-tools/ssh/ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

# Rails setup

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY app /myapp/app
COPY bin /myapp/bin
COPY config /myapp/config
COPY db /myapp/db
COPY lib /myapp/lib
COPY vendor /myapp/vendor
COPY config.ru /myapp
COPY Rakefile /myapp

RUN RAILS_ENV=production SECRET_KEY_BASE=key bundle exec rake assets:precompile
COPY public /myapp/public

# Add a script to be executed every time the container starts.
COPY ./script script
RUN chmod +x -R script

ENTRYPOINT ["script/docker-entrypoint.sh"]
EXPOSE 80 2222

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]
