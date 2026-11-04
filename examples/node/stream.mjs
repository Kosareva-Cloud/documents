// Потоковый ответ (stream: true): текст печатается по мере генерации.
//
// Запуск:
//   export KOSAREVA_API_KEY="sk-..."
//   node stream.mjs

import OpenAI from "openai";

const client = new OpenAI({
  apiKey: process.env.KOSAREVA_API_KEY,
  baseURL: "https://api.kosareva.cloud/v1",
});

const stream = await client.chat.completions.create({
  model: "deepseek-v4-flash",
  messages: [{ role: "user", content: "Напиши хокку про код-ревью." }],
  stream: true,
});

for await (const chunk of stream) {
  // Служебные чанки приходят без choices — их пропускаем.
  const text = chunk.choices[0]?.delta?.content;
  if (text) process.stdout.write(text);
}
process.stdout.write("\n");
