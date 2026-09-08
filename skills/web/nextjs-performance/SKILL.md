---
name: nextjs-performance
description: |
  Optimises Next.js applications for Core Web Vitals, bundle size, and perceived
  performance. Use when building, auditing, or debugging a Next.js app's performance.
  Activates when the user asks about slow page loads, LCP, CLS, INP, image optimisation,
  SSR vs SSG vs ISR decisions, bundle analysis, or when Lighthouse scores are poor.
  Applies to Next.js App Router (13+) and Pages Router.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Next.js Performance

> [!TIP]
> Fix rendering strategy first (biggest wins), then images, then JavaScript bundle,
> then fonts. In that order.

---

## Rendering Strategy Decision Tree

```
Is the content the same for every user?
  ├── YES → Is it time-sensitive (changes every few minutes)?
  │           ├── YES  → ISR (revalidate: 60)
  │           └── NO   → Static (generateStaticParams / SSG)
  └── NO  → Does it need SEO?
              ├── YES  → SSR (dynamic rendering with cache headers)
              └── NO   → Client Component with SWR/React Query
```

### App Router — correct fetch usage

```ts
// Static — cached forever until revalidated
const data = await fetch(url);                          // default: force-cache

// ISR — revalidate every 60 seconds
const data = await fetch(url, { next: { revalidate: 60 } });

// SSR — never cache (per-request)
const data = await fetch(url, { cache: 'no-store' });

// Tag-based revalidation
const data = await fetch(url, { next: { tags: ['products'] } });
await revalidateTag('products');   // on-demand revalidation
```

---

## Images — biggest LCP win

Always use `next/image`. Never use `<img>` for content images.

```tsx
import Image from 'next/image';

// Hero image — preload it
<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority            // ← preloads, eliminates LCP delay
  placeholder="blur"
/>

// Below-fold image — lazy load (default)
<Image
  src="/product.jpg"
  alt="Product"
  width={400}
  height={300}
  // no priority = lazy loaded automatically
/>
```

**Rules:**
- `priority` on any image visible above the fold (hero, navbar logo)
- `sizes` prop on responsive images: `sizes="(max-width: 768px) 100vw, 50vw"`
- `placeholder="blur"` + `blurDataURL` for perceived performance
- Always provide explicit `width` and `height` to prevent CLS

---

## Fonts — eliminate layout shift

```tsx
// app/layout.tsx
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',      // show fallback font while loading
  variable: '--font-inter',
  preload: true,        // default
});

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
```

**Never** load Google Fonts via `<link>` in `<head>` — always use `next/font`.

---

## Bundle Size

### Find the problem first

```bash
# Analyse what's in your bundle
ANALYZE=true npm run build
# Requires: npm install @next/bundle-analyzer
```

```js
// next.config.js
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});
module.exports = withBundleAnalyzer({});
```

### Common fixes

```tsx
// Dynamic import heavy components (code splitting)
const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <Skeleton />,
  ssr: false,          // client-only libraries (e.g. Chart.js)
});

// Don't import entire libraries
import { format } from 'date-fns';          // ✅ tree-shaken
import * as dateFns from 'date-fns';        // ❌ whole library

// Replace heavy libraries where possible
// moment.js (330KB) → date-fns or dayjs (7KB)
// lodash (70KB) → native JS or lodash-es with tree-shaking
```

---

## Server vs Client Components (App Router)

```
Server Component (default) — use for:
  ✅ Data fetching
  ✅ Accessing backend resources directly
  ✅ Sensitive logic / secrets
  ✅ Large dependencies (reduces client bundle)

Client Component ('use client') — use for:
  ✅ Interactivity (onClick, onChange)
  ✅ Browser APIs (window, localStorage)
  ✅ useState, useEffect, useRef
  ✅ Real-time updates
```

**Rule**: Push `'use client'` as far down the tree as possible. Wrap only interactive leaves, not whole pages.

---

## Caching & Revalidation

```ts
// Route segment config
export const revalidate = 3600;        // ISR: revalidate this page every hour
export const dynamic = 'force-static'; // Always static
export const dynamic = 'force-dynamic'; // Always SSR

// On-demand revalidation (after a CMS save, webhook, etc.)
import { revalidatePath, revalidateTag } from 'next/cache';
revalidatePath('/blog');
revalidateTag('blog-posts');
```

---

## Core Web Vitals Quick Reference

| Metric | Target | Main cause | Fix |
|--------|--------|-----------|-----|
| **LCP** (load) | < 2.5s | Large hero image, slow TTFB | `priority` image, CDN, SSG/ISR |
| **CLS** (shift) | < 0.1 | Images without dimensions, fonts | Explicit `width`/`height`, `next/font` |
| **INP** (interactivity) | < 200ms | Heavy JS on main thread | Code split, `dynamic()`, defer non-critical |

---

## Performance Checklist

- [ ] Rendering strategy chosen deliberately (static/ISR/SSR/client)
- [ ] All content images use `next/image`
- [ ] Hero image has `priority` prop
- [ ] All images have explicit `width` and `height`
- [ ] Fonts loaded via `next/font`, not `<link>`
- [ ] `dynamic()` used for heavy client-only components
- [ ] No full library imports (lodash, moment)
- [ ] Bundle analyser run and findings addressed
- [ ] `'use client'` boundary as low in the tree as possible
- [ ] Lighthouse score ≥ 90 on desktop, ≥ 75 on mobile
