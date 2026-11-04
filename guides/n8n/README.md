# n8n

В n8n шлюз подключается как обычный OpenAI: меняется только адрес.

1. **Credentials → New**, тип **OpenAI**.
2. Заполните два поля:

```text
API Key    ваш ключ из https://kosareva.cloud/panel/
Base URL   https://api.kosareva.cloud/v1
```

3. В ноде OpenAI выберите эти credentials из списка.
4. Имя модели берётся из каталога https://kosareva.cloud/prices/, через дефисы,
   например `deepseek-v4-flash` или `claude-sonnet-5`.

Под n8n удобно выпустить отдельный ключ с лимитом в рублях: расход сценариев
будет виден в кабинете отдельно от остального.

Если нода отвечает ошибкой, причину подскажет ответ: 401 означает ключ, 404
адрес, «Такой модели нет в каталоге» имя модели. Разбор кодов:
https://kosareva.cloud/spravochnik/kody-otvetov/
