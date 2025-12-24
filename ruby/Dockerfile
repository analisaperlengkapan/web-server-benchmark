FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ruby-full build-essential ruby-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile ./
RUN gem install bundler && bundle install
COPY server.rb ./
EXPOSE 8080
CMD ["bundle", "exec", "ruby", "server.rb"]
