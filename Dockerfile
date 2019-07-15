FROM ruby:2.6.3-alpine3.9

# Set correct environment variables.
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV NODE_ENV production
ARG secret_key_base
ENV SECRET_KEY_BASE=$secret_key_base

RUN apk add --no-cache --update build-base linux-headers tzdata nodejs \
  openssh libxml2-dev libxslt-dev yarn curl-dev sqlite-dev \
  && PACKAGES="ca-certificates procps curl pcre libstdc++ libexecinfo" \
  && BUILD_PACKAGES="pcre-dev libexecinfo-dev" \
  && apk add --update $PACKAGES $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/*

# Install bundle of gems
RUN mkdir -p /home/app
WORKDIR /home/app
COPY Gemfile Gemfile.lock /home/app/
RUN gem install bundler \
  && bundle install --without development test

# Install node packages and precompile assets
COPY . /home/app
RUN yarn install --frozen-lockfile --non-interactive \
 && bundle exec rails assets:precompile \
 && yarn cache clean \
 && rm -rf /home/app/node_modules

# Add healthcheck
# https://blog.couchbase.com/docker-health-check-keeping-containers-healthy/
HEALTHCHECK CMD curl --fail --insecure https://0.0.0.0:3000/health || exit 1

EXPOSE 3000
CMD ["rails", "server", "-b", "ssl://0.0.0.0:3000?key=config/ssl/app.key&cert=config/ssl/app.crt"]
