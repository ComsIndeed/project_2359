/**
 * Environment variable helpers.
 *
 * Usage:
 *   import { requireEnv } from "../_shared/env.ts";
 *
 *   const apiKey = requireEnv("GROQ_API_KEY");
 *   // throws with a clear message if not set
 */

/**
 * Get a required environment variable, or throw with a helpful message.
 */
export function requireEnv(name: string): string {
    const value = Deno.env.get(name);
    if (!value) {
        throw new Error(`Missing required environment variable: ${name}`);
    }
    return value;
}
