"""Потоковый ответ (stream=True): текст печатается по мере генерации.

Запуск:
    export KOSAREVA_API_KEY="sk-..."
    python stream.py
"""
import os

from openai import OpenAI

client = OpenAI(
    api_key=os.environ["KOSAREVA_API_KEY"],
    base_url="https://api.kosareva.cloud/v1",
)

stream = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[{"role": "user", "content": "Напиши хокку про код-ревью."}],
    stream=True,
)

for chunk in stream:
    # Служебные чанки приходят без choices — их пропускаем.
    if chunk.choices and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
print()
