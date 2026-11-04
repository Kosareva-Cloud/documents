# AGENTS.md

Rules for coding agents working with this repository or connecting a project to the Kosareva Cloud API.

## Addresses

- OpenAI SDK, curl, OpenAI-compatible tools: `https://api.kosareva.cloud/v1`.
- Anthropic SDK and Claude Code: `https://api.kosareva.cloud` with no `/v1`. The SDK appends `/v1/messages` itself, and adding `/v1` here breaks the path. This format works with Claude models. Connect other models through the OpenAI address.
- API Guard: `https://api.kosareva.cloud/guard/v1` for the OpenAI SDK, `https://api.kosareva.cloud/guard` for the Anthropic SDK.
- Dashboard API (balance, keys, invoices): `https://kosareva.cloud/api/v1/`.

## Keys

- Read the key from the `KOSAREVA_API_KEY` environment variable.
- Never write a key into code, configs, examples or commit messages.
- If a key reaches a repository, tell the user to revoke it in https://kosareva.cloud/panel/ and issue a new one.

## Model names

- Take names from `GET /v1/models` (key required) or https://kosareva.cloud/panel/api/price-catalog (no key). Don't copy names from memory: models change.
- Names use hyphens, as in the model page URL: `claude-sonnet-5-5`, not `claude-sonnet-5.5`.

## Costs

- Every request to a model spends the user's balance. Ask before running live examples or loops.
- `examples/curl/models.sh` checks a key without calling a model.

## Limits to respect

- No Batch API, `/v1/files`, vector stores or `file_search`. Don't generate code that relies on them.
- In `/v1/chat/completions`, GPT 5.4 and newer don't accept functions together with `reasoning_effort`. Use `/v1/responses`.
- Masking works only on the `/guard` addresses. The regular `/v1` has no masking.
- Feature support by model: principles/README.en.md

## Repository layout

- `guides/`: connection guide, API reference and speech-to-text guide.
- `guides/tools/`: configs for tools, one folder per tool.
- `guides/n8n/README.md`: n8n credentials setup.
- `examples/python/`, `examples/node/`, `examples/curl/`: minimal examples.
- `principles/`, `business/`: how we work and the page for companies.

Comments and user-facing strings in this repository are in Russian. Keep them in Russian when editing.
