#!/bin/sh
# Потоковый ответ: сервер отдаёт события SSE (строки "data: {...}"),
# последняя строка — "data: [DONE]". Флаг -N отключает буферизацию curl.
# Запуск: export KOSAREVA_API_KEY="sk-..." && sh stream.sh
: "${KOSAREVA_API_KEY:?Задайте переменную KOSAREVA_API_KEY — ключ из https://kosareva.cloud/panel/}"

curl -N https://api.kosareva.cloud/v1/chat/completions \
  -H "Authorization: Bearer $KOSAREVA_API_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @- <<'JSON'
{
  "model": "deepseek-v4-flash",
  "stream": true,
  "messages": [
    {"role": "user", "content": "Напиши хокку про код-ревью."}
  ]
}
JSON
