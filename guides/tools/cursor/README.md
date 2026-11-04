# Cursor

Сначала оговорка. С 4–5 сентября 2026 Cursor отвечает пользователям из России `not available in your region`. Закрыто его собственное облако: вход в аккаунт, автодополнение Tab, агент и индексация проекта. Наш ключ их не откроет, потому что подмена адреса влияет только на часть чата.

Если Cursor у вас не открывается, настройка ниже не поможет. Подойдут инструменты без чужого облака: [Cline](../cline/README.md), [расширение для VS Code](../vscode/README.md) или разбор на странице [«Cursor не работает»](https://kosareva.cloud/cursor-ne-rabotaet/).

## Если Cursor открывается

1. Откройте настройки (`Ctrl/Cmd + Shift + J`) и перейдите в раздел моделей.
2. Вставьте ключ в поле **OpenAI API Key**, включите **Override OpenAI Base URL** и укажите:

```text
https://api.kosareva.cloud/v1
```

3. Нажмите **Verify**.
4. Добавьте имя модели из [каталога](https://kosareva.cloud/prices/), например `claude-sonnet-5` или `deepseek-v4-flash`, и выберите её в чате.

При своём ключе Cursor перестаёт расходовать лимиты подписки, деньги идут с баланса Kosareva Cloud. Запросы он отправляет в формате OpenAI Chat Completions.

Полная инструкция: https://kosareva.cloud/instrumenty/cursor/
