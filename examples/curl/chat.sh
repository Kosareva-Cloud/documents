#!/bin/sh
# Обычный запрос к chat completions (OpenAI-формат).
# Запуск: export KOSAREVA_API_KEY="sk-..." && sh chat.sh
#
# Тело запроса идёт через stdin (--data-binary @-): так кириллица доходит
# в UTF-8 и в Git Bash на Windows, где аргументы командной строки curl
# перекодируются в кодовую страницу системы.
: "${KOSAREVA_API_KEY:?Задайте переменную KOSAREVA_API_KEY — ключ из https://kosareva.cloud/panel/}"

curl https://api.kosareva.cloud/v1/chat/completions \
  -H "Authorization: Bearer $KOSAREVA_API_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @- <<'JSON'
{
  "model": "deepseek-v4-flash",
  "messages": [
    {"role": "system", "content": "Отвечай кратко, по-русски."},
    {"role": "user", "content": "Чем процесс отличается от потока?"}
  ]
}
JSON
