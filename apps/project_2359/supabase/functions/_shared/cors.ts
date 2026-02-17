/**
 * Shared CORS headers for all Edge Functions.
 *
 * Usage:
 *   import { corsHeaders } from "../_shared/cors.ts";
 */

export const corsHeaders: Record<string, string> = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
        "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
};
