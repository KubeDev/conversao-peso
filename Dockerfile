# image build
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

LABEL vendor=Rogerio\ dos\ Santos\ Silva \
    email=roger7331@gmail.com \
    version="1.0" \
    release-date="2021-11-03"

WORKDIR /src

COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
RUN dotnet restore

COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /src/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore

# image production
FROM mcr.microsoft.com/dotnet/aspnet:5.0 as production
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]