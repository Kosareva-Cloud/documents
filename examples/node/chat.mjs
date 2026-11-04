// Обычный запрос к chat completions через официальный SDK OpenAI для Node.js.
//
// Запуск:
//   export KOSAREVA_API_KEY="sk-..."
//   node chat.mjs
// или с ключом из файла .env в папке examples:
//   node --env-file=../.env chat.mjs

import OpenAI from "openai";

const client = new OpenAI({
  apiKey: process.env.KOSAREVA_API_KEY,
  baseURL: "https://api.kosareva.cloud/v1",
});

const response = await client.chat.completions.create({
  model: "deepseek-v4-flash", // любое имя из https://kosareva.cloud/prices/
  messages: [
    { role: "system", content: "Отвечай кратко, по-русски." },
    { role: "user", content: "Чем процесс отличается от потока?" },
  ],
});

console.log(response.choices[0].message.content);
console.log("Токены:", response.usage);
