// Supabase Edge Function: index-extracted-text
// Accepts a string input and streams back LLM-generated text chunks via Groq.

import "@supabase/functions-js/edge-runtime.d.ts";
import Groq from "https://esm.sh/groq-sdk@0.8.0";

// CORS headers for browser requests
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Parse the input string from the request body
    const { input } = await req.json();

    if (!input || typeof input !== "string") {
      return new Response(
        JSON.stringify({
          error: "Missing or invalid 'input' field. Expected a string.",
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Get the GROQ_API_KEY from Supabase environment variables
    const apiKey = Deno.env.get("GROQ_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({
          error: "GROQ_API_KEY is not configured in environment variables.",
        }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Initialize the Groq client
    const groq = new Groq({ apiKey });

    // Create a streaming chat completion
    const stream = await groq.chat.completions.create({
      model: "llama-3.1-8b-instant",
      messages: [
        {
          role: "system",
          content:
            "You are a helpful assistant that processes and indexes extracted text. Provide clear, structured analysis.",
        },
        {
          role: "user",
          content: input,
        },
      ],
      stream: true,
      max_tokens: 4096,
      temperature: 0.7,
    });

    // Create a ReadableStream that emits SSE-formatted chunks
    const body = new ReadableStream({
      async start(controller) {
        const encoder = new TextEncoder();
        try {
          for await (const chunk of stream) {
            const content = chunk.choices[0]?.delta?.content;
            if (content) {
              // Send each chunk as a server-sent event
              controller.enqueue(
                encoder.encode(`data: ${JSON.stringify(content)}\n\n`),
              );
            }
          }
          // Signal the end of the stream
          controller.enqueue(encoder.encode("data: [DONE]\n\n"));
          controller.close();
        } catch (err: unknown) {
          const message = err instanceof Error ? err.message : "Stream error";
          controller.enqueue(
            encoder.encode(
              `data: ${JSON.stringify({ error: message })}\n\n`,
            ),
          );
          controller.close();
        }
      },
    });

    return new Response(body, {
      status: 200,
      headers: {
        ...corsHeaders,
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
      },
    });
  } catch (error: unknown) {
    console.error("index-extracted-text Error:", error);
    const message = error instanceof Error
      ? error.message
      : "Internal server error";
    return new Response(
      JSON.stringify({ error: message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
});
