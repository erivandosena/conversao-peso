#FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
#WORKDIR /app
#COPY published/aspnetapp.dll ./
#CMD ["dotnet", "aspnetapp.dll"]


# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

# copie csproj e restaure como camadas distintas
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
RUN dotnet restore

# copie tudo o mais e crie um aplicativo
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /src/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore

# estágio da imagem final
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./

EXPOSE 5000
EXPOSE 5001

#ENTRYPOINT ["dotnet", "aspnetapp.dll"]
CMD ["dotnet", "aspnetapp.dll"]