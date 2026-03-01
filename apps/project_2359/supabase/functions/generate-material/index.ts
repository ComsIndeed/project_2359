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

const SYSTEM_PROMPT = `# General Instruction
Generate a list of study materials from the provided sources and information.

# Format
Must be in JSON; \`studyMaterials\` as an array of objects which has a source ID, study material type, proceeded by the properties of the card type.
The following card types are:
\`flashcard\` - Has \`frontContent\` and \`backContent\` as strings
\`free-text\` - Has \`question\` and has \`criteria\` which serves as what's considered "close to correct"
\`multiple-choice-question\` - Has \`question\`, has \`choices\` list, and has \`correctAnswerIndex\` int
The full response must be valid JSON only. No intros, outros, codeblocks, or any invalid characters.

# Example format:
{
  "studyMaterials": [
    {
      "sourceId": "tab-1",
      "type": "flashcard",
      "frontContent": "What is the capital of France?",
      "backContent": "Paris"
    },
    {
      "sourceId": "tab-1",
      "type": "free-text",
      "question": "Explain the process of photosynthesis.",
      "criteria": "Mentions conversion of light energy into chemical energy, involves chlorophyll, produces glucose and oxygen."
    },
    {
      "sourceId": "tab-1",
      "type": "multiple-choice-question",
      "question": "Which planet is known as the Red Planet?",
      "choices": ["Earth", "Mars", "Jupiter", "Venus"],
      "correctAnswerIndex": 1
    }
  ]
}`;

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
    model: "deepseek-chat",
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
