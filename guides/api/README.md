# Документация API kosareva.cloud

Копия страницы [kosareva.cloud/docs/](https://kosareva.cloud/docs/) от 04.11.2026. Свежие цены и список моделей: [каталог](https://kosareva.cloud/prices/).

Один ключ — и все модели каталога через OpenAI-совместимый API: текст и код, эмбеддинги, картинки, озвучка и распознавание речи. Если у вас уже есть код под OpenAI SDK, меняются две строки — ключ и `base_url`.

Клиентам в формате Anthropic, например Claude Code, нужен тот же адрес без `/v1`. Ниже — всё для первого запроса, список эндпоинтов с примерами, разбор ошибок и API личного кабинета.

- **Base URL:** `https://api.kosareva.cloud/v1`
- **Формат Anthropic:** `https://api.kosareva.cloud` — без `/v1`, путь `/v1/messages` SDK допишет сам
- **Авторизация:** `Authorization: Bearer ВАШ_API_КЛЮЧ`, в формате Anthropic — и `x-api-key`
- **Имя модели:** как в каталоге, латиницей через дефисы: `gpt-5-6`, `claude-sonnet-5-5`
- **Оплата:** рубли на балансе, списание по факту: за токены, картинку, минуту записи. Абонентской платы нет

## Быстрый старт

Три шага, после которых работает любой код под OpenAI SDK.

### 1. Зарегистрируйтесь и пополните баланс

Вход в [личный кабинет](https://kosareva.cloud/panel/) — по почте, Яндекс ID или VK ID. Пополнение картой или СБП — от 50 ₽, юрлицам — по счёту от 1 000 ₽, с договором и актом.

### 2. Создайте API-ключ

В кабинете откройте «API-ключи» и создайте ключ. Полный ключ потом можно скопировать в том же списке — кнопка «Копировать». Под каждый проект или сотрудника удобно завести свой ключ: расход виден по каждому, а лимит в рублях задаётся отдельно.

### 3. Отправьте первый запрос

Подставьте ключ вместо `ВАШ_API_КЛЮЧ`. Модель — любая текстовая из [каталога](https://kosareva.cloud/prices/), здесь `gpt-5-6`.

```sh
curl https://api.kosareva.cloud/v1/chat/completions \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5-6","messages":[{"role":"user","content":"Привет!"}]}'
```

### Python, OpenAI SDK

```py
from openai import OpenAI

client = OpenAI(
    api_key="ВАШ_API_КЛЮЧ",
    base_url="https://api.kosareva.cloud/v1",
)

response = client.chat.completions.create(
    model="gpt-5-6",
    messages=[{"role": "user", "content": "Привет!"}],
)
print(response.choices[0].message.content)
```

### Node.js, OpenAI SDK

```js
import OpenAI from 'openai';

const client = new OpenAI({
  apiKey: 'ВАШ_API_КЛЮЧ',
  baseURL: 'https://api.kosareva.cloud/v1',
});

const response = await client.chat.completions.create({
  model: 'gpt-5-6',
  messages: [{ role: 'user', content: 'Привет!' }],
});
console.log(response.choices[0].message.content);
```

> Ключ лучше держать в переменной окружения, а не в коде: OpenAI SDK сам читает `OPENAI_API_KEY` и `OPENAI_BASE_URL`.

## Эндпоинты

Пути и форматы — как у OpenAI, поэтому подходят официальные SDK и любые клиенты, где можно поменять base URL. Модель выбирается полем `model` в каждом запросе, к ключу она не привязана.

| Что делает | Метод и путь | Модели |
|---|---|---|
| Чат, код, агенты | `POST /v1/chat/completions` | все текстовые модели каталога — сейчас их 105 |
| Responses API | `POST /v1/responses` | модели OpenAI; так работает, например, Codex CLI |
| Формат Anthropic | `POST /v1/messages` | модели Claude — сейчас их 13; base URL без `/v1` |
| Эмбеддинги | `POST /v1/embeddings` | `yandex-embeddings-doc`, `yandex-embeddings-query` и `gemini-embedding-2` |
| Генерация картинок | `POST /v1/images/generations` | 26 моделей, [таблица ниже](#изображения) |
| Правки картинок | `POST /v1/images/edits` | 13 моделей, [таблица ниже](#изображения) |
| Озвучка текста | `POST /v1/audio/speech` | `elevenlabs-turbo-2-5` и `elevenlabs-multilingual-v2` |
| Видео | `POST /v1/videos` | Veo, Kling, Seedance и другие видеомодели; задача, статус, mp4 — [раздел ниже](#видео) |
| Музыка | `POST /v1/music` | `suno-v6`, `suno-v6-mini`, `suno-v6-wild`; задача, статус, два mp3 |
| Распознавание речи | `POST /v1/audio/transcriptions` | `gemini-3-5-transcribe` |
| Список моделей | `GET /v1/models` | все, что доступны вашему ключу |
| Баланс, ключи, счета | `GET /api/v1/…` | на `kosareva.cloud`, а не на `api.` — [API личного кабинета](#api-личного-кабинета) |

> Видео и музыка — асинхронно: `POST /v1/videos` и `POST /v1/music` ставят задачу, статус и готовый файл забираются по её id. Запрос, который закончился ошибкой, не списывается ни на одном эндпоинте.

## Текст и код

Чат-запросы идут на `/v1/chat/completions`: те же `messages`, `tools`, `response_format` и `max_tokens`, что у OpenAI. Работает с любой из 105 текстовых моделей каталога.

### Потоковая выдача

С `stream: true` ответ приходит по кусочкам, как у OpenAI. Для длинных ответов это ещё и защита от таймаута: без потока ответ приходит целиком в конце, и клиент с коротким таймаутом может не дождаться.

```py
stream = client.chat.completions.create(
    model="gpt-5-6",
    messages=[{"role": "user", "content": "Объясни, что такое RAG, в трёх абзацах"}],
    stream=True,
)
for chunk in stream:
    if chunk.choices and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
```

### Формат Anthropic: Messages API

Для Anthropic SDK и инструментов на нём адрес — `https://api.kosareva.cloud` без `/v1`: путь `/v1/messages` SDK допишет сам. Через этот формат работают модели Claude из каталога, остальные модели подключайте через OpenAI-совместимый адрес.

```py
from anthropic import Anthropic

client = Anthropic(
    api_key="ВАШ_API_КЛЮЧ",
    base_url="https://api.kosareva.cloud",
)

message = client.messages.create(
    model="claude-sonnet-5-5",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Привет!"}],
)
print(message.content[0].text)
```

Claude Code настраивается переменными окружения `ANTHROPIC_BASE_URL` и `ANTHROPIC_AUTH_TOKEN` — пошагово на странице [Claude Code](https://kosareva.cloud/instrumenty/claude-code/).

### Responses API

Клиенты на Responses API — например, [Codex CLI](https://kosareva.cloud/instrumenty/codex-cli/) — работают по тому же адресу `https://api.kosareva.cloud/v1`, путь `/v1/responses`. Подходят модели OpenAI из каталога.

### Защита персональных данных

Если в запросах бывают ФИО, телефоны, ИНН или реквизиты, поменяйте адрес на `https://api.kosareva.cloud/guard/v1`: такие данные заменяются заглушками до отправки в модель, а в ответе возвращаются на место. Подробнее — на странице [API Guard](https://kosareva.cloud/api-guard/).

## Эмбеддинги

Векторы для поиска по смыслу, RAG и классификации считаются на `/v1/embeddings` тем же ключом. Поле `input` принимает строку или список строк: при индексации базы знаний отправляйте фрагменты пачками — один запрос вместо сотни.

```sh
curl https://api.kosareva.cloud/v1/embeddings \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"gemini-embedding-2","input":["Первый фрагмент","Второй фрагмент"]}'
```

| Модель | Имя в запросе | Вектор и фрагмент | За 1M токенов |
|---|---|---|---|
| [Yandex Embeddings Doc](https://kosareva.cloud/prices/yandex-embeddings-doc/) | `yandex-embeddings-doc` | 256 измерений, до 8192 токенов на фрагмент, для индексации документов | 14,14 ₽ |
| [Yandex Embeddings Query](https://kosareva.cloud/prices/yandex-embeddings-query/) | `yandex-embeddings-query` | 256 измерений, до 8192 токенов на фрагмент, для поисковых запросов | 14,14 ₽ |
| [Gemini Embedding 2](https://kosareva.cloud/prices/gemini-embedding-2/) | `gemini-embedding-2` | 3072 измерения, до 2048 токенов на фрагмент | 21,6 ₽ |

Ответ — массив `data`, в каждом элементе поле `embedding`. Векторы разных моделей несовместимы: сменили модель — переиндексируйте базу целиком. У Yandex две модели в паре: Doc для документов в базе, Query для поисковых запросов к ней. Как собрать поиск по своей базе целиком — в разборе [RAG-системы](https://kosareva.cloud/rag-sistema/).

## Изображения

Генерация — на `/v1/images/generations`, правки по исходнику — на `/v1/images/edits`. Цена у большинства моделей фиксирована за картинку и не зависит от размера; у GPT Image 2.5 — по токенам, как у самой модели.

### Генерация

```sh
curl https://api.kosareva.cloud/v1/images/generations \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-image-2","prompt":"Белые кроссовки на светлом фоне","n":1}'
```

### Правка по исходнику

Файл уходит в `multipart/form-data`, поле `image`. У апскейла и удаления фона `prompt` не нужен. Правка идёт дольше генерации — до 2 минут, поэтому таймаут HTTP-клиента ставьте от 180 секунд: с коротким клиент оборвёт запрос раньше, чем придёт картинка.

```sh
curl https://api.kosareva.cloud/v1/images/edits \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -F model="gpt-image-2" \
  -F image="@photo.png" \
  -F prompt="Замени фон на белый"
```

| Модель | Имя в запросе | Цена | Генерация | Правки |
|---|---|---|---|---|
| [Nano Banana 2](https://kosareva.cloud/prices/nano-banana-2/) | `nano-banana-2` | от 10,4 ₽ | да | — |
| [Nano Banana Pro (Gemini 3 Pro Image)](https://kosareva.cloud/prices/nano-banana-pro-gemini-3-pro-image/) | `nano-banana-pro-gemini-3-pro-image` | от 16 ₽ | да | да |
| [FLUX.1-schnell](https://kosareva.cloud/prices/flux-1-schnell/) | `flux-1-schnell` | от 1,4 ₽ | да | — |
| [GPT Image 2](https://kosareva.cloud/prices/gpt-image-2/) | `gpt-image-2` | от 4,5 ₽ | да | да |
| [GPT Image 2.5](https://kosareva.cloud/prices/gpt-image-2-5/) | `gpt-image-2-5` | около 6,7 ₽ | да | — |
| [Seedream 4.5](https://kosareva.cloud/prices/seedream-4-5/) | `seedream-4-5` | от 4,5 ₽ | да | да |
| [FLUX.2 Flex](https://kosareva.cloud/prices/flux-2-flex/) | `flux-2-flex` | от 13 ₽ | да | да |
| [FLUX.2 Pro](https://kosareva.cloud/prices/flux-2-pro/) | `flux-2-pro` | от 3,5 ₽ | да | да |
| [GPT Image 2.5 Sunburst](https://kosareva.cloud/prices/gpt-image-2-5-sunburst/) | `gpt-image-2-5-sunburst` | около 6,7 ₽ | да | — |
| [GPT Image 2.5 Flare](https://kosareva.cloud/prices/gpt-image-2-5-flare/) | `gpt-image-2-5-flare` | около 6,7 ₽ | да | — |
| [Imagen 4](https://kosareva.cloud/prices/imagen-4/) | `imagen-4` | от 9,7 ₽ | да | — |
| [Imagen 4 Fast](https://kosareva.cloud/prices/imagen-4-fast/) | `imagen-4-fast` | от 4,9 ₽ | да | — |
| [Imagen 4 Ultra](https://kosareva.cloud/prices/imagen-4-ultra/) | `imagen-4-ultra` | от 14,6 ₽ | да | — |
| [FLUX Kontext Pro](https://kosareva.cloud/prices/flux-kontext-pro/) | `flux-kontext-pro` | от 6,1 ₽ | да | — |
| [FLUX Kontext Max](https://kosareva.cloud/prices/flux-kontext-max/) | `flux-kontext-max` | от 12,2 ₽ | да | — |
| [Seedream 4.0](https://kosareva.cloud/prices/seedream-4-0/) | `seedream-4-0` | от 6,1 ₽ | да | — |
| [Seedream 5.0 Lite](https://kosareva.cloud/prices/seedream-5-0-lite/) | `seedream-5-0-lite` | от 6,7 ₽ | да | — |
| [Ideogram V3](https://kosareva.cloud/prices/ideogram-v3/) | `ideogram-v3` | от 6,5 ₽ | да | — |
| [Qwen Image 3.0](https://kosareva.cloud/prices/qwen-image-3-0/) | `qwen-image-3-0` | от 5,8 ₽ | да | — |
| [Qwen Image 3.0 Pro](https://kosareva.cloud/prices/qwen-image-3-0-pro/) | `qwen-image-3-0-pro` | от 7,8 ₽ | да | — |
| [Wan 2.7 Image](https://kosareva.cloud/prices/wan-2-7-image/) | `wan-2-7-image` | от 3,3 ₽ | да | да |
| [Wan 2.7 Image Pro](https://kosareva.cloud/prices/wan-2-7-image-pro/) | `wan-2-7-image-pro` | от 8,1 ₽ | да | да |
| [Z-Image Base](https://kosareva.cloud/prices/z-image-base/) | `z-image-base` | от 1 ₽ | да | — |
| [Gemini 2.5 Flash Image](https://kosareva.cloud/prices/gemini-2-5-flash-image/) | `gemini-2-5-flash-image` | от 4,9 ₽ | да | — |
| [Gemini 3.1 Flash-Lite Image](https://kosareva.cloud/prices/gemini-3-1-flash-lite-image/) | `gemini-3-1-flash-lite-image` | от 4,9 ₽ | да | — |
| [Grok Imagine Image 2.0](https://kosareva.cloud/prices/grok-imagine-image-2-0/) | `grok-imagine-image-2-0` | от 4,9 ₽ | да | — |
| [GPT Image 1.5](https://kosareva.cloud/prices/gpt-image-1-5/) | `gpt-image-1-5` | от 4,9 ₽ | — | да |
| [Seedream 5.0 Pro](https://kosareva.cloud/prices/seedream-5-0-pro/) | `seedream-5-0-pro` | от 8,5 ₽ | — | да |
| [Qwen Image 2.0](https://kosareva.cloud/prices/qwen-image-2-0/) | `qwen-image-2-0` | от 6,8 ₽ | — | да |
| [Topaz Image Upscale](https://kosareva.cloud/prices/topaz-image-upscale/) | `topaz-image-upscale` | от 12,2 ₽ | — | да |
| [Recraft Crisp Upscale](https://kosareva.cloud/prices/recraft-crisp-upscale/) | `recraft-crisp-upscale` | от 0,6 ₽ | — | да |
| [Recraft Remove Background](https://kosareva.cloud/prices/recraft-remove-background/) | `recraft-remove-background` | от 1,2 ₽ | — | да |

> Прочерк значит, что этот путь модель не принимает: запрос вернёт ошибку, денег за него не спишут. Цены за картинку — минимальные, у некоторых моделей крупный размер стоит дороже; точные условия — на странице модели. Обзор моделей и примеры — на странице [API генерации изображений](https://kosareva.cloud/api-generatsii-izobrazheniy/).

## Видео

Ролик по описанию или по вашей картинке — на `/v1/videos`, в форме видео-API OpenAI: задача, статус, готовый mp4. Цена ролика известна до запуска и списывается при постановке задачи; если модель не справилась, деньги возвращаются.

```sh
# 1. Поставить задачу — в ответе id и status
curl https://api.kosareva.cloud/v1/videos \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"seedance-2-mini","prompt":"Бариста рисует узор на латте, камера медленно наезжает","seconds":5,"resolution":"480p","aspect_ratio":"16:9"}'

# Ролик из картинки: input_reference станет первым кадром, last_frame — последним
curl https://api.kosareva.cloud/v1/videos \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"seedance-2-mini","prompt":"Камера облетает чашку","seconds":5,"resolution":"480p","input_reference":"https://example.com/first.jpg","last_frame":"https://example.com/last.jpg"}'

# 2. Спрашивать раз в 10–15 секунд, пока status не станет completed
curl https://api.kosareva.cloud/v1/videos/ID_ЗАДАЧИ \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ"

# 3. Скачать ролик
curl https://api.kosareva.cloud/v1/videos/ID_ЗАДАЧИ/content \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" -o video.mp4
```

```py
from openai import OpenAI

client = OpenAI(api_key="ВАШ_API_КЛЮЧ", base_url="https://api.kosareva.cloud/v1")

# Картинка файлом — так OpenAI SDK передаёт input_reference. SDK сам дождётся ролика.
video = client.videos.create_and_poll(
    model="seedance-2-mini",
    prompt="Бариста рисует узор на латте, камера медленно наезжает",
    seconds="5",
    input_reference=open("frame.jpg", "rb"),
)
if video.status == "failed":
    raise SystemExit(video.error.message)  # деньги за такой ролик возвращаются
client.videos.download_content(video.id).write_to_file("video.mp4")
```

| Поле | Что это | Ограничения |
|---|---|---|
| `model` | Видеомодель из [каталога](https://kosareva.cloud/prices/): Veo, Kling, Seedance, Hailuo, Grok Imagine, Wan, PixVerse | обязательно |
| `prompt` | Описание сцены: кто в кадре, что происходит, как движется камера | обязательно, до 5000 символов |
| `seconds`, `resolution`, `aspect_ratio` | Длительность, качество, формат кадра; вместо двух последних можно передать `size`, как у OpenAI | свои у каждой модели — на её карточке; значение не из списка заменяется ближайшим допустимым |
| `input_reference` | Картинка первого кадра: файл в `multipart/form-data`, ссылка https:// или строка `data:image/…;base64` | JPEG, PNG или WebP до 10 МБ; у Veo и Kling — JPEG и PNG. Нет у Seedance 1.5 Pro |
| `last_frame` | Картинка последнего кадра | только вместе с `input_reference`; нет у Kling 2.6, Kling 3.0 Turbo и Grok Imagine Video |
| `reference_images` | Список картинок-референсов: модель возьмёт из них внешность героя или предмета, но не сам кадр | Veo 3.1 Fast и Lite — до 3 (ролик всегда 8 секунд), Grok Imagine Video — до 7 (в 1080p одна), Seedance 2.x и Wan 3.0 — до 9; с кадрами в одном запросе не сочетается |

- Картинка на вход цену ролика не меняет. Если формат кадра не задан, он берётся по картинке. В ответе поле `input_images` показывает, какие картинки дошли до генерации.
- Картинку, которую модель не принимает, или файл не того формата сервер отклоняет с кодом 400 до списания — в тексте ошибки сказано, какие модели это умеют.
- Статус задачи — `queued`, `in_progress`, `completed` или `failed`, у готовой есть `content_url`. `GET /v1/videos` — последние 50 задач. При нехватке денег ответ 402 с ценой ролика и остатком.
- То же без кода — во вкладке «Видео» личного кабинета; картинку там пока не загрузить, ролик строится по тексту.

## Озвучка

Текст в речь — на `/v1/audio/speech`, как у OpenAI: `model`, `input` и `voice`. В ответ приходит файл mp3.

```sh
curl https://api.kosareva.cloud/v1/audio/speech \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"elevenlabs-turbo-2-5","input":"Добрый день! Это озвучка через API."}' \
  -o speech.mp3
```

```py
speech = client.audio.speech.create(
    model="elevenlabs-turbo-2-5",
    voice="EkK5I93UQWFDigLMpZcX",  # id голоса ElevenLabs, без него — голос по умолчанию
    input="Добрый день! Это озвучка через API.",
)
speech.write_to_file("speech.mp3")
```

| Модель | Имя в запросе | Для чего | За 1000 символов |
|---|---|---|---|
| [ElevenLabs Turbo 2.5](https://kosareva.cloud/prices/elevenlabs-turbo-2-5/) | `elevenlabs-turbo-2-5` | Быстрая озвучка текста: черновики, боты, длинные материалы | 14 ₽ |
| [ElevenLabs Multilingual v2](https://kosareva.cloud/prices/elevenlabs-multilingual-v2/) | `elevenlabs-multilingual-v2` | Качественная многоязычная озвучка для роликов и презентаций | 27 ₽ |

- В одном запросе — до 5000 символов, всё, что длиннее, обрезается. Длинный текст делите по абзацам.
- `voice` — id голоса из библиотеки ElevenLabs. Имена голосов OpenAI вроде `alloy` здесь не подходят.
- Формат ответа один — mp3: `response_format` и `speed` не учитываются.

## Музыка

Песня или инструментал по описанию — на `/v1/music`. Стандарта OpenAI для музыки нет, поэтому протокол свой, но устроен как у видео: задача → статус → файлы. Одна генерация даёт два варианта трека и стоит [26,40 ₽](https://kosareva.cloud/prices/suno/), обычно готова за 30–60 секунд.

```sh
# 1. Поставить задачу — в ответе id и status
curl https://api.kosareva.cloud/v1/music \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -H "Content-Type: application/json" \
  -d '{"model":"suno-v6","prompt":"Бодрая акустическая песня про поездку к морю","style":"инди-поп, укулеле"}'
# → {"id":"9f2c…","object":"music","status":"queued","price_rub":26.4,"tracks":[],…}

# 2. Спрашивать раз в 10–15 секунд, пока status не станет completed
curl https://api.kosareva.cloud/v1/music/ID_ЗАДАЧИ \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ"

# 3. Забрать оба трека: index=0 и index=1
curl "https://api.kosareva.cloud/v1/music/ID_ЗАДАЧИ/content?index=0" \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" -o track-1.mp3
curl "https://api.kosareva.cloud/v1/music/ID_ЗАДАЧИ/content?index=1" \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" -o track-2.mp3
```

```py
import time, requests

API = "https://api.kosareva.cloud/v1/music"
H = {"Authorization": "Bearer ВАШ_API_КЛЮЧ"}

job = requests.post(API, headers=H, json={
    "model": "suno-v6",
    "lyrics": "[Verse]\nУтро, море, тишина\n[Chorus]\nМы едем к морю",
    "style": "синти-поп, женский вокал",
    "title": "Море",
    "duration": 120,
}).json()
while job["status"] in ("queued", "in_progress"):
    time.sleep(15)
    job = requests.get(f"{API}/{job['id']}", headers=H).json()
for t in job["tracks"]:
    open(f"track-{t['index'] + 1}.mp3", "wb").write(requests.get(t["content_url"], headers=H).content)
```

| Поле | Что это | Ограничения |
|---|---|---|
| `model` | `suno-v6` — основная версия, естественный вокал; `suno-v6-mini` — лёгкая и быстрая; `suno-v6-wild` — смелее по звучанию | без поля — `suno-v6`; цена у всех одна |
| `prompt` | О чём трек; текст песни модель сочинит сама | до 3000 символов |
| `style` | Жанр, настроение, инструменты, голос | до 1000 символов |
| `lyrics` | Свой текст песни — поётся дословно; разметка `[Verse]`, `[Chorus]` | до 5000 символов |
| `title` | Название трека | до 80 символов |
| `instrumental` | `true` — без вокала | в своём режиме нужен `style` |
| `duration` | Желаемая длина в секундах; без неё длину выбирает модель | 10–360, включает свой режим |

- Режимов два. Простой — только `prompt` (и при желании `style`): модель сама пишет текст. Свой — если передан `lyrics`, `title` или `duration` (или `"custom_mode": true`): текст песни поётся как есть, а `prompt` без `lyrics` считается текстом песни.
- Ответ `GET /v1/music/{id}`: `status` — `queued`, `in_progress`, `completed` или `failed`; у готовой задачи в `tracks` два трека с `duration`, `title` и `content_url`. `GET /v1/music` — последние 20 задач, параметр `limit` — до 100.
- 26,40 ₽ списываются, когда задача принята в работу. Не получилось — деньги возвращаются на баланс сами, в ответе будет `error.refunded: true`. Пустой или неверно заполненный запрос отклоняется сразу с кодом 400 и ничего не стоит.
- Кому недоступно: юрлицам — в набор моделей для компаний музыка не входит; ключам с ограниченным списком моделей — нужен ключ без ограничений. Ответ в обоих случаях 403, денег не списывается.
- Оба трека мы сразу забираем к себе и по сроку не удаляем, поэтому `content_url` не протухает. Одновременно — до 5 незавершённых генераций на аккаунт, шестая получит 429. Свой трек или аудио на вход пока не принимаем — только текст.
- То же самое без кода — в личном кабинете: Чат → вкладка «Музыка».

## Распознавание речи

Аудиофайл в текст или субтитры — на `/v1/audio/transcriptions`, по тому же протоколу, что Whisper у OpenAI. Модель `gemini-3-5-transcribe`, 0,55 ₽ за минуту записи в среднем.

```sh
curl https://api.kosareva.cloud/v1/audio/transcriptions \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ" \
  -F model="gemini-3-5-transcribe" \
  -F file="@meeting.mp3"
```

Форматы ответа (`text`, `srt`, `vtt`, `verbose_json` с таймкодами слов), словарь терминов, ограничения по длине и разбор ошибок — [на отдельной странице](../speech-to-text/README.md).

## Список моделей

В каталоге 160 моделей, из них 105 текстовых. Точный список имён отдаёт сам API — это надёжнее любой страницы, включая эту.

```sh
curl https://api.kosareva.cloud/v1/models \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ"
```

| Модель | Имя в запросе | Контекст, токенов | Вход / выход за 1M |
|---|---|---|---|
| [Claude Sonnet 5.5](https://kosareva.cloud/prices/claude-sonnet-5-5/) | `claude-sonnet-5-5` | 1 000 000 | 216 / 1 080 ₽ |
| [Claude Opus 5.5](https://kosareva.cloud/prices/claude-opus-5-5/) | `claude-opus-5-5` | 1 000 000 | 432 / 2 160 ₽ |
| [GPT-6.1 Sol](https://kosareva.cloud/prices/gpt-6-1-sol/) | `gpt-6-1-sol` | 1 050 000 | 216 / 1 080 ₽ |
| [GPT-5.6](https://kosareva.cloud/prices/gpt-5-6/) | `gpt-5-6` | 1 050 000 | 432 / 2 160 ₽ |
| [Gemini 3.8 Flash](https://kosareva.cloud/prices/gemini-3-8-flash/) | `gemini-3-8-flash` | 1 048 576 | 81 / 405 ₽ |
| [Qwen3.8 Max](https://kosareva.cloud/prices/qwen3-8-max/) | `qwen3-8-max` | 1 000 000 | 216 / 648 ₽ |
| [DeepSeek V4.1 Flash](https://kosareva.cloud/prices/deepseek-v4-1-flash/) | `deepseek-v4-1-flash` | 1 048 576 | 32,4 / 130 ₽ |

> Все модели с ценами, контекстом и модальностями — на странице [цен](https://kosareva.cloud/prices/). Цена фиксирована в рублях и списывается по факту: токены запроса и ответа видны в поле `usage` и в расходах кабинета.

## API личного кабинета

Отдельный набор методов, чтобы забирать баланс, ключи и счета в свою систему: показывать остаток во внутренней панели или сверять расходы с бухгалтерией. Авторизация тем же ключом, что и для моделей, — второй секрет заводить не нужно.

```sh
curl https://kosareva.cloud/api/v1/balance \
  -H "Authorization: Bearer ВАШ_API_КЛЮЧ"
```

| Метод | Что возвращает |
|---|---|
| `GET /api/v1/me` | профиль: имя, почта, тип аккаунта, компания, ИНН, скидка в процентах |
| `GET /api/v1/balance` | пополнено, потрачено и остаток в рублях |
| `GET /api/v1/keys` | ключи: имя, маска и лимит в рублях — без самих секретов |
| `GET /api/v1/invoices` | счета: номер, сумма, статус, даты |
| `GET /api/v1/topups` | история пополнений |

Ответ `/api/v1/balance` выглядит так:

```json
{
  "currency": "RUB",
  "topped_up": 5000,
  "spent": 1243.51,
  "remaining": 3756.49
}
```

Все методы — только чтение и только ваши данные. Если ключ не передан или удалён, приходит `401` с пояснением в `error.message`. Пополнить баланс или создать ключ можно только в кабинете — так безопаснее, если ключ утечёт.

## Рекомендуемые модели

С чего начать, если модель ещё не выбрана. Все они работают по одному ключу, переключение — сменой поля `model`.

### [Claude Sonnet 5.5](https://kosareva.cloud/prices/claude-sonnet-5-5/) `claude-sonnet-5-5`

*Код и агенты*

Новое поколение Sonnet: окно на 1 000 000 токенов, вызов инструментов. Работает и через OpenAI SDK, и через Anthropic SDK.

### [GPT-6.1 Sol](https://kosareva.cloud/prices/gpt-6-1-sol/) `gpt-6-1-sol`

*Длинные документы*

Окно больше миллиона токенов, принимает картинки и файлы. Удобна, когда в запрос нужно положить логи, договор или спецификацию.

### [Gemini 3.8 Flash](https://kosareva.cloud/prices/gemini-3-8-flash/) `gemini-3-8-flash`

*Быстрые короткие ответы*

Отвечает быстро и стоит дешевле флагманов — для классификации, коротких ответов и потока однотипных запросов.

### [DeepSeek V4.1 Flash](https://kosareva.cloud/prices/deepseek-v4-1-flash/) `deepseek-v4-1-flash`

*Экономная*

Рассуждает перед ответом и понимает картинки, а стоит 32,4 ₽ за миллион входных токенов.

### [Gemini Embedding 2](https://kosareva.cloud/prices/gemini-embedding-2/) `gemini-embedding-2`

*Поиск по смыслу и RAG*

Векторы на 3072 измерения, фрагмент до 2048 токенов. Для базы знаний на русском и английском.

### [GPT Image 2](https://kosareva.cloud/prices/gpt-image-2/) `gpt-image-2`

*Картинки*

И генерация, и правки по исходнику, цена фиксирована за картинку и не зависит от размера.

## Устранение неполадок

Ошибки приходят в формате OpenAI, в `error.message` — объяснение по-русски. По нему и ищите свой случай; подробные разборы — в справочнике.

### 401: «Ключ не найден» или «Ключ не принят»

Ключ скопирован не целиком, с пробелом или переносом строки, удалён в кабинете — или передан не в том заголовке. Нужен `Authorization: Bearer ВАШ_API_КЛЮЧ`; в формате Anthropic подходит и `x-api-key`. Ключ OpenAI или Anthropic сюда не подходит — только ключ из нашего кабинета.

[Ошибка 401 API](https://kosareva.cloud/spravochnik/oshibka-401-api/) · [Invalid API key](https://kosareva.cloud/spravochnik/invalid-api-key/)

### 404: адрес без /v1 или с лишним хвостом

Базовый адрес для OpenAI SDK — ровно `https://api.kosareva.cloud/v1`: без `/v1` запрос уходит мимо API, а с `/chat/completions` на конце путь удваивается — SDK допишет его сам. Для Anthropic SDK наоборот: `https://api.kosareva.cloud` без `/v1`.

[Ошибка 404 API](https://kosareva.cloud/spravochnik/oshibka-404-api/) · [Что такое base URL](https://kosareva.cloud/spravochnik/openai-base-url/)

### «Такой модели нет в каталоге»

Имя модели — как в каталоге: латиницей через дефисы, например `claude-sonnet-5-5`. Вариант через точку шлюз поймёт сам, а с префиксом вендора (`anthropic/…`), датой версии или пробелом — нет. Точный список отдаёт `GET /v1/models`.

[Каталог моделей](https://kosareva.cloud/prices/)

### 402: «Закончились средства на балансе»

На балансе не хватает денег на запрос. Пополните его в [кабинете](https://kosareva.cloud/panel/) картой или СБП — от 50 ₽. Если деньги на балансе есть, а отказ повторяется, проверьте, не стоит ли у ключа свой лимит в рублях.

[Insufficient credits (402)](https://kosareva.cloud/spravochnik/insufficient-credits/)

### Ответ обрывается на полуслове

Модель упёрлась в потолок длины ответа — `max_tokens`. Поднимите его или попросите модель продолжить. Обратная ошибка — 400 «Запрос не помещается в контекст модели»: потолок ответа вместе с историей не влезает в окно модели. Тогда уменьшите `max_tokens` или сожмите историю.

[Ошибка 400 API](https://kosareva.cloud/spravochnik/oshibka-400-api/)

### 429: «Слишком много запросов подряд»

Сделайте паузу и повторите запрос, лучше с растущей задержкой. Если нагрузка постоянная, напишите нам — лимит поднимем.

[Rate limit exceeded](https://kosareva.cloud/spravochnik/rate-limit-exceeded/)

### Долго нет ответа или 504

Длинный ответ без потоковой выдачи идёт минутами, и клиент с коротким таймаутом может сдаться раньше модели: включите `stream` или поднимите таймаут. Если пришёл наш 504 «Модель не начала отвечать за отведённое время», деньги за такой запрос не списываются — повторите его.

[Таймаут и connection error](https://kosareva.cloud/spravochnik/api-timeout/) · [Ошибка 500 API](https://kosareva.cloud/spravochnik/oshibka-500-api/)

## Инструменты

Готовые инструкции для редакторов и агентов: где какое поле, какой адрес и какие модели подходят.

- [Claude Code](https://kosareva.cloud/instrumenty/claude-code/) — агент в терминале, формат Anthropic
- [Codex CLI](https://kosareva.cloud/instrumenty/codex-cli/) — агент OpenAI в терминале, Responses API
- [Cline](https://kosareva.cloud/instrumenty/cline/) и [Kilo Code](https://kosareva.cloud/instrumenty/kilo-code/) — агенты в VS Code
- [GitHub Copilot](https://kosareva.cloud/instrumenty/github-copilot/) — свои модели в чате VS Code
- [OpenCode](https://kosareva.cloud/instrumenty/opencode/) и [Zed](https://kosareva.cloud/instrumenty/zed/) — терминал и редактор
- [Hermes](https://kosareva.cloud/instrumenty/hermes/) и [OpenClaw](https://kosareva.cloud/instrumenty/openclaw/) — автономные агенты

> Все инструкции — в разделе [«Инструменты»](https://kosareva.cloud/instrumenty/). Подойдёт и любой другой клиент, где можно указать base URL для OpenAI.

## Частые вопросы

### Чем ваш API отличается от OpenAI API?

Форматом — ничем: те же пути, параметры, ответы и SDK. Отличаются адрес, ключ и имена моделей: у нас они латиницей через дефисы, как в каталоге, — `gpt-5-6`, а не `gpt-5.6`. И по одному ключу доступны модели разных вендоров, не только OpenAI.

### Нужен ли VPN?

Нет. API отвечает из России напрямую, оплата — в рублях.

### Как оплатить и какие документы будут?

Физлицам — картой или через СБП, от 50 ₽. Юрлицам — по счёту от 1 000 ₽, с договором и актом. Абонентской платы нет, деньги списываются с баланса по факту запросов.

### Списываются ли деньги за запросы с ошибкой?

Нет. Запрос, который закончился ошибкой, не списывается — в том числе наш 504, когда модель не начала отвечать за отведённое время.

### Можно ли ограничить расход одного ключа?

Да. Под каждый проект или сотрудника заведите свой ключ и задайте ему лимит в рублях. Расход по каждому ключу виден в кабинете и через [API кабинета](#api-личного-кабинета).

### Можно ли генерировать видео по API?

Да: `POST /v1/videos` ставит задачу, `GET /v1/videos/{id}` отдаёт статус, `GET /v1/videos/{id}/content` — готовый mp4. Формат как у видео-API OpenAI, модели и допустимые длительности — на карточках видеомоделей в [каталоге](https://kosareva.cloud/prices/). Ролик можно начать с картинки: `input_reference` — первый кадр, `last_frame` — последний, подробнее — в [разделе «Видео»](#видео).

### Подойдут LangChain, LlamaIndex, n8n и другие библиотеки?

Да, если в них можно указать base URL для OpenAI: подставьте `https://api.kosareva.cloud/v1` и свой ключ. Для клиентов в формате Anthropic — адрес без `/v1`.

### Где посмотреть, сколько стоил конкретный запрос?

В расходах личного кабинета. У текстовых моделей количество токенов приходит ещё и в поле `usage` ответа, а цена за миллион токенов — на странице модели в [каталоге](https://kosareva.cloud/prices/).
