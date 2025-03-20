FROM ruby:3.4-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache build-base git

# Copy Gemfile and install gems
COPY Gemfile* /app/
RUN bundle install

# Create data directory
RUN mkdir -p /app/data

# Copy application code
COPY . /app/

# Command to run
CMD ["ruby", "consumers/operations-consumer.rb"]
