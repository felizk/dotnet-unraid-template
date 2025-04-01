@echo off
docker-compose --context unraid -f docker-compose.yml down --rmi local
docker-compose --context unraid -f docker-compose.yml up --build