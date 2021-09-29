FROM mcr.microsoft.com/dotnet/sdk:5.0 as build-app
WORKDIR /app
EXPOSE 80

COPY *.csproj ./
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:5.0 as publish
WORKDIR /app

COPY --from=build-app /app/out .
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]