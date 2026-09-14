/**
 * 03-generics-and-utilities — solution: all five exercises, working.
 */

// ── 01-generic-functions.ts ───────────────────────────────────────

// Identity: preserves the input type.
function identity<T>(x: T): T {
  return x;
}

// Swap: swaps two values of (possibly different) types.
function swap<A, B>(a: A, b: B): [B, A] {
  return [b, a];
}

// Wrap in an array.
function wrap<T>(x: T): T[] {
  return [x];
}

// Constrained: only accepts objects with a .length property.
function longest<T extends { length: number }>(a: T, b: T): T {
  return a.length >= b.length ? a : b;
}

// ── 02-generic-interfaces.ts ──────────────────────────────────────

interface Box<T> {
  value: T;
}

interface Pair<A, B> {
  first: A;
  second: B;
}

interface Repository<T, Id> {
  findById(id: Id): Promise<T | null>;
  save(entity: T): Promise<void>;
  delete(id: Id): Promise<void>;
}

// ── 03-conditional-types.ts ──────────────────────────────────────

type IsString<T> = T extends string ? true : false;

type ElementType<T> = T extends (infer U)[] ? U : never;

type DefinitelyString<T> = T extends string ? T : never;

// ── 04-mapped-types.ts ───────────────────────────────────────────

// Make all properties readonly.
type Readonly<T> = {
  readonly [K in keyof T]: T[K];
};

// Make all properties optional.
type Optional<T> = {
  [K in keyof T]?: T[K];
};

// Rename keys: prepend "renamed_".
type RenameKeys<T> = {
  [K in keyof T as `renamed_${string & K}`]: T[K];
};

// ── 05-utility-types.ts ──────────────────────────────────────────

interface Article {
  title: string;
  body: string;
  author: string;
  publishedAt: Date;
  tags: string[];
}

// Partial: all fields optional (e.g., for updates).
type ArticleUpdate = Partial<Article>;

// Pick: select a subset.
type ArticleIdentity = Pick<Article, "title" | "author">;

// Omit: remove fields.
type ArticlePreview = Omit<Article, "body">;

// Record: a map.
type TagCounts = Record<string, number>;

// ReturnType: extract the return type of a function.
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

// Parameters: extract the parameter tuple.
function greet2(name: string, age: number): string {
  return `${name} is ${age}`;
}
type GreetParams = Parameters<typeof greet2>;
