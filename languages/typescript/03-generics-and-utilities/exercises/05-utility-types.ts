/**
 * 03-generics-and-utilities/exercises/05-utility-types.ts
 *
 * Use Partial, Pick, Omit, Record, ReturnType, and Parameters
 * in a realistic scenario around an Article type.
 *
 * Fill in the type aliases so that `npx tsc --noEmit` passes.
 */

interface Article {
  title: string;
  body: string;
  author: string;
  publishedAt: Date;
  tags: string[];
}

// ArticleUpdate: every field optional (for update payloads).
type ArticleUpdate = Partial<Article>;

// ArticleIdentity: only title and author.
type ArticleIdentity = Pick<Article, "title" | "author">;

// ArticlePreview: everything except body.
type ArticlePreview = Omit<Article, "body">;

// TagCounts: a map from tag name to count.
type TagCounts = Record<string, number>;

// ReturnType example: extract the return type of makeArticle.
function makeArticle(title: string): Article {
  return {
    title,
    body: "",
    author: "anonymous",
    publishedAt: new Date(),
    tags: [],
  };
}
type ArticleFactoryReturn = ReturnType<typeof makeArticle>;

// Parameters example: extract the parameter tuple of greet2.
function greet2(name: string, age: number): string {
  return `${name} is ${age}`;
}
type GreetParams = Parameters<typeof greet2>;
