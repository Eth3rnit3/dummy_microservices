FROM ruby:3.4-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache build-base

# Copy Gemfile and install gems
COPY Gemfile* /app/
RUN bundle install

# Copy application code
COPY . /app/

# Command to run
CMD ["ruby", "api/notifications-api.rb", "-o", "0.0.0.0"]
