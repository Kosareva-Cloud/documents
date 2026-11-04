"""Обычный запрос к chat completions через официальный SDK OpenAI.

Запуск:
    export KOSAREVA_API_KEY="sk-..."
    python chat.py
"""
import os

from openai import OpenAI

client = OpenAI(
    api_key=os.environ["KOSAREVA_API_KEY"],
    base_url="https://api.kosareva.cloud/v1",
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",  # любое имя из https://kosareva.cloud/prices/
    messages=[
        {"role": "system", "content": "Отвечай кратко, по-русски."},
        {"role": "user", "content": "Чем процесс отличается от потока?"},
    ],
)

print(response.choices[0].message.content)
print("Токены:", response.usage)
