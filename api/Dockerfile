FROM ruby:2.6.3
WORKDIR /doit
COPY Gemfile Gemfile.lock /doit/
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    vim \
    && gem install bundler \
    && bundle install
COPY . /doit
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
