# Kosareva Cloud: AI API for companies

Kosareva Cloud gives companies one API for more than 200 models in the OpenAI and Anthropic formats.

**We work only through the real vendor APIs and don't use ChatGPT, Claude Code or IDE subscriptions as an API channel.**

We work through a Russian sole proprietor or through an Armenian LLC, and you choose whichever suits you better. You pay in rubles by bank transfer. Data can be masked with API Guard before it reaches a model. If your team has no time for the integration, we can connect it or build a bot for the task.

The Russian version is the main one: [README.md](README.md). Most linked pages on kosareva.cloud are in Russian.

This page is for people responsible for engineering, purchasing or security who are deciding whether to let this API into their company. What we have comes with links and numbers. What we don't have sits in [its own section](#what-we-dont-have).

## Contents

- [Who this fits](#who-this-fits)
- [Contract, payment and documents](#contract-payment-and-documents)
- [Models and formats](#models-and-formats)
- [API Guard: data masking](#api-guard-data-masking)
- [Keys and spending control](#keys-and-spending-control)
- [Where data lives](#where-data-lives)
- [Integration and bot development](#integration-and-bot-development)
- [What backs up our experience](#what-backs-up-our-experience)
- [What we don't have](#what-we-dont-have)
- [How to start](#how-to-start)
- [Questions and answers](#questions-and-answers)
- [Company details and contact](#company-details-and-contact)

## Who this fits

It fits if your accountants need a contract and bank payment, your team runs several projects and people who need separate keys and limits, and you want to switch models by changing one line of code. It also fits if you want to test a use case with one bot in 1–2 weeks before changing any process.

It doesn't fit if you need a contract with the vendor itself. We don't offer that. See [What we don't have](#what-we-dont-have).

## Contract, payment and documents

We work through a Russian sole proprietor or through an Armenian LLC, and you choose whichever suits you better. Details of both are [at the bottom of this page](#company-details-and-contact). Before paying, write to ceo@kosareva.cloud about the option you prefer.

Terms of the [standard contract](https://kosareva.cloud/legal/dogovor-oferta/) with the LLC, edition of 2026-10-03: Armenian law, disputes at the ICAC at the Russian Chamber of Commerce, prepayment. The final edition is provided at signing.

| Payment method | Minimum |
|---|---|
| Russian bank card or SBP | 50 ₽ |
| Bank transfer by invoice | 1,000 ₽ |
| USD invoice | $50 |

We issue larger invoices on request. There's no subscription fee: the balance is charged for actual use, and the invoiced price equals the price in the [catalog](https://kosareva.cloud/prices/).

Under the offer, invoices and acts are provided in Russian and English as PDF by email, with paper originals on request. Under the offer, the act is issued at the end of the billing period and counts as accepted if there are no objections within 5 business days. If you choose the sole proprietor, we agree on the document set before payment. The customer's accountants assess the tax consequences. We sign NDAs.

## Models and formats

The catalog holds 210 entries as of 2026-11-23: text, images, video, embeddings, speech and music. They come from OpenAI, Anthropic, Google, xAI, DeepSeek, Moonshot AI, Qwen, MiniMax, GigaChat, YandexGPT and other vendors.

| Format | Address |
|---|---|
| OpenAI | `https://api.kosareva.cloud/v1` |
| Anthropic | `https://api.kosareva.cloud` |

One key works for both formats: OpenAI for text models, Anthropic for Claude models. Official SDKs and off-the-shelf tools work without code changes. Streaming, function calling, prompt caching and reasoning work where the model and the route support them. Details are in the [principles](../principles/README.en.md#1-vendor-formats). Connection steps for tools are in [examples](../guides/README.en.md).

If a model has a backup route, the request moves to it on failure.

## API Guard: data masking

A request to a foreign model sends text outside your perimeter. API Guard finds sensitive data in the request, replaces it with placeholders and restores it in the response, streaming included. The model sees `[[EMAIL_1]]`, and your code gets the real address.

You connect it by changing one address. The key and balance stay the same:

| SDK | Address |
|---|---|
| OpenAI, Chat Completions and Responses | `https://api.kosareva.cloud/guard/v1` |
| Anthropic | `https://api.kosareva.cloud/guard` |

Guard detects 22 data types:

- people: full name with patronymic or initials, email, phone, Russian passport, driver's license, SNILS;
- company and bank details: INN, OGRN and OGRNIP, bank account, card, CVV, IBAN, BIC;
- credentials: keys and tokens, private keys, connection strings, passwords;
- technical and vehicle data: IP, MAC, license plate, VIN, OSAGO.

Three more types turn on by header: date, URL and high-entropy string. Guard checks messages of all roles, tool arguments and results, and tool descriptions in the Chat Completions, Messages and Responses formats. The placeholder-to-original mapping lives only in the memory of a single request, and the log gets counters only.

Headers let you set types (`X-Guard-Types`), skip masking (`X-Guard-Off`), block a request instead of masking it (`X-Guard-Deny`) and block attachments (`X-Guard-Files`). `POST /guard/v1/guard/preview` shows the result without sending anything to a model.

We built Guard ourselves, and it sends no data to a third party for checking. More at [kosareva.cloud/api-guard/](https://kosareva.cloud/api-guard/).

## Keys and spending control

In the dashboard you can create separate keys for projects and employees, set a ruble limit on each and see spending per key. For personal data tasks there's a "Models in RF only" key, which works only with models in a Russian data center. Balance, keys, invoices and top-up history can be read through the [dashboard API](https://kosareva.cloud/docs/).

## Where data lives

The dashboard, user database, billing and usage logs sit in a Moscow data center. Request and response texts aren't written to our gateway's logs. What stays is the model, tokens, time and cost. This promise covers our gateway only, and we don't control logs further along the route. Images, video, music and speech have exceptions, listed in the [principles](../principles/README.en.md#4-data).

A request to a foreign model leaves Russia, which is a cross-border transfer under separate consent. The account owner gives that consent with a checkbox at sign-up. You are responsible as the data operator for your customers' and employees' data in requests, and that checkbox doesn't cover them. Models labeled "Model in RF" run in a Russian data center, and the request stays in the country.

The page [kosareva.cloud/legal/152-fz/](https://kosareva.cloud/legal/152-fz/) explains how this is built. It describes the service and doesn't replace your lawyer's conclusion.

## Integration and bot development

We help connect the API to your product and build a bot or agent for the task: sales assistant, support, knowledge base, document processing, call review, internal helper. We connect Telegram, MAX, a website widget, amoCRM, Bitrix24, 1C and Asterisk.

| Package | Price | Time |
|---|---|---|
| Start | 49,000 ₽ | 1–2 weeks |
| Business | 149,000 ₽ | 3–4 weeks |
| Corporate | from 349,000 ₽ | 5–8 weeks |

The price is one-off, and model usage is paid separately. Prices as of 2026-11-04, and we confirm terms before the contract. [Service description](https://kosareva.cloud/vnedrenie-ii/).

We start with a pilot of 1–2 weeks and agree in advance what to measure: for example, the share of tickets closed without an operator, or correct answers on 50 of your real questions.

## What backs up our experience

We don't name customers, and there are no big implementation numbers here. What we built, you can check yourself:

- **Gateway.** Our gateway sits in front of the model. It fixes common request errors, translates error messages into Russian, watches for the first byte of a response and moves the request to a backup route on failure, if one exists.
- **API Guard.** The masking described above.
- **Support bot on a knowledge base.** It answers in the chat on our website.
- **VS Code extension.** [Published on the Marketplace](https://marketplace.visualstudio.com/items?itemName=kosareva-cloud.kosareva-cloud), it gives models to the editor's native chat.
- **[Skills](https://kosareva.cloud/skills/) and the [error handbook](https://kosareva.cloud/spravochnik/).** Open on the site with no sign-up.

## What we don't have

- A direct contract between you and the vendor: your contract is with us.
- A public list of channels: for a contract with a data processing assignment, we'll discuss terms before signing.
- Batch API.
- English documentation: `/docs/` is in Russian only.

## How to start

1. Sign up in the [dashboard](https://kosareva.cloud/panel/) with email, Yandex ID or VK ID. You can issue a key right away.
2. Top up: from 50 ₽ by card or SBP, from 1,000 ₽ by invoice.
3. Send your first request using the [guide](../guides/README.en.md).
4. If you need an integration or a bot, write to ceo@kosareva.cloud about what you want to automate, and we'll suggest a pilot.

## Questions and answers

### What is Kosareva Cloud?

Kosareva Cloud is an API for companies and developers: one key for more than 200 models, OpenAI and Anthropic formats, ruble billing. The company is registered as "Kosareva Cloud" LLC in the Republic of Armenia.

### Who does Kosareva Cloud sign the contract with?

Kosareva Cloud works through a Russian sole proprietor or through an Armenian LLC, and you choose whichever suits you better. The LLC has tax number 03038101 and a standard contract of 2026-10-03: Armenian law applies, disputes go to the ICAC at the Russian Chamber of Commerce, and the final edition is provided at signing. Details of both are [at the bottom of this page](#company-details-and-contact).

### How does a company pay Kosareva Cloud?

By bank transfer in rubles from 1,000 ₽. Companies outside Russia can use a USD invoice from $50. There's no subscription fee, and the balance is charged for actual use.

### What documents will accountants get?

Under the offer, Kosareva Cloud provides the contract, an invoice and an act in Russian and English, as PDF by email, with paper originals on request. If you choose the sole proprietor, we agree on the document set before payment. The customer's accountants assess the tax consequences.

### Where does Kosareva Cloud store data, and what goes into logs?

The dashboard, billing and usage logs sit in a Moscow data center. Gateway logs keep the model, tokens, time and cost, with no request or response text, and the exceptions for media are in the principles. A request to a foreign model leaves Russia, the customer is responsible as the data operator for its customers' and employees' data in requests, and models labeled "Model in RF" run in a Russian data center.

### Is Kosareva Cloud compliant with 152-FZ?

Kosareva Cloud doesn't make that general claim. The [152-FZ page](https://kosareva.cloud/legal/152-fz/) describes where data lives, what is stored and how cross-border transfer works. For personal data tasks there's API Guard and the "Models in RF only" key, and your lawyer assesses how this applies to your case.

### Do I have to change code to enable API Guard?

No, with API Guard from Kosareva Cloud you change one address: `https://api.kosareva.cloud/guard/v1` instead of `https://api.kosareva.cloud/v1` for the OpenAI SDK, `https://api.kosareva.cloud/guard` for the Anthropic SDK. The key and balance stay the same. Guard detects 22 data types.

### Does Kosareva Cloud work through the real vendor APIs?

Yes. Kosareva Cloud works only through the real vendor APIs and doesn't use ChatGPT, Claude Code or IDE subscriptions as an API channel. Our gateway sits between your code and the model, and from there the request runs through our channels. Kosareva Cloud has no public list of channels. Details are in the [principles](../principles/README.en.md#2-real-vendor-apis-only), along with what works and what doesn't.

### What availability does Kosareva Cloud offer?

Kosareva Cloud promises 99.98 % availability. If a model has a backup route, the request moves to it on failure. We'll discuss what matters for your project before the contract.

### How much does a bot cost, and how fast will it be ready?

A pilot takes 1–2 weeks. Kosareva Cloud packages start at 49,000 ₽ one-off, and model usage is paid separately. We price a voice robot after reviewing your calls.

## Company details and contact

"Kosareva Cloud" LLC, Republic of Armenia, Kotayk region, Charentsavan. Tax number 03038101, state registration 56804995. Founder and CEO: Veronika Kosareva.

Sole proprietor Veronika Kosareva, Russia. INN 973301093980, OGRNIP 325774600567846.

[kosareva.cloud](https://kosareva.cloud) · ceo@kosareva.cloud · Telegram [@kosareva_cloud](https://t.me/kosareva_cloud) · +7 995 154-15-35. We reply on a business day.
