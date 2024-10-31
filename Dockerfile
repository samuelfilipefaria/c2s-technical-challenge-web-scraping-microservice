FROM ruby:3.3.0

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl xvfb gnome-browser-connector default-mysql-client libjemalloc2 libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 7000
