/**
 * Shared Edge Function handler that removes ALL the boilerplate.
 *
 * Usage:
 *   import { serve } from "../_shared/handler.ts";
 *
 *   serve(async (req, { user, json, stream }) => {
 *     const { input } = await json<{ input: string }>();
 *     // ... your logic here ...
 *     return Response.json({ result: "done" });
 *   });
 *
 * What it does for you:
 *   ✅ CORS preflight handling
 *   ✅ Auth enforcement (rejects unauthenticated requests with 401)
 *   ✅ JSON body parsing helper
 *   ✅ SSE streaming helper
 *   ✅ Error catching (returns 500 with message)
 *   ✅ Consistent response headers
 */

import type { User } from "npm:@supabase/supabase-js@2";
import { corsHeaders } from "./cors.ts";
import { getAuthenticatedUser } from "./auth.ts";

/** Helpers passed into your handler so you don't have to deal with boilerplate. */
export interface HandlerContext {
    /** The verified, authenticated Supabase user. */
    user: User;

    /**
     * Parse the request body as JSON (with type inference).
     *
     * Example:
     *   const { input } = await json<{ input: string }>();
     */
    json: <T = Record<string, unknown>>() => Promise<T>;

    /**
     * Return a Server-Sent Events (SSE) streaming response.
     *
     * Pass an async generator or callback that enqueues chunks.
     *
     * Example using an async iterable (like an LLM stream):
     *   return stream(async function* () {
     *     for await (const chunk of llmStream) {
     *       yield chunk;
     *     }
     *   });
     */
    stream: (
        generator: () => AsyncGenerator<string, void, unknown>,
    ) => Response;

    /**
     * Return a JSON error response with CORS headers.
     *
     * Example:
     *   return error("Something went wrong", 400);
     */
    error: (message: string, status?: number) => Response;

    /**
     * Return a JSON success response with CORS headers.
     *
     * Example:
     *   return ok({ result: "done" });
     */
    ok: (data: unknown, status?: number) => Response;
}

export type HandlerFn = (
    req: Request,
    ctx: HandlerContext,
) => Promise<Response> | Response;

export interface ServeOptions {
    /** Set to `false` to skip auth enforcement (e.g. for public endpoints). Default: true. */
    requireAuth?: boolean;
}

/**
 * The main entry point. Call this instead of `Deno.serve()`.
 */
export function serve(handler: HandlerFn, options?: ServeOptions) {
    const { requireAuth = true } = options ?? {};

    Deno.serve(async (req: Request) => {
        // ── CORS preflight ──────────────────────────────────────
        if (req.method === "OPTIONS") {
            return new Response("ok", { headers: corsHeaders });
        }

        try {
            // ── Auth ──────────────────────────────────────────────
            let user: User | null = null;

            if (requireAuth) {
                const auth = await getAuthenticatedUser(req);
                if (auth.error) return auth.error;
                user = auth.user;
            }

            // ── Build context helpers ─────────────────────────────
            const json = async <T = Record<string, unknown>>(): Promise<T> => {
                return (await req.json()) as T;
            };

            const stream = (
                generator: () => AsyncGenerator<string, void, unknown>,
            ): Response => {
                const body = new ReadableStream({
                    async start(controller) {
                        const encoder = new TextEncoder();
                        try {
                            for await (const chunk of generator()) {
                                controller.enqueue(
                                    encoder.encode(
                                        `data: ${JSON.stringify(chunk)}\n\n`,
                                    ),
                                );
                            }
                            controller.enqueue(
                                encoder.encode("data: [DONE]\n\n"),
                            );
                            controller.close();
                        } catch (err: unknown) {
                            const message = err instanceof Error
                                ? err.message
                                : "Stream error";
                            controller.enqueue(
                                encoder.encode(
                                    `data: ${
                                        JSON.stringify({ error: message })
                                    }\n\n`,
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
                        Connection: "keep-alive",
                    },
                });
            };

            const error = (message: string, status = 400): Response => {
                return Response.json(
                    { error: message },
                    { status, headers: corsHeaders },
                );
            };

            const ok = (data: unknown, status = 200): Response => {
                return Response.json(data, { status, headers: corsHeaders });
            };

            // ── Run the actual handler ────────────────────────────
            return await handler(req, {
                user: user!,
                json,
                stream,
                error,
                ok,
            });
        } catch (err: unknown) {
            console.error("Edge Function Error:", err);
            const message = err instanceof Error
                ? err.message
                : "Internal server error";
            return Response.json(
                { error: message },
                { status: 500, headers: corsHeaders },
            );
        }
    });
}
