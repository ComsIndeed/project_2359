// Supabase Edge Function: index-extracted-text
// Accepts a string input and streams back LLM-generated text chunks via Groq.

import { requireEnv, serve } from "../_shared/mod.ts";
import Groq from "https://esm.sh/groq-sdk@0.8.0";

const prompt =
  "You are a helpful assistant that processes and indexes extracted text. Provide clear, structured analysis.";

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
    temperature: 0.7,
  });

  return stream(async function* () {
    for await (const chunk of llmStream) {
      const content = chunk.choices[0]?.delta?.content;
      if (content) yield content;
    }
  });
});
