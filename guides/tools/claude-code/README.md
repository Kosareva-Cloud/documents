# Claude Code

Claude Code работает с API в формате Anthropic (`/v1/messages`). Шлюз этот
формат поддерживает, поэтому агент подключается штатными переменными
окружения, без правки его конфигов. Ключ тот же, что и для OpenAI-формата.

## macOS и Linux

Добавьте в `~/.zshrc` или `~/.bashrc`:

```sh
export KOSAREVA_API_KEY="sk-..."   # ключ из https://kosareva.cloud/panel/
export ANTHROPIC_BASE_URL="https://api.kosareva.cloud"
export ANTHROPIC_AUTH_TOKEN="$KOSAREVA_API_KEY"
export ANTHROPIC_MODEL="claude-sonnet-5"   # необязательно
```

## Windows, PowerShell

```powershell
$env:KOSAREVA_API_KEY = "sk-..."
$env:ANTHROPIC_BASE_URL = "https://api.kosareva.cloud"
$env:ANTHROPIC_AUTH_TOKEN = $env:KOSAREVA_API_KEY
$env:ANTHROPIC_MODEL = "claude-sonnet-5"
```

Так переменные живут до закрытия окна PowerShell.

## Проверка

Откройте новый терминал и запустите `claude`. Расход появится в кабинете
сразу после первого ответа.

## Если агент не отвечает

- Адрес указывается **без `/v1`** — Claude Code сам добавляет `/v1/messages`.
- Переменные видны только в новом терминале — перезапустите его.
- Имя модели — из каталога, через дефисы: `claude-sonnet-5`, `claude-haiku-4-5`.
- Нулевой баланс блокирует запросы — пополните его в кабинете.

Полная инструкция: https://kosareva.cloud/instrumenty/claude-code/
