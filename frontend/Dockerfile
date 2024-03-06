FROM ruby
WORKDIR /app
COPY . .
RUN bundle install
CMD bundle exec rackup -o 0.0.0.0 -p 3000
EXPOSE 3000