// Supabase Edge Function: generate-material
// Accepts extracted texts + user preferences, streams study material generation
// (flashcards, MCQs, free-form questions) via DeepSeek using the OpenAI SDK.

import { requireEnv, serve } from "../_shared/mod.ts";
import OpenAI from "https://esm.sh/openai@4.78.1";

// ── Types ────────────────────────────────────────────────────────────────────

interface ExtractedText {
  sourceName: string;
  content: string;
}

interface RequestBody {
  extractedTexts: ExtractedText[];
  preferences: Record<string, string>;
}

// ── Prompt ───────────────────────────────────────────────────────────────────

const SYSTEM_PROMPT =
  `You are a study material generator. You will receive one or more source texts along with user preferences, and your job is to generate high-quality study materials based on them.

You can generate any combination of the following material types:
- **Flashcards**: A front (question/term) and back (answer/definition) pair.
- **Multiple-Choice Questions (MCQ)**: A question with 4 options (A–D), one correct answer, and a brief explanation.
- **Free-Form Questions**: An open-ended question with a model answer.

Guidelines:
- Only derive content from the provided source texts. Do not invent facts.
- Tailor the material type, difficulty, quantity, and focus according to the user preferences.
- Be thorough but concise — prioritize clarity and accuracy.
- You may produce mixed types unless preferences restrict you to one type.`;

function buildUserMessage(
  extractedTexts: ExtractedText[],
  preferences: Record<string, string>,
): string {
  const sourcesBlock = extractedTexts
    .map(
      ({ sourceName, content }, i) =>
        `--- Source ${i + 1}: ${sourceName} ---\n${content}`,
    )
    .join("\n\n");

  const prefsBlock = Object.entries(preferences)
    .map(([key, value]) => `${key}: ${value}`)
    .join("\n");

  return `## Source Texts\n\n${sourcesBlock}\n\n## User Preferences\n\n${prefsBlock}`;
}

// ── Handler ──────────────────────────────────────────────────────────────────

serve(async (_req, { json, stream, error }) => {
  const { extractedTexts, preferences } = await json<RequestBody>();

  if (!Array.isArray(extractedTexts) || extractedTexts.length === 0) {
    return error("'extractedTexts' must be a non-empty array.", 400);
  }

  if (!preferences || typeof preferences !== "object") {
    return error("'preferences' must be a map of strings.", 400);
  }

  const apiKey = requireEnv("DEEPSEEK_API_KEY");
  const client = new OpenAI({
    apiKey,
    baseURL: "https://api.deepseek.com/v1",
  });

  const llmStream = await client.chat.completions.create({
    model: "deepseek-reasoner",
    messages: [
      { role: "system", content: SYSTEM_PROMPT },
      { role: "user", content: buildUserMessage(extractedTexts, preferences) },
    ],
    stream: true,
    stream_options: { include_usage: true },
    temperature: 0.6,
  });

  return stream(async function* () {
    let usage: OpenAI.CompletionUsage | null = null;

    for await (const chunk of llmStream) {
      const content = chunk.choices[0]?.delta?.content;
      if (content) yield content;

      // The final chunk carries usage when stream_options.include_usage is set
      if (chunk.usage) usage = chunk.usage;
    }

    // After streaming is done, emit metadata as a special JSON event
    if (usage) {
      yield `\n[METADATA]:${
        JSON.stringify({
          inputTokens: usage.prompt_tokens,
          outputTokens: usage.completion_tokens,
          totalTokens: usage.total_tokens,
        })
      }`;
    }
  });
});
