FROM ruby:2.6.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 8081
CMD ["ruby", "./api.rb", "-o", "0.0.0.0"]
