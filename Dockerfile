# Make sure to lock your ruby version to a specific one
FROM ruby:alpine AS dev
COPY .build-deps /
RUN cat .build-deps | xargs apk add
WORKDIR /APP_NAME
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

FROM dev AS ci
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5
COPY . ./
