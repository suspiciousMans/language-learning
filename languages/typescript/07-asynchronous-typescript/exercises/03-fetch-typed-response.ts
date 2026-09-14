/**
 * 03-fetch-typed-response.ts — project 07 exercise.
 *
 * Use fetch to hit a typed endpoint; define the expected response shape.
 *
 * Run: npx tsx exercises/03-fetch-typed-response.ts
 *
 * Uses httpbin.org's /json endpoint (public, no key required).
 */

// The shape we expect from the httpbin /json endpoint.
interface HttpbinJsonResponse {
  slideshow: {
    author: string;
    date: string;
    id: number;
    title: string;
    slides: Array<{
      caption?: string;
      date: string;
      datetime: string;
      desc: string;
      duration: number;
      id: number;
      image: string;
      name: string;
      slideType: string;
    }>;
  };
}

async function fetchHttpbinJson(): Promise<HttpbinJsonResponse> {
  const response = await fetch("https://httpbin.org/json");

  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
  }

  const body: HttpbinJsonResponse = await response.json();
  return body;
}

async function main() {
  try {
    const data = await fetchHttpbinJson();
    console.log("title:", data.slideshow.title);
    console.log("slide count:", data.slideshow.slides.length);
    console.log("first slide caption:", data.slideshow.slides[0].caption);
  } catch (err) {
    // In strict TS, caught values are `unknown`. Narrow before using.
    if (err instanceof Error) {
      console.error("fetch failed:", err.message);
    } else {
      console.error("fetch failed with unknown error:", err);
    }
  }
}

main();
