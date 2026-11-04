# Kosareva Cloud principles

Edition of 2026-11-04. The Russian version is the main one: [README.md](README.md).

Kosareva Cloud provides companies and developers with one API for models from OpenAI, Anthropic, Google, xAI, DeepSeek, Moonshot AI, Qwen, MiniMax, GigaChat, YandexGPT and other vendors. We work only through the real vendor APIs and don't use ChatGPT, Claude Code or IDE subscriptions as an API channel. This page records what we promise, how it's built, and how you can check it yourself. Everything we don't have is collected in its own section.

## Contents

1. [Vendor formats](#1-vendor-formats)
2. [Real vendor APIs only](#2-real-vendor-apis-only)
3. [Prices are public](#3-prices-are-public)
4. [Data](#4-data)
5. [Documents](#5-documents)
6. [Errors you can read](#6-errors-you-can-read)
7. [What we don't have](#what-we-dont-have)
8. [Questions and answers](#questions-and-answers)

## 1. Vendor formats

We work in the vendors' formats: OpenAI Chat Completions and Responses, Anthropic Messages. Official SDKs and off-the-shelf tools fit, and only the address and key change.

For models with function calling: if the model has its own search, that search runs. If it doesn't, our gateway performs the call, and a streamed response arrives in one piece when ready. GPT 5.4 and newer with `reasoning_effort` get no search in chat and need the Responses API. Gateway search is limited to five searches per request. Gateway page reading returns up to 20,000 characters, with no PDFs and no password-protected pages.

If a model has a backup route, the request moves to it on failure.

`GET https://api.kosareva.cloud/v1/models` with your key lists the catalog, and you can test any feature with a request to your model. Our live tests of search and tools ran from 2026-10-19 to 2026-10-22.

## 2. Real vendor APIs only

**We work only through the real vendor APIs and don't use ChatGPT, Claude Code or IDE subscriptions as an API channel.**

Our gateway sits between your code and the model, and from there the request runs through our channels. If a model has a backup route, the request moves to it on failure. Customers can't pick a specific channel. There's no public list of channels. For a contract with a data processing assignment, we'll discuss terms before signing.

## 3. Prices are public

Prices are listed in rubles on each model's page. There's no subscription fee: you pay for actual tokens, images, characters, clips or tracks, depending on the model. On most models, web search is billed separately per call. Under the public offer, the invoiced price equals the published price.

Spending is visible per key in the dashboard. You can set a ruble limit on a key.

You can check prices with no key and no sign-up:

```sh
curl -s https://kosareva.cloud/panel/api/price-catalog
```

The response lists the whole catalog with ruble prices.

## 4. Data

The dashboard, user database, billing and usage logs sit on a server in a Moscow data center.

Request and response texts aren't written to our gateway's logs. What stays is the model, token count, time and cost. The exceptions: images from the dashboard's built-in chat are kept with the request text for up to 180 days or until you delete them. Video and music, including those created through the API, and speech from the dashboard are kept in the dashboard database with the first 1,000 characters of the request, with no retention limit. Images the API returns as a link may stay on our server for a day. Backups of the dashboard database are kept for 14 days.

A request to a foreign model leaves Russia. This is a cross-border transfer under separate consent. The account owner gives that consent with a checkbox at sign-up. You are responsible as the data operator for your customers' and employees' data in requests, and that checkbox doesn't cover them. Models labeled "Model in RF" run in a Russian data center, and the request stays in the country. A "Models in RF only" key restricts access to them and is available to all customers.

If data does go to a foreign model, you can mask it. API Guard replaces 22 data types with placeholders before sending and restores them in the response. The placeholder-to-original mapping lives only in the memory of a single request. To turn it on, change the address to `https://api.kosareva.cloud/guard/v1`, or `https://api.kosareva.cloud/guard` for the Anthropic SDK. The regular `/v1` has no masking.

The [152-FZ page](https://kosareva.cloud/legal/152-fz/) (in Russian) describes how the service is built under Russia's personal data law, and conclusions are for your lawyer.

You can test Guard without calling a model: `POST https://api.kosareva.cloud/guard/v1/guard/preview` with your key and a regular request body shows what was found and how the text looks after masking.

## 5. Documents

We work through a Russian sole proprietor or through an Armenian LLC, and you choose whichever suits you better. Details of both are on the [page for companies](../business/README.en.md#company-details-and-contact). Before paying, write to ceo@kosareva.cloud about the option you prefer.

Terms of the [standard contract](https://kosareva.cloud/legal/dogovor-oferta/) (in Russian) with "Kosareva Cloud" LLC, Republic of Armenia, tax number 03038101, edition of 2026-10-03: Armenian law, disputes at the ICAC at the Russian Chamber of Commerce, prepayment. The final edition is provided at signing.

Under the offer, invoices and acts are provided in Russian and English as PDF by email, with paper originals on request. Under the offer, the act is issued at the end of the billing period and counts as accepted if there are no objections within 5 business days. If you choose the sole proprietor, we agree on the document set before payment. The customer's accountants assess the tax consequences. We sign NDAs.

## 6. Errors you can read

The gateway translates error responses into Russian and adds a hint about what to do. Codes are explained in the [handbook](https://kosareva.cloud/spravochnik/kody-otvetov/) (in Russian).

Checking is free: a request with no key returns `401` with a message in Russian that says the key wasn't recognized and what to check.

```sh
curl -s https://api.kosareva.cloud/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-v4-flash","messages":[{"role":"user","content":"hi"}]}'
```

## What we don't have

- Batch API.
- Channel choice for customers, or a public list of channels.
- English documentation: `/docs/` on the site is in Russian only.

## Questions and answers

### Which vendor features does Kosareva Cloud not support?

Kosareva Cloud doesn't support the Batch API.

### Where does Kosareva Cloud store data?

The Kosareva Cloud dashboard, user database, billing and usage logs sit in a Moscow data center. Request and response texts aren't written to the gateway's logs, and the exceptions for images, video, music and speech are listed in the [Data section](#4-data). A request to a foreign model leaves Russia.

### How can I see Kosareva Cloud prices without signing up?

Kosareva Cloud ruble prices are open at [kosareva.cloud/prices/](https://kosareva.cloud/prices/) and as JSON at `https://kosareva.cloud/panel/api/price-catalog`. You need no key and no sign-up.

If you find a gap between this text and how the API behaves, write to ceo@kosareva.cloud or Telegram [@kosareva_cloud](https://t.me/kosareva_cloud). We'll fix the document or the service and update the edition date.
