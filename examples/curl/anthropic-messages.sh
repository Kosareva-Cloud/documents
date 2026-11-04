#!/bin/sh
# Запрос в формате Anthropic (/v1/messages). Ключ тот же, что и для OpenAI-формата,
# но передаётся в заголовке x-api-key; заголовок anthropic-version обязателен.
# Запуск: export KOSAREVA_API_KEY="sk-..." && sh anthropic-messages.sh
: "${KOSAREVA_API_KEY:?Задайте переменную KOSAREVA_API_KEY — ключ из https://kosareva.cloud/panel/}"

curl https://api.kosareva.cloud/v1/messages \
  -H "x-api-key: $KOSAREVA_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  --data-binary @- <<'JSON'
{
  "model": "claude-sonnet-5",
  "max_tokens": 512,
  "messages": [
    {"role": "user", "content": "Объясни, что такое идемпотентность."}
  ]
}
JSON
