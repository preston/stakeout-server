FROM ruby:3.3.0-slim
LABEL maintainer="preston.lee@prestonlee.com"

# RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y build-essential imagemagick
# Install postgres native client package and native image processing
# RUN apt-get update && apt-get install -y build-essential libpq-dev imagemagick

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install build-essential libpq-dev imagemagick gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Default shell as bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh


# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock Rakefile config.ru ./
RUN gem install -N bundler && bundle install --jobs 8

# Copy the main application.
COPY . .

# We'll run in production mode by default.
ENV RAILS_ENV=production

# Showtime!
EXPOSE 3000
# CMD bundle exec rake db:migrate && bundle exec puma -C config/puma.rb
CMD bundle exec rake db:migrate && rails s
