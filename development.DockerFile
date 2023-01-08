FROM ruby:2.7.5 as production

RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client

RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN gem install bundler

RUN bundle install

COPY . /myapp

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]