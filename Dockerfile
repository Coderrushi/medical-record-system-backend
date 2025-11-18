# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy the csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish -c Release -o /publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app
COPY --from=build /publish .

# Expose port 8080 (Render requires this)
EXPOSE 8080

# Force ASP.NET to listen on port 8080
ENV ASPNETCORE_URLS=http://+:8080

# Run your application
ENTRYPOINT ["dotnet", "medical-record-system-backend.dll"]
