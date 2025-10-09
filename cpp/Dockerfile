FROM gcc:13 as builder
RUN apt-get update && apt-get install -y wget cmake libboost-dev
WORKDIR /app
RUN wget https://github.com/CrowCpp/Crow/releases/download/v1.0%2B5/crow_all.h
COPY server.cpp ./
RUN g++ -o server server.cpp -lpthread -O3 -std=c++14

FROM gcc:13
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
