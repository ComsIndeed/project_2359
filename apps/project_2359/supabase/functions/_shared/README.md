# Supabase Edge Functions — Shared Utilities

Stop writing boilerplate. Just write your logic.

## Quick Start — Creating a New Function

```ts
// supabase/functions/my-new-function/index.ts

import { serve, requireEnv } from "../_shared/mod.ts";

serve(async (_req, { user, json, ok, error }) => {
  // user is already verified — you can use user.id, user.email, etc.

  const { someField } = await json<{ someField: string }>();

  if (!someField) {
    return error("someField is required", 400);
  }

  // your logic here...

  return ok({ result: "success", userId: user.id });
});
```

That's it. **No CORS handling, no auth checks, no try/catch, no header juggling.**

## What `serve()` Does For You

| Concern                 | You write                  | `serve()` handles       |
| ----------------------- | -------------------------- | ----------------------- |
| CORS preflight          | nothing                    | ✅ auto                 |
| Auth (JWT verification) | nothing                    | ✅ auto (rejects 401)   |
| JSON body parsing       | `await json<T>()`          | ✅ typed helper         |
| SSE streaming           | `return stream(...)`       | ✅ SSE format + headers |
| Error responses         | `return error("msg", 400)` | ✅ JSON + CORS headers  |
| Success responses       | `return ok(data)`          | ✅ JSON + CORS headers  |
| Uncaught exceptions     | nothing                    | ✅ auto 500 response    |
| Env vars                | `requireEnv("KEY")`        | ✅ throws clear error   |

## Streaming Example (LLM, etc.)

```ts
import { serve, requireEnv } from "../_shared/mod.ts";
import Groq from "https://esm.sh/groq-sdk@0.8.0";

serve(async (_req, { json, stream, error }) => {
  const { input } = await json<{ input: string }>();
  if (!input) return error("input is required", 400);

  const groq = new Groq({ apiKey: requireEnv("GROQ_API_KEY") });

  const llmStream = await groq.chat.completions.create({
    model: "llama-3.1-8b-instant",
    messages: [{ role: "user", content: input }],
    stream: true,
  });

  return stream(async function* () {
    for await (const chunk of llmStream) {
      const content = chunk.choices[0]?.delta?.content;
      if (content) yield content;
    }
  });
});
```

## Public Endpoint (No Auth)

```ts
import { serve } from "../_shared/mod.ts";

serve(
  async (_req, { ok }) => {
    return ok({ status: "healthy", timestamp: new Date().toISOString() });
  },
  { requireAuth: false },
);
```

## Context Object Reference

Your handler receives `(req, ctx)` where `ctx` has:

- **`ctx.user`** — The authenticated `User` object (id, email, etc.)
- **`ctx.json<T>()`** — Parse request body as typed JSON
- **`ctx.ok(data, status?)`** — Return JSON success response
- **`ctx.error(message, status?)`** — Return JSON error response
- **`ctx.stream(generator)`** — Return SSE streaming response

## Config (config.toml)

For each new function, add this to `supabase/config.toml`:

```toml
[functions.my-new-function]
enabled = true
# Auth handled manually inside function via _shared/auth.ts
verify_jwt = false
```

## Environment Variables

Set `SB_PUBLISHABLE_KEY` as a Supabase secret for deployed functions:

```bash
supabase secrets set SB_PUBLISHABLE_KEY=sb_publishable_xxxxx
```

The shared auth module falls back to `SUPABASE_ANON_KEY` if the publishable key isn't set yet.
