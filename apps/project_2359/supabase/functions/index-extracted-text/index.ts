// Supabase Edge Function: index-extracted-text
// Accepts numbered text lines and streams back a JSON index with citations via Groq.

import { requireEnv, serve } from "../_shared/mod.ts";
import Groq from "https://esm.sh/groq-sdk@0.8.0";

const prompt =
  `You are a document indexer. You receive extracted text lines from a PDF, each labeled with a line ID and page number, like:
[LINE_1] (p.1) Some text here
[LINE_2] (p.1) More text here

Your job is to produce a JSON array where each entry is a coherent statement or paragraph derived from the source lines, with citations back to the original line IDs.

Output format (JSON array only, no other text):
[
  {
    "statement": "A coherent statement or paragraph summarizing content.",
    "source_lines": ["LINE_1", "LINE_2"]
  },
  ...
]

Rules:
- Group related consecutive lines into single statements when they form a coherent paragraph.
- Keep short standalone lines (headings, titles, captions) as their own statements.
- Always cite every source line used in a statement via the "source_lines" array.
- Do NOT invent content. Only summarize or restate what the lines say.
- Output ONLY the JSON array. No markdown, no explanation, no wrapping.`;

serve(async (_req, { json, stream, error }) => {
  const { input } = await json<{ input: string }>();

  if (!input || typeof input !== "string") {
    return error("Missing or invalid 'input' field. Expected a string.", 400);
  }

  const apiKey = requireEnv("GROQ_API_KEY");
  const groq = new Groq({ apiKey });

  const llmStream = await groq.chat.completions.create({
    model: "llama-3.1-8b-instant",
    messages: [
      { role: "system", content: prompt },
      { role: "user", content: input },
    ],
    stream: true,
    max_tokens: 4096,
    temperature: 0.3,
  });

  return stream(async function* () {
    for await (const chunk of llmStream) {
      const content = chunk.choices[0]?.delta?.content;
      if (content) yield content;
    }
  });
});
