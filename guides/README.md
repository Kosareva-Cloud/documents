# Kosareva Cloud: подключение к API

Kosareva Cloud даёт компаниям и разработчикам один API к более чем 200 моделям OpenAI, Anthropic, Google, xAI, DeepSeek и других вендоров в форматах OpenAI и Anthropic, оплата в рублях. Официальные SDK и готовые инструменты работают с нами без переделки кода: меняются адрес и ключ.

[Первый запрос](#первый-запрос-за-три-шага) · [Адреса](#адреса) · [Инструменты](#настройка-инструментов) · [Код](#примеры-кода) · [Что ещё умеет API](#что-ещё-умеет-api) · [Модели](#каталог-моделей) · [Компаниям](#для-компаний) · [Ошибки](#если-что-то-не-работает) · [Чего нет](#чего-здесь-нет) · [Вопросы](#вопросы-и-ответы) · [English](README.en.md)

## Что вы получаете

| Задача | Как это устроено |
|---|---|
| Держать один ключ вместо нескольких | Один ключ работает со всеми моделями каталога: формат OpenAI для текстовых моделей, формат Anthropic для моделей Claude, картинки, видео, озвучка и музыка через свои адреса |
| Платить в рублях | Карта российского банка или СБП от 50 ₽, по счёту от 1 000 ₽, абонентской платы нет |
| Разделить расход по проектам | Отдельный ключ на проект или сотрудника, лимит в рублях, расход по каждому ключу |
| Не переписывать код | Меняете `base_url` и ключ, SDK остаётся тем же |
| Маскировать часть персональных данных перед отправкой в модель | [API Guard](https://kosareva.cloud/api-guard/) подключается заменой адреса и заменяет заглушками 22 типа данных, адреса и названия компаний он не находит |
| Подключить компанию | Договор, счёт и акт: [страница для бизнеса](../business/README.md) |

## Первый запрос за три шага

**1. Создайте ключ.** Зарегистрируйтесь в [кабинете](https://kosareva.cloud/panel/) по почте, через Яндекс ID или VK ID и выпустите ключ. Сохраните его в менеджер паролей: ключ, созданный с 15.09.2026, можно скопировать в кабинете снова.

**2. Пополните баланс.** Картой российского банка или СБП от 50 ₽, юрлицам по счёту от 1 000 ₽.

**3. Отправьте запрос.**

```sh
export KOSAREVA_API_KEY="sk-..."

curl https://api.kosareva.cloud/v1/chat/completions \
  -H "Authorization: Bearer $KOSAREVA_API_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @- <<'JSON'
{
  "model": "deepseek-v4-flash",
  "messages": [{"role": "user", "content": "Чем процесс отличается от потока?"}]
}
JSON
```

В PowerShell запустите [`examples/python/chat.py`](../examples/python/chat.py) или выполните запрос из Git Bash.

Каждый такой запрос списывает токены по цене модели. Проверить ключ без запроса к модели можно через список моделей: [`examples/curl/models.sh`](../examples/curl/models.sh).

## Адреса

| Что подключаете | Адрес | Как передаётся ключ |
|---|---|---|
| OpenAI SDK, cURL, инструменты с форматом OpenAI | `https://api.kosareva.cloud/v1` | `Authorization: Bearer <ключ>` |
| Anthropic SDK | `https://api.kosareva.cloud` без `/v1`, SDK допишет путь сам | `x-api-key: <ключ>` |
| Claude Code | `https://api.kosareva.cloud` без `/v1` | `Authorization: Bearer <ключ>`, задаётся через `ANTHROPIC_AUTH_TOKEN` |
| API Guard, OpenAI SDK | `https://api.kosareva.cloud/guard/v1` | тот же ключ |
| API Guard, Anthropic SDK | `https://api.kosareva.cloud/guard` | тот же ключ |

Ключ один на все четыре адреса.

## Настройка инструментов

| Инструмент | Что сделать | Файл |
|---|---|---|
| Расширение для VS Code | поставить из Marketplace, ввести ключ | [`tools/vscode/README.md`](tools/vscode/README.md) |
| Claude Code | задать переменные окружения | [`tools/claude-code/README.md`](tools/claude-code/README.md) |
| Codex CLI | положить конфиг в `~/.codex/config.toml` | [`tools/codex-cli/config.toml`](tools/codex-cli/config.toml) |
| Continue | положить конфиг в `~/.continue/config.yaml` | [`tools/continue/config.yaml`](tools/continue/config.yaml) |
| Cline | заполнить три поля в настройках | [`tools/cline/README.md`](tools/cline/README.md) |
| Kilo Code | заполнить провайдера и размер контекста | [`tools/kilo-code/README.md`](tools/kilo-code/README.md) |
| opencode | положить `opencode.json` | [`tools/opencode/opencode.json`](tools/opencode/opencode.json) |
| Zed | вставить фрагмент в `settings.json` | [`tools/zed/settings.json`](tools/zed/settings.json) |
| GitHub Copilot, чат VS Code | добавить Custom Endpoint | [`tools/github-copilot/chatLanguageModels.json`](tools/github-copilot/chatLanguageModels.json) |
| Open WebUI | заполнить Connections или задать переменные контейнера | [`tools/open-webui/README.md`](tools/open-webui/README.md) |
| n8n | создать credentials типа OpenAI | [`n8n/README.md`](n8n/README.md) |
| Cursor | сначала прочитать оговорку | [`tools/cursor/README.md`](tools/cursor/README.md) |
| Hermes Agent, OpenClaw | инструкции на сайте | [Hermes](https://kosareva.cloud/instrumenty/hermes/), [OpenClaw](https://kosareva.cloud/instrumenty/openclaw/) |

Ниже то же самое короче, для тех, кто уже знает инструмент. Пошаговые версии с пояснениями лежат на [kosareva.cloud/instrumenty/](https://kosareva.cloud/instrumenty/).

### Расширение для VS Code

`Ctrl+Shift+X`, поиск `kosareva`, Install. Затем `Ctrl+Shift+P` → «kosareva.cloud: Подключить ключ». В списке моделей чата нажмите **Add Models → kosareva.cloud** и отметьте нужные: без этого шага модели в чате не появятся.

### Claude Code

```sh
export ANTHROPIC_BASE_URL="https://api.kosareva.cloud"
export ANTHROPIC_AUTH_TOKEN="$KOSAREVA_API_KEY"
```

Адрес указывается без `/v1`. Запустите `claude` в этом же терминале. Чтобы переменные сохранились, добавьте строки в `~/.zshrc` или `~/.bashrc`, вариант для PowerShell в [файле](tools/claude-code/README.md).

### Codex CLI

```toml
model = "gpt-6-luna"
model_provider = "kosareva"

[model_providers.kosareva]
name = "kosareva.cloud"
base_url = "https://api.kosareva.cloud/v1"
env_key = "KOSAREVA_API_KEY"
wire_api = "responses"
```

Codex работает через Responses API, поэтому ставьте модели OpenAI.

### Continue

```yaml
name: kosareva-cloud
version: 0.0.1
schema: v1

models:
  - name: Claude Sonnet 5
    provider: openai
    model: claude-sonnet-5
    apiBase: https://api.kosareva.cloud/v1
    apiKey: sk-...
```

`provider: openai` указывается и для Claude: это формат протокола, а не вендор. Continue больше не развивается, новым пользователям подойдут Cline или Kilo Code.

### Cline

В настройках выберите **API Provider → OpenAI Compatible**:

```text
Base URL   https://api.kosareva.cloud/v1
API Key    ваш ключ
Model ID   claude-sonnet-5
```

### Kilo Code

**Providers → Custom provider**, тип **OpenAI Compatible**, адрес `https://api.kosareva.cloud/v1`. Размер контекста задайте в `~/.config/kilo/kilo.jsonc`, иначе Kilo не сжимает историю: пример в [файле](tools/kilo-code/README.md).

### opencode

Положите [`opencode.json`](tools/opencode/opencode.json) в `~/.config/opencode/` или в корень проекта. Ключ читается из `KOSAREVA_API_KEY`.

### Zed

Вставьте [фрагмент](tools/zed/settings.json) в `settings.json`, ключ Zed спросит в интерфейсе провайдера.

### GitHub Copilot, чат VS Code

**Chat: Manage Language Models → Add Models → Custom Endpoint**, тип Chat Completions. VS Code откроет файл, в который вставляется [этот конфиг](tools/github-copilot/chatLanguageModels.json).

### Open WebUI

**Admin → Settings → Connections → OpenAI API**, адрес `https://api.kosareva.cloud/v1`, ключ из кабинета. Вариант для контейнера есть в [файле](tools/open-webui/README.md).

### n8n

**Credentials → New**, тип **OpenAI**, Base URL `https://api.kosareva.cloud/v1`. Под n8n удобно выпустить отдельный ключ с лимитом.

### Cursor

Наш ключ не снимает блокировку Cursor: закрыто его собственное облако. Подробности в [файле](tools/cursor/README.md).

## Примеры кода

Каждый запуск это настоящий запрос: токены списываются с баланса. Ключ берётся из переменной `KOSAREVA_API_KEY`.

| Язык | Файлы |
|---|---|
| Python | [`chat.py`](../examples/python/chat.py), [`stream.py`](../examples/python/stream.py), [`anthropic_messages.py`](../examples/python/anthropic_messages.py) |
| Node.js | [`chat.mjs`](../examples/node/chat.mjs), [`stream.mjs`](../examples/node/stream.mjs) |
| curl | [`chat.sh`](../examples/curl/chat.sh), [`stream.sh`](../examples/curl/stream.sh), [`models.sh`](../examples/curl/models.sh), [`anthropic-messages.sh`](../examples/curl/anthropic-messages.sh) |

**Python** (3.10+):

```sh
cd examples/python
python -m venv .venv
source .venv/bin/activate                  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python chat.py
```

**Node.js** (22+):

```sh
cd examples/node
npm install
node chat.mjs                              # или: node --env-file=../.env chat.mjs
```

**curl**:

```sh
sh examples/curl/models.sh
sh examples/curl/chat.sh
```

Ключ можно положить и в файл: `cp examples/.env.example examples/.env`, затем `set -a; . examples/.env; set +a`.

С `stream: true` ответ приходит событиями SSE по мере генерации. SDK разбирают их сами, в curl виден сырой поток до строки `data: [DONE]`.

### API Guard в коде

Меняется только адрес, ответ приходит с настоящими данными:

```python
from openai import OpenAI

client = OpenAI(api_key="sk-...", base_url="https://api.kosareva.cloud/guard/v1")
```

На обычном `/v1` маскирования нет. Что Guard находит и чего не находит, написано на [странице API Guard](https://kosareva.cloud/api-guard/).

## Что ещё умеет API

| Что | Адрес от `https://api.kosareva.cloud` |
|---|---|
| Чат, формат OpenAI | `POST /v1/chat/completions` |
| Responses API | `POST /v1/responses` |
| Сообщения, формат Anthropic | `POST /v1/messages` |
| Эмбеддинги | `POST /v1/embeddings` |
| Картинки | `POST /v1/images/generations`, `POST /v1/images/edits` |
| Озвучка | `POST /v1/audio/speech` |
| Распознавание речи | `POST /v1/audio/transcriptions` |
| Видео, задача в фоне | `/v1/videos` |
| Музыка, задача в фоне | `/v1/music` |
| Список моделей | `GET /v1/models` |

Параметры каждого адреса описаны в [документации](https://kosareva.cloud/docs/). Баланс, ключи и счета читаются отдельным API кабинета на `https://kosareva.cloud/api/v1/`, не на `api.`.

Поток, вызов функций, кэш промптов и рассуждения работают там, где их поддерживают модель и маршрут. Подробнее, в том числе про веб-поиск, в [принципах](../principles/README.md#1-форматы-вендоров).

## Каталог моделей

Имена и цены в рублях: [kosareva.cloud/prices/](https://kosareva.cloud/prices/). Для программ есть JSON без ключа, а с ключом можно запросить `/v1/models`:

```sh
curl -s https://kosareva.cloud/panel/api/price-catalog
```

В коде берите имя из этих источников и не вписывайте список руками: модели меняются. Имена пишутся через дефисы, как в адресе страницы модели: `claude-sonnet-5-5`, `gpt-6-1-terra`, `gemini-3-8-flash`.

Правила для кодовых агентов лежат в [AGENTS.md](../AGENTS.md).

## Для компаний

Мы работаем только через настоящий API вендоров и не используем подписки ChatGPT, Claude Code или IDE как канал для API. Работаем через российское ИП или через армянское ООО, вы выбираете, что удобнее. Оплата по счёту в рублях от 1 000 ₽. Отдельные ключи под проекты и сотрудников, API Guard, помощь с интеграцией и разработка ботов описаны на [странице для бизнеса](../business/README.md).

## Безопасность

- В базе кабинета хранятся sha256-хэш ключа и его зашифрованная копия: она нужна, чтобы кабинет подставлял ключ в быстрый старт и давал скопировать его снова. Ключи, созданные до 15.09.2026, скопировать нельзя.
- Держите ключ в переменной окружения или в `.env`, он уже в `.gitignore`.
- Не вписывайте ключ в код и в конфиги, которые попадают в репозиторий. Ключ, оказавшийся в публичном репозитории, считайте утёкшим: отзовите его в кабинете и выпустите новый.
- На каждый проект заведите свой ключ с лимитом в рублях, тогда утечка одного ключа ограничена этим лимитом.

Как сообщить об уязвимости: [SECURITY.md](https://github.com/Kosareva-Cloud/.github/blob/main/SECURITY.md).

## Если что-то не работает

- **401.** Ключ не принят: пустая переменная, опечатка, отозванный ключ.
- **404.** Неверный адрес: для формата OpenAI нужен `/v1` на конце, для формата Anthropic нет.
- **«Такой модели нет в каталоге».** Код `model_not_found`: скопируйте имя со страницы модели или возьмите из `GET /v1/models`.
- **Нулевой баланс** блокирует запросы, пополните его в кабинете.

Коды ответов и что с ними делать: [справочник](https://kosareva.cloud/spravochnik/).

## Чего здесь нет

- Установщика одной командой: настройка сводится к адресу и ключу.
- Бесплатного режима в примерах: запуск тратит баланс.
- Примеров с повторами при временных ошибках, вызовом функций, картинками, видео и озвучкой: здесь только базовые текстовые запросы.
- Готового workflow для n8n, только настройка credentials.
- Batch API. Полный список в [принципах](../principles/README.md#чего-у-нас-нет).

## Вопросы и ответы

### Какой base URL у Kosareva Cloud для OpenAI SDK?

Для OpenAI SDK и инструментов с форматом OpenAI base URL Kosareva Cloud равен `https://api.kosareva.cloud/v1`. Ключ передаётся заголовком `Authorization: Bearer`.

### Какой адрес у Kosareva Cloud для Anthropic SDK и Claude Code?

Для Anthropic SDK и Claude Code адрес Kosareva Cloud равен `https://api.kosareva.cloud`, без `/v1`: путь `/v1/messages` клиент дописывает сам. Через этот формат работают модели Claude, остальные модели подключаются по адресу OpenAI.

### Как проверить ключ Kosareva Cloud без платного запроса?

Запросите список моделей Kosareva Cloud: `GET https://api.kosareva.cloud/v1/models` с вашим ключом. Запрос не обращается к модели и не тратит баланс, готовый скрипт лежит в [`examples/curl/models.sh`](../examples/curl/models.sh).

## Контакты

ceo@kosareva.cloud · Telegram [@kosareva_cloud](https://t.me/kosareva_cloud)

## Лицензия

[MIT](../LICENSE)
