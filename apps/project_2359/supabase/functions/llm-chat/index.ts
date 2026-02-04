// Supabase Edge Function: llm-chat
// Deploy to: supabase/functions/llm-chat/index.ts
//
// Universal LLM function supporting multiple providers:
// - Deepseek (OpenAI-compatible)
// - OpenRouter (OpenAI-compatible)
// - Gemini (Google AI SDK)
// - Groq (Groq SDK)

import "https://esm.sh/@supabase/functions-js@2.4.3";
import { GoogleGenerativeAI } from "https://esm.sh/@google/generative-ai@0.21.0";
import OpenAI from "https://esm.sh/openai@4.76.0";
import Groq from "https://esm.sh/groq-sdk@0.8.0";

// CORS headers for browser requests
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// Provider configurations
const PROVIDERS = {
  deepseek: {
    baseURL: "https://api.deepseek.com/v1",
    envKey: "DEEPSEEK_API_KEY",
  },
  openrouter: {
    baseURL: "https://openrouter.ai/api/v1",
    envKey: "OPENROUTER_API_KEY",
  },
  gemini: {
    envKey: "GEMINI_API_KEY",
  },
  groq: {
    envKey: "GROQ_API_KEY",
  },
};

interface ChatMessage {
  role: "user" | "assistant" | "system";
  content: string;
}

interface LlmRequest {
  provider: "deepseek" | "openrouter" | "gemini" | "groq";
  model: string;
  messages: ChatMessage[];
  systemPrompt?: string;
  maxTokens?: number;
  temperature?: number;
  userId?: string; // For credit deduction
}

interface LlmResponse {
  content: string;
  usage: {
    inputTokens: number;
    outputTokens: number;
  };
  model: string;
  provider: string;
}

// Handle OpenAI-compatible providers (Deepseek, OpenRouter)
async function handleOpenAICompatible(
  request: LlmRequest,
  baseURL: string,
  apiKey: string
): Promise<LlmResponse> {
  const client = new OpenAI({
    baseURL,
    apiKey,
  });

  const messages: OpenAI.ChatCompletionMessageParam[] = [];
  
  if (request.systemPrompt) {
    messages.push({ role: "system", content: request.systemPrompt });
  }
  
  for (const msg of request.messages) {
    messages.push({ role: msg.role, content: msg.content });
  }

  const completion = await client.chat.completions.create({
    model: request.model,
    messages,
    max_tokens: request.maxTokens ?? 4096,
    temperature: request.temperature ?? 0.7,
  });

  return {
    content: completion.choices[0]?.message?.content ?? "",
    usage: {
      inputTokens: completion.usage?.prompt_tokens ?? 0,
      outputTokens: completion.usage?.completion_tokens ?? 0,
    },
    model: request.model,
    provider: request.provider,
  };
}

// Handle Gemini provider
async function handleGemini(
  request: LlmRequest,
  apiKey: string
): Promise<LlmResponse> {
  const genAI = new GoogleGenerativeAI(apiKey);
  const model = genAI.getGenerativeModel({ model: request.model });

  // Build conversation history
  const history = request.messages
    .filter((m) => m.role !== "system")
    .map((m) => ({
      role: m.role === "assistant" ? "model" : "user",
      parts: [{ text: m.content }],
    }));

  // Get the last user message
  const lastMessage = history.pop();
  if (!lastMessage) {
    throw new Error("No messages provided");
  }

  const chat = model.startChat({
    history,
    generationConfig: {
      maxOutputTokens: request.maxTokens ?? 4096,
      temperature: request.temperature ?? 0.7,
    },
    systemInstruction: request.systemPrompt,
  });

  const result = await chat.sendMessage(lastMessage.parts[0].text);
  const response = result.response;

  return {
    content: response.text(),
    usage: {
      inputTokens: response.usageMetadata?.promptTokenCount ?? 0,
      outputTokens: response.usageMetadata?.candidatesTokenCount ?? 0,
    },
    model: request.model,
    provider: "gemini",
  };
}

// Handle Groq provider
async function handleGroq(
  request: LlmRequest,
  apiKey: string
): Promise<LlmResponse> {
  const client = new Groq({ apiKey });

  const messages: Groq.ChatCompletionMessageParam[] = [];
  
  if (request.systemPrompt) {
    messages.push({ role: "system", content: request.systemPrompt });
  }
  
  for (const msg of request.messages) {
    messages.push({ role: msg.role, content: msg.content });
  }

  const completion = await client.chat.completions.create({
    model: request.model,
    messages,
    max_tokens: request.maxTokens ?? 4096,
    temperature: request.temperature ?? 0.7,
  });

  return {
    content: completion.choices[0]?.message?.content ?? "",
    usage: {
      inputTokens: completion.usage?.prompt_tokens ?? 0,
      outputTokens: completion.usage?.completion_tokens ?? 0,
    },
    model: request.model,
    provider: "groq",
  };
}

// Credit deduction function
async function deductCredits(
  userId: string | undefined,
  inputTokens: number,
  outputTokens: number,
  model: string,
  provider: string
): Promise<void> {
  // TODO: Implement credit deduction based on token usage
  // 
  // This should:
  // 1. Look up the credit cost per token for the provider/model
  // 2. Calculate total credits: (inputTokens * inputCost) + (outputTokens * outputCost)
  // 3. Deduct from user's credit balance in the database
  // 4. Log the transaction for auditing
  //
  // For now, this is a no-op (zero cost)
  console.log(`[Credit Deduction] User: ${userId ?? 'anonymous'}, Provider: ${provider}, Model: ${model}`);
  console.log(`[Credit Deduction] Tokens - Input: ${inputTokens}, Output: ${outputTokens}`);
  console.log(`[Credit Deduction] Cost: 0 credits (TODO: implement pricing)`);
}

// Main handler
Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const request: LlmRequest = await req.json();

    // Validate request
    if (!request.provider || !request.model || !request.messages?.length) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: provider, model, messages" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Get provider config
    const providerConfig = PROVIDERS[request.provider];
    if (!providerConfig) {
      return new Response(
        JSON.stringify({ error: `Unknown provider: ${request.provider}` }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Get API key from environment
    const apiKey = Deno.env.get(providerConfig.envKey);
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: `API key not configured for ${request.provider}` }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    let response: LlmResponse;

    // Route to appropriate handler
    switch (request.provider) {
      case "deepseek":
        response = await handleOpenAICompatible(request, PROVIDERS.deepseek.baseURL, apiKey);
        break;
      case "openrouter":
        response = await handleOpenAICompatible(request, PROVIDERS.openrouter.baseURL, apiKey);
        break;
      case "gemini":
        response = await handleGemini(request, apiKey);
        break;
      case "groq":
        response = await handleGroq(request, apiKey);
        break;
      default:
        throw new Error(`Unsupported provider: ${request.provider}`);
    }

    // Deduct credits (currently zero cost)
    await deductCredits(
      request.userId,
      response.usage.inputTokens,
      response.usage.outputTokens,
      response.model,
      response.provider
    );

    return new Response(
      JSON.stringify(response),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("LLM Chat Error:", error);
    return new Response(
      JSON.stringify({ error: error.message ?? "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
