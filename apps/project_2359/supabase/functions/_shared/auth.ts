/**
 * Shared auth utilities for Supabase Edge Functions.
 *
 * Handles JWT verification using the publishable key + Supabase client approach.
 * Works with both legacy anon keys and new publishable keys.
 *
 * Usage:
 *   import { getAuthenticatedUser } from "../_shared/auth.ts";
 *
 *   const { user, error } = await getAuthenticatedUser(req);
 *   if (error) return error; // already a 401 Response
 */

import { createClient, type User } from "npm:@supabase/supabase-js@2";
import { corsHeaders } from "./cors.ts";

type AuthResult =
    | { user: User; error: null }
    | { user: null; error: Response };

/**
 * Extracts and verifies the user's JWT from the Authorization header.
 * Returns the authenticated Supabase User, or a ready-to-return 401 Response.
 */
export async function getAuthenticatedUser(req: Request): Promise<AuthResult> {
    const authHeader = req.headers.get("authorization");

    if (!authHeader) {
        return {
            user: null,
            error: Response.json(
                { error: "Missing Authorization header" },
                { status: 401, headers: corsHeaders },
            ),
        };
    }

    const token = authHeader.replace("Bearer ", "");

    // Create a Supabase client using the publishable key (or anon key).
    // The env var SUPABASE_URL is automatically available in deployed Edge Functions.
    // SB_PUBLISHABLE_KEY should be set as a secret; falls back to SUPABASE_ANON_KEY for compat.
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SB_PUBLISHABLE_KEY") ??
        Deno.env.get("SUPABASE_ANON_KEY")!;

    const supabase = createClient(supabaseUrl, supabaseKey, {
        global: { headers: { Authorization: `Bearer ${token}` } },
    });

    const {
        data: { user },
        error,
    } = await supabase.auth.getUser(token);

    if (error || !user) {
        return {
            user: null,
            error: Response.json(
                { error: "Invalid or expired token" },
                { status: 401, headers: corsHeaders },
            ),
        };
    }

    return { user, error: null };
}
