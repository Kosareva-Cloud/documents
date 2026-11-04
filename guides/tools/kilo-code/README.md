# Kilo Code

Kilo Code (расширение VS Code, CLI и плагин JetBrains читают одни и те же
настройки) подключает шлюз как свой провайдер формата OpenAI.

## Через окно настроек

Настройки Kilo (шестерёнка) → вкладка **Providers** → внизу списка
**Custom provider**. Значения:

```text
Provider ID    kosareva
Display name   kosareva.cloud
Provider API   OpenAI Compatible
Base URL       https://api.kosareva.cloud/v1
API key        ваш ключ из https://kosareva.cloud/panel/
```

Когда адрес и ключ введены, Kilo сам запрашивает список моделей — отметьте
нужные. Если список не появился, впишите имя вручную, например
`claude-sonnet-5`, и нажмите **Submit**.

## Размер контекста — обязательно

Для моделей, которых нет во встроенном каталоге Kilo, контекст и потолок
ответа по умолчанию равны нулю, и тогда Kilo не сжимает историю: переписка
растёт, пока модель не откажет. Задать размеры можно только в файле
`~/.config/kilo/kilo.jsonc` (Windows: `C:\Users\<имя>\.config\kilo\kilo.jsonc`).
Там же можно описать провайдера целиком, без окна:

```json
{
  "$schema": "https://app.kilo.ai/config.json",
  "model": "kosareva/claude-sonnet-5",
  "provider": {
    "kosareva": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "kosareva.cloud",
      "options": {
        "baseURL": "https://api.kosareva.cloud/v1",
        "apiKey": "{env:KOSAREVA_API_KEY}"
      },
      "models": {
        "claude-sonnet-5": {
          "name": "Claude Sonnet 5",
          "tool_call": true,
          "limit": { "context": 1000000, "output": 32000 }
        },
        "deepseek-v4-1-flash": {
          "name": "DeepSeek V4.1 Flash",
          "tool_call": true,
          "limit": { "context": 1048576, "output": 32000 }
        }
      }
    }
  }
}
```

- `limit.context` — не больше, чем у модели в каталоге. Это ещё и потолок
  расхода: история сжимается, только когда подходит к пределу. Хотите, чтобы
  сжималось раньше, — поставьте меньше.
- `kosareva` — тот же Provider ID, что в окне настроек.
- `{env:KOSAREVA_API_KEY}` — ключ из переменной окружения; задайте её до
  запуска VS Code. Такая ссылка работает только в общем файле в
  `~/.config/kilo`: в `kilo.jsonc` проекта Kilo её игнорирует.

Полная инструкция: https://kosareva.cloud/instrumenty/kilo-code/
