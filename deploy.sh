#!/bin/bash
echo "Parando containers..."
docker compose down -v

echo "Subindo containers com build..."
docker compose up --build -d

echo "Deploy concluído!"