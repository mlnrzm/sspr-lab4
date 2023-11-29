FROM mcr.microsoft.com/dotnet/sdk:5.0 AS base
WORKDIR /app
EXPOSE 83
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY *.sln .
COPY ["./", "MainService/"]
RUN dotnet restore "MainService/MainService/MainProject.csproj"
RUN dotnet restore "MainService/TestProject/TestProject.csproj"

WORKDIR "/src/MainService"
RUN dotnet build "MainService/MainProject.csproj" -c Release -o /app/build
RUN dotnet build "TestProject/TestProject.csproj" -c Release -o /app/build


FROM build AS publish
RUN dotnet publish "MainService/MainProject.csproj" -c Release -o /app/publish	--no-restore
RUN dotnet publish "TestProject/TestProject.csproj" -c Release -o /app/publish	--no-restore
COPY ["TestProject/TestProject.csproj", "/app/publish"] 


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN dotnet restore
ENTRYPOINT ["dotnet", "MainProject.dll"]
