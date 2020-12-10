FROM ruby:2.6.3
WORKDIR /doit
COPY Gemfile /doit/
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    vim \
    && gem install bundler \
    && bundle install
COPY . /doit

EXPOSE 3000
RUN chmod +x /doit/entrypoint.sh
CMD ["/doit/entrypoint.sh"]