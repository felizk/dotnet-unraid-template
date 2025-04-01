@echo off
@REM https://dev.to/felizk/remote-deploy-with-docker-compose-to-unraid-1dai
docker-compose --context unraid -f docker-compose.yml down --rmi local
docker-compose --context unraid -f docker-compose.yml up --build