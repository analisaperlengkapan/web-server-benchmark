FROM ruby:3.2-alpine
WORKDIR /app
COPY Gemfile ./
RUN bundle install
COPY server.rb ./
EXPOSE 8080
CMD ["ruby", "server.rb"]
