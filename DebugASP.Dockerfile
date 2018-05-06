FROM clumsypilot/dotnetdebug:asp-runtime-2.0 AS base
WORKDIR /app

MAINTAINER Vladimir Vladimir@akopyan.me 

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src

COPY ./DebugSample .
RUN dotnet restore 

FROM build AS publish
RUN dotnet publish -c Debug -o /app

FROM base AS final
COPY --from=publish /app /app

EXPOSE 5000

#CMD ./StartSSHApp.sh
CMD ["/usr/sbin/sshd", "-D"]
