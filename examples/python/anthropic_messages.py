"""Запрос в формате Anthropic (/v1/messages) через официальный SDK Anthropic.

Адрес указывается без /v1: SDK сам добавляет путь /v1/messages.
Ключ тот же, что и для OpenAI-формата.

Запуск:
    export KOSAREVA_API_KEY="sk-..."
    python anthropic_messages.py
"""
import os

from anthropic import Anthropic

client = Anthropic(
    api_key=os.environ["KOSAREVA_API_KEY"],
    base_url="https://api.kosareva.cloud",
)

message = client.messages.create(
    model="claude-sonnet-5",
    max_tokens=512,  # в формате Anthropic поле обязательное
    system="Отвечай кратко, по-русски.",
    messages=[{"role": "user", "content": "Объясни, что такое идемпотентность."}],
)

print(message.content[0].text)
print("Токены:", message.usage)
