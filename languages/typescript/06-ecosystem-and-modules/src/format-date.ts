/**
 * format-date.ts — exercise for project 06: using a typed 3rd-party library.
 *
 * Uses date-fns (which ships its own types) to parse and format a date.
 *
 * Run: npx tsx src/format-date.ts
 */

import { format, parseISO } from "date-fns";

const input = "2026-09-14T12:00:00Z";

const parsed = parseISO(input);
const formatted = format(parsed, "PPP'p' HH:mm");

console.log(`Input:  ${input}`);
console.log(`Parsed: ${parsed.toISOString()}`);
console.log(`Formatted: ${formatted}`);

// A second example: format today's date as ISO ordinal.
const today = new Date();
console.log(`Today: ${format(today, "yyyy-MM-dd")}`);
