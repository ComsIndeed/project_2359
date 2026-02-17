/**
 * Barrel export for all shared Edge Function utilities.
 *
 * Usage in any function:
 *   import { serve } from "../_shared/mod.ts";
 *
 *   serve(async (req, { user, json, stream, error, ok }) => {
 *     // your logic
 *   });
 */

export { corsHeaders } from "./cors.ts";
export { getAuthenticatedUser } from "./auth.ts";
export { serve } from "./handler.ts";
export { requireEnv } from "./env.ts";
export type { HandlerContext, HandlerFn, ServeOptions } from "./handler.ts";
