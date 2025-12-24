FROM debian:bookworm-slim
# Install dotnet
RUN apt-get update && apt-get install -y wget && \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . ./
# Publish self-contained for linux-x64
RUN dotnet publish -c Release -r linux-x64 --self-contained true -o out

EXPOSE 8080
# Execute the binary directly
CMD ["./out/csharp-server"]
