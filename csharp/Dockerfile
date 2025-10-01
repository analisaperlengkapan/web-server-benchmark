FROM mcr.microsoft.com/dotnet/sdk:8.0 as builder
WORKDIR /app
COPY csharp-server.csproj ./
RUN dotnet restore
COPY Program.cs ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=builder /app/out .
EXPOSE 8080
CMD ["dotnet", "csharp-server.dll"]
