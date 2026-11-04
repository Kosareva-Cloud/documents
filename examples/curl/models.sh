#!/bin/sh
# Список моделей, доступных по ключу. Удобно для проверки, что ключ и адрес верны:
# в ответ должен прийти JSON со списком моделей.
# Запуск: export KOSAREVA_API_KEY="sk-..." && sh models.sh
: "${KOSAREVA_API_KEY:?Задайте переменную KOSAREVA_API_KEY — ключ из https://kosareva.cloud/panel/}"

curl https://api.kosareva.cloud/v1/models \
  -H "Authorization: Bearer $KOSAREVA_API_KEY"
