# Kosareva Cloud: connecting to the API

Kosareva Cloud gives companies and developers one API for more than 170 models from OpenAI, Anthropic, Google, xAI, DeepSeek and other vendors in the OpenAI and Anthropic formats, with ruble billing. Official SDKs and off-the-shelf tools work without code changes: only the address and key change.

The Russian version is the main one: [README.md](README.md). Most linked pages on kosareva.cloud are in Russian, and comments inside the example files are in Russian too.

[What you get](#what-you-get) · [First request](#first-request-in-three-steps) · [Addresses](#addresses) · [Tools](#tool-setup) · [Code](#code-examples) · [More endpoints](#what-else-the-api-does) · [Models](#model-catalog) · [Companies](#for-companies) · [Errors](#if-something-doesnt-work) · [What's missing](#whats-not-here) · [Questions](#questions-and-answers)

## What you get

| Task | How it works |
|---|---|
| Keep one key instead of several | One key works with every catalog model: the OpenAI format for text models, the Anthropic format for Claude models, and images, video, speech and music through their own paths |
| Pay in rubles | Russian bank card or SBP from 50 ₽, by invoice from 1,000 ₽, no subscription fee |
| Split spending by project | A separate key per project or employee, a ruble limit, spending per key |
| Keep your code | Change `base_url` and the key, the SDK stays the same |
| Mask part of the personal data before it reaches a model | [API Guard](https://kosareva.cloud/api-guard/) connects by changing the address and replaces 22 data types with placeholders. It doesn't detect addresses or company names |
| Connect a company | Contract, invoice and act: [page for companies](../business/README.en.md) |

## First request in three steps

**1. Create a key.** Sign up in the [dashboard](https://kosareva.cloud/panel/) with email, Yandex ID or VK ID and issue a key. Save it in a password manager: a key created since 2026-09-15 can be copied again in the dashboard.

**2. Top up.** By Russian bank card or SBP from 50 ₽, companies by invoice from 1,000 ₽.

**3. Send a request.**

```sh
export KOSAREVA_API_KEY="sk-..."

curl https://api.kosareva.cloud/v1/chat/completions \
  -H "Authorization: Bearer $KOSAREVA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-v4-flash","messages":[{"role":"user","content":"How is a process different from a thread?"}]}'
```

In PowerShell, run [`examples/python/chat.py`](../examples/python/chat.py) or send the request from Git Bash.

Each request like this spends tokens at the model's price. To check a key without calling a model, list the models: [`examples/curl/models.sh`](../examples/curl/models.sh).

## Addresses

| What you connect | Address | How the key is sent |
|---|---|---|
| OpenAI SDK, cURL, tools using the OpenAI format | `https://api.kosareva.cloud/v1` | `Authorization: Bearer <key>` |
| Anthropic SDK | `https://api.kosareva.cloud` without `/v1`, the SDK adds the path | `x-api-key: <key>` |
| Claude Code | `https://api.kosareva.cloud` without `/v1` | `Authorization: Bearer <key>`, set through `ANTHROPIC_AUTH_TOKEN` |
| API Guard, OpenAI SDK | `https://api.kosareva.cloud/guard/v1` | same key |
| API Guard, Anthropic SDK | `https://api.kosareva.cloud/guard` | same key |

One key works for all four addresses.

## Tool setup

| Tool | What to do | File |
|---|---|---|
| VS Code extension | install from the Marketplace, enter the key | [`tools/vscode/README.md`](tools/vscode/README.md) |
| Claude Code | set environment variables | [`tools/claude-code/README.md`](tools/claude-code/README.md) |
| Codex CLI | put the config in `~/.codex/config.toml` | [`tools/codex-cli/config.toml`](tools/codex-cli/config.toml) |
| Continue | put the config in `~/.continue/config.yaml` | [`tools/continue/config.yaml`](tools/continue/config.yaml) |
| Cline | fill three fields in settings | [`tools/cline/README.md`](tools/cline/README.md) |
| Kilo Code | fill in the provider and context size | [`tools/kilo-code/README.md`](tools/kilo-code/README.md) |
| opencode | add `opencode.json` | [`tools/opencode/opencode.json`](tools/opencode/opencode.json) |
| Zed | paste the fragment into `settings.json` | [`tools/zed/settings.json`](tools/zed/settings.json) |
| GitHub Copilot, VS Code chat | add a Custom Endpoint | [`tools/github-copilot/chatLanguageModels.json`](tools/github-copilot/chatLanguageModels.json) |
| Open WebUI | fill in Connections or set container variables | [`tools/open-webui/README.md`](tools/open-webui/README.md) |
| n8n | create OpenAI-type credentials | [`n8n/README.md`](n8n/README.md) |
| Cursor | read the caveat first | [`tools/cursor/README.md`](tools/cursor/README.md) |
| Hermes Agent, OpenClaw | guides on the site | [Hermes](https://kosareva.cloud/instrumenty/hermes/), [OpenClaw](https://kosareva.cloud/instrumenty/openclaw/) |

### VS Code extension

`Ctrl+Shift+X`, search for `kosareva`, Install. Then `Ctrl+Shift+P` → "kosareva.cloud: Подключить ключ". In the chat model list, click **Add Models → kosareva.cloud** and tick the models you need. Without this step, models won't appear in chat.

### Claude Code

```sh
export ANTHROPIC_BASE_URL="https://api.kosareva.cloud"
export ANTHROPIC_AUTH_TOKEN="$KOSAREVA_API_KEY"
```

The address has no `/v1`. Run `claude` in the same terminal. To keep the variables, add these lines to `~/.zshrc` or `~/.bashrc`. The PowerShell variant is in the [file](tools/claude-code/README.md).

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

Codex uses the Responses API, so pick OpenAI models.

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

`provider: openai` applies to Claude too: it names the protocol format, not the vendor. Continue is no longer developed, so new users are better off with Cline or Kilo Code.

### Cline

In settings, choose **API Provider → OpenAI Compatible**:

```text
Base URL   https://api.kosareva.cloud/v1
API Key    your key
Model ID   claude-sonnet-5
```

### Kilo Code

**Providers → Custom provider**, type **OpenAI Compatible**, address `https://api.kosareva.cloud/v1`. Set the context size in `~/.config/kilo/kilo.jsonc`, otherwise Kilo won't compress history. See the [file](tools/kilo-code/README.md).

### opencode

Put [`opencode.json`](tools/opencode/opencode.json) in `~/.config/opencode/` or the project root. The key is read from `KOSAREVA_API_KEY`.

### Zed

Paste the [fragment](tools/zed/settings.json) into `settings.json`. Zed asks for the key in the provider UI.

### GitHub Copilot, VS Code chat

**Chat: Manage Language Models → Add Models → Custom Endpoint**, type Chat Completions. VS Code opens a file where you paste [this config](tools/github-copilot/chatLanguageModels.json).

### Open WebUI

**Admin → Settings → Connections → OpenAI API**, address `https://api.kosareva.cloud/v1`, key from the dashboard. The container variant is in the [file](tools/open-webui/README.md).

### n8n

**Credentials → New**, type **OpenAI**, Base URL `https://api.kosareva.cloud/v1`. A separate key with a limit works well for n8n.

### Cursor

Our key doesn't lift the Cursor block: Cursor's own cloud is closed. Details in the [file](tools/cursor/README.md).

## Code examples

Each run is a real request, and tokens are charged to your balance. The key comes from the `KOSAREVA_API_KEY` variable.

| Language | Files |
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
node chat.mjs                              # or: node --env-file=../.env chat.mjs
```

**curl**:

```sh
sh examples/curl/models.sh
sh examples/curl/chat.sh
```

You can also keep the key in a file: `cp examples/.env.example examples/.env`, then `set -a; . examples/.env; set +a`.

With `stream: true`, the response arrives as SSE events during generation. SDKs parse them for you, and in curl you see the raw stream up to `data: [DONE]`.

### API Guard in code

Only the address changes, and the response arrives with the real data:

```python
from openai import OpenAI

client = OpenAI(api_key="sk-...", base_url="https://api.kosareva.cloud/guard/v1")
```

The regular `/v1` has no masking. What Guard detects and misses is on the [API Guard page](https://kosareva.cloud/api-guard/).

## What else the API does

| What | Path from `https://api.kosareva.cloud` |
|---|---|
| Chat, OpenAI format | `POST /v1/chat/completions` |
| Responses API | `POST /v1/responses` |
| Messages, Anthropic format | `POST /v1/messages` |
| Embeddings | `POST /v1/embeddings` |
| Images | `POST /v1/images/generations`, `POST /v1/images/edits` |
| Text to speech | `POST /v1/audio/speech` |
| Speech to text | `POST /v1/audio/transcriptions` |
| Video, background job | `/v1/videos` |
| Music, background job | `/v1/music` |
| Model list | `GET /v1/models` |

Parameters are in the [documentation](https://kosareva.cloud/docs/). Balance, keys and invoices are read through a separate dashboard API at `https://kosareva.cloud/api/v1/`, not on `api.`.

Streaming, function calling, prompt caching and reasoning work where the model and the route support them. Details, including web search, are in the [principles](../principles/README.en.md#1-vendor-formats).

## Model catalog

Names and ruble prices: [kosareva.cloud/prices/](https://kosareva.cloud/prices/). Programs can use JSON with no key, or `/v1/models` with a key:

```sh
curl -s https://kosareva.cloud/panel/api/price-catalog
```

In code, take names from these sources instead of a hand-written list, because models change. Names use hyphens, as in the model page URL: `claude-sonnet-5-5`, `gpt-6-1-terra`, `gemini-3-8-flash`.

Rules for coding agents are in [AGENTS.md](../AGENTS.md).

## For companies

We work only through the real vendor APIs and don't use ChatGPT, Claude Code or IDE subscriptions as an API channel. We work through a Russian sole proprietor or through an Armenian LLC, and you choose whichever suits you better. Payment is by invoice in rubles from 1,000 ₽. Separate keys for projects and employees, API Guard, integration help and bot development are on the [page for companies](../business/README.en.md).

## Security

- The dashboard database keeps a sha256 hash of the key and an encrypted copy: the copy lets the dashboard fill the key into the quick start and copy it again. Keys created before 2026-09-15 can't be copied.
- Keep the key in an environment variable or `.env`, which is already in `.gitignore`.
- Don't put the key in code or in configs that reach a repository. Treat a key found in a public repository as leaked: revoke it in the dashboard and issue a new one.
- Give each project its own key with a ruble limit, so a leaked key is capped by that limit.

To report a vulnerability: [SECURITY.md](https://github.com/Kosareva-Cloud/.github/blob/main/SECURITY.md).

## If something doesn't work

- **401.** The key wasn't accepted: empty variable, typo, revoked key.
- **404.** Wrong address: the OpenAI format needs `/v1` at the end, the Anthropic format doesn't.
- **"No such model in the catalog".** Code `model_not_found`: copy the name from the model page or take it from `GET /v1/models`.
- **Zero balance** blocks requests. Top up in the dashboard.

Response codes and what to do about them: [handbook](https://kosareva.cloud/spravochnik/).

## What's not here

- A one-line installer: setup comes down to an address and a key.
- A free mode in the examples: running them spends your balance.
- Examples with retries on temporary errors, function calling, images, video or speech: only basic text requests are here.
- A ready-made n8n workflow, only credentials setup.
- Batch API. Full list in the [principles](../principles/README.en.md#what-we-dont-have).

## Questions and answers

### What is the Kosareva Cloud base URL for the OpenAI SDK?

For the OpenAI SDK and tools using the OpenAI format, the Kosareva Cloud base URL is `https://api.kosareva.cloud/v1`. The key goes in the `Authorization: Bearer` header.

### What is the Kosareva Cloud address for the Anthropic SDK and Claude Code?

For the Anthropic SDK and Claude Code, the Kosareva Cloud address is `https://api.kosareva.cloud` with no `/v1`: the client appends `/v1/messages` itself. This format works with Claude models, and other models connect through the OpenAI address.

### How do I check a Kosareva Cloud key without a paid request?

List the Kosareva Cloud models: `GET https://api.kosareva.cloud/v1/models` with your key. The request doesn't call a model or spend your balance, and [`examples/curl/models.sh`](../examples/curl/models.sh) does it for you.

## Contact

ceo@kosareva.cloud · Telegram [@kosareva_cloud](https://t.me/kosareva_cloud)

## License

[MIT](../LICENSE)
