# Open WebUI

Open WebUI — веб-чат, который вы ставите у себя. Своих моделей у него нет:
он работает с любым OpenAI-совместимым API по адресу и ключу.

## Подключение в интерфейсе

**Admin → Settings → Connections → OpenAI API**:

```text
OpenAI API base URL   https://api.kosareva.cloud/v1
API Key               ваш ключ из https://kosareva.cloud/panel/
```

Нажмите **Verify connection**, затем **Save**. После этого Open WebUI сам
запрашивает список моделей и показывает их в чате. В том же окне можно
перечислить только нужные модели, чтобы выпадающий список не был длинным.

## Подключение при запуске контейнера

Переменные `OPENAI_API_BASE_URL` и `OPENAI_API_KEY` задают подключение без
входа в настройки:

```sh
docker run -d -p 3000:8080 \
  -e OPENAI_API_BASE_URL=https://api.kosareva.cloud/v1 \
  -e OPENAI_API_KEY="$KOSAREVA_API_KEY" \
  -v open-webui:/app/backend/data \
  --name open-webui --restart always \
  ghcr.io/open-webui/open-webui:main
```

## Если список моделей пуст

- Адрес без `/v1` — сервер отвечает 404 на запрос списка моделей.
- Адрес с `/chat/completions` на конце — лишний хвост ломает и список, и запросы.
- Ключ не от этого сервера — ответ 401, Verify connection не проходит.
- Подключение выключено переключателем — проверьте его после обновления.

Проверить адрес и ключ с той же машины: `sh ../../../examples/curl/models.sh`.

Подробнее: https://kosareva.cloud/spravochnik/open-webui/
