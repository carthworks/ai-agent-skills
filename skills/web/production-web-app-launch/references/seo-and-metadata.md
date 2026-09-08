# SEO, metadata, social sharing, and app identity

Read for any public-facing site. Skip for internal-only tools, but confirm the tool really is internal-only and will stay that way.

These four concerns were historically audited separately and overlap heavily, so they are consolidated here. Work route by route rather than category by category — it is faster and it surfaces the most common real defect, which is one generic title copied across every page.

## Per-route metadata

For each important route, establish that these exist and are route-specific:

- `<title>` — unique, descriptive, front-loaded with the distinguishing words.
- Meta description — useful to a human deciding whether to click. Not keyword soup.
- Canonical URL where duplicates or parameterized variants are possible.
- Open Graph title, description, and image.
- Social card metadata (`twitter:card` and friends) where the site will be shared.

Absolute URLs are required for OG and canonical tags. Relative ones silently fail in most scrapers, which is a common and invisible bug.

A generic site-wide fallback is acceptable for minor routes. It is not acceptable for the home page, pricing, primary landing pages, or anything with its own share link.

## Site-level SEO

- Correct heading hierarchy — one `h1` per page, no level skipping, headings used for structure rather than for font size.
- `robots.txt` present and not accidentally blocking the site.
- `sitemap.xml` present and listing real, reachable, canonical URLs.
- No stray `noindex` on production routes. This is the single most damaging and most common launch defect — check the built output, not just the source, since framework config and environment variables can inject it.
- Clean, descriptive, stable URLs.
- Content is visible to crawlers. For client-rendered apps, confirm what the initial HTML response actually contains.
- Structured data where a rich result is plausibly available and the data is genuinely accurate.
- Duplicate content minimized, or resolved with canonicals.

Do not add copy purely to raise keyword density. Thin pages padded with keywords rank worse and read worse.

## Social preview

- A real preview image exists, not a framework default or a broken link.
- Dimensions are appropriate (1200×630 is the safe default) and any text on it is legible at thumbnail size.
- The image path is absolute and publicly reachable without authentication.
- Title and description on the card match the page.

Verify by fetching the deployed URL and reading the returned tags where the network allows it. If you cannot fetch, mark NOT VERIFIED and hand the owner a validator link to check themselves.

## Favicon and app identity

- Favicon exists at the expected path and is wired up.
- Apple touch icon where iOS bookmarking matters.
- No framework default icon left in place — the React, Vite, or Next logo in a browser tab is a visible sign of an unfinished launch.
- Browser tab title and brand naming are consistent with the product name used in the UI.
- Theme color set where it affects mobile browser chrome.
