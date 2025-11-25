FROM ruby:3.4-slim
WORKDIR /app
COPY Gemfile ./
RUN bundle install
COPY server.rb ./
EXPOSE 8080
CMD ["ruby", "server.rb"]
