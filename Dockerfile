# ------------------------ BUILD IMAGE --------------------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /App
COPY . ./

RUN dotnet restore

#RUN dotnet test MyProject/MyProject.Tests.csproj
#RUN dotnet publish MyProject.Web/MyProject.Web.csproj -c Release -o out

# -------------------- RUNTIME IMAGE -----------------------
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine

WORKDIR /App
COPY --from=build-env /App/out .
COPY --from=build-env /App/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# Add globalization and timezone to alpine: https://github.com/dotnet/dotnet-docker/blob/main/samples/enable-globalization.md
ENV \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

RUN apk add --no-cache \
    icu-data-full \
    icu-libs \
    tzdata

# Add packages so we can run as a specific PUID and GUID
RUN apk add --no-cache su-exec shadow

ENTRYPOINT ["/App/entrypoint.sh", "dotnet", "MyProject.Web.dll", "--appSettingsPath=/appdata"]