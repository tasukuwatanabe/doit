FROM ruby:2.6.3

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  yarn \
  vim
RUN mkdir /doit
WORKDIR /doit
COPY Gemfile /doit/Gemfile
COPY Gemfile.lock /doit/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /doit

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]