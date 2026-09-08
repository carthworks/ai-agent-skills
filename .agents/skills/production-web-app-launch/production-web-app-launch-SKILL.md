---
name: production-web-app-launch
description: Audit and implement production-readiness requirements across websites and web apps before launch. Use for any web app, website, SaaS, dashboard, landing page, ecommerce site, portfolio, or full-stack web project when preparing for launch, deployment, public release, or a production-readiness review.
---

# Production Web App Launch Skill

## Mission

Take the web app from "works locally" to "ready for real users."

Do not merely produce a checklist. Inspect the actual project, identify gaps, implement fixes where safe, and verify the result.

Apply this skill to:
- Static websites
- React / Next.js / Vue / Angular apps
- Full-stack web applications
- SaaS products
- Dashboards
- E-commerce sites
- Landing pages
- Portfolios
- Internal web tools that may become public

## Core behavior

1. Inspect the existing project before changing anything.
2. Detect the framework, build system, routing, deployment target, package manager, and existing configuration.
3. Reuse the project's existing conventions instead of introducing unnecessary dependencies.
4. Implement fixes, don't just describe them.
5. Never invent legal/business information such as company identity, address, refund terms, retention periods, or contact details. If required information is unknown, add a clearly marked TODO or ask the owner.
6. Never expose secrets, API keys, credentials, tokens, private URLs, or sensitive environment variables.
7. Do not make destructive changes without explicit approval.
8. After implementation, run the available tests, linting, type checks, and production build.
9. Report what was implemented, what was verified, and what still requires human/business input.

---

# Launch Readiness Audit

Check every applicable category below.

## 1. Legal, privacy, and trust

Check:
- Privacy Policy page exists and is reachable.
- Terms of Service / Terms & Conditions exists where applicable.
- Cookie/privacy consent is implemented when legally required.
- Data collection is explained accurately.
- Contact/support information is available where appropriate.
- Refund, cancellation, shipping, or subscription policies exist when relevant.
- No misleading claims or placeholder legal text remain.

Important:
Legal requirements depend on jurisdiction and product behavior. Do not claim legal compliance merely because pages exist.

## 2. Clear conversion and CTA

Check:
- Every important page has an obvious primary action.
- CTA wording is specific and meaningful.
- Navigation leads users toward the intended action.
- Forms explain what happens after submission.
- Success and error states are clear.
- No dead-end pages exist.

## 3. FAQ and user guidance

Check:
- Frequently expected questions are answered.
- Pricing, onboarding, account behavior, cancellation, delivery, support, and limitations are explained when applicable.
- Empty states and first-use states explain what the user should do next.

## 4. SEO fundamentals

Check:
- Unique `<title>` for important pages.
- Useful meta description.
- Correct heading hierarchy.
- Canonical URL where appropriate.
- `robots.txt`.
- `sitemap.xml`.
- Clean, descriptive URLs.
- No accidental `noindex` on production pages.
- Open Graph/social metadata.
- Twitter/X card metadata where useful.
- Structured data/schema markup where appropriate.
- Search-engine-visible content is meaningful.
- Duplicate content is minimized.

Do not blindly add SEO text just to increase keyword density.

## 5. Metadata

For every important route check:
- Title
- Description
- Canonical URL
- Open Graph title
- Open Graph description
- Open Graph image
- Social card metadata
- Favicon
- Theme color where appropriate

Use route-specific metadata rather than copying one generic title everywhere.

## 6. Social sharing

Check:
- Open Graph metadata.
- Social preview image.
- Correct title/description.
- Absolute URLs where required.
- Preview image dimensions and readability.
- No broken or placeholder social image.

## 7. Favicon and app identity

Check:
- Favicon exists.
- Apple/touch icon where appropriate.
- PWA icons if the app is a PWA.
- Browser title and branding are consistent.
- No framework/default favicon remains.

## 8. Accessibility

Perform a practical accessibility audit:
- Semantic HTML.
- Keyboard navigation.
- Visible focus states.
- Correct labels for inputs.
- Accessible buttons and links.
- Form errors associated with fields.
- Images have meaningful alt text when informative.
- Decorative images use appropriate empty alt text.
- Color contrast is reasonable.
- Do not rely on color alone.
- Modal/dialog focus behavior.
- Skip navigation where useful.
- Heading hierarchy.
- ARIA only when semantic HTML is insufficient.
- Touch targets are usable on mobile.
- Reduced-motion preference is respected where animations are significant.

Do not write meaningless alt text such as "image" or stuff keywords into alt attributes.

## 9. Responsive/mobile experience

Test at minimum:
- Small phone width.
- Large phone width.
- Tablet width.
- Desktop width.

Check:
- No horizontal overflow.
- Navigation works.
- Menus work.
- Tables remain usable.
- Forms are usable.
- Buttons are tappable.
- Modals fit the viewport.
- Text does not overlap.
- Images scale correctly.
- Sticky/fixed elements do not cover content.
- Keyboard does not cause unusable layouts.

## 10. Forms

For every form:
- Correct input types.
- Labels.
- Required-field handling.
- Client-side validation.
- Server-side validation where applicable.
- Useful error messages.
- Loading/submission state.
- Duplicate-submit prevention.
- Success state.
- Failure state.
- Spam/rate-limit protection where appropriate.
- Sensitive data is handled safely.
- No secrets are embedded in client-side code.

## 11. Error handling

Check:
- Custom 404 page.
- Useful 500/error boundary behavior.
- API errors are handled.
- Network failures are handled.
- Empty states exist.
- Loading states exist.
- Retry behavior exists where appropriate.
- Authentication/session expiry is handled.
- Errors do not expose stack traces, secrets, database details, or internal architecture.

## 12. Broken links and routes

Check:
- Internal links.
- Navigation links.
- Footer links.
- CTA links.
- Buttons that navigate.
- Dynamic routes.
- External links.
- Images/assets.
- API endpoints referenced by the frontend.

Remove or fix:
- 404 links.
- Placeholder `#` links where they should navigate.
- Dead buttons.
- Routes that render blank screens.
- Links pointing to development URLs.

## 13. Security

Inspect for common web security problems:
- Secrets committed to source control.
- API keys in frontend bundles.
- Unsafe HTML injection.
- Unsanitized user input.
- Missing authorization checks.
- Client-only authorization.
- Insecure direct object references.
- Weak password handling.
- Missing CSRF protections where applicable.
- Unsafe redirects.
- File upload vulnerabilities.
- Excessive API exposure.
- Debug endpoints.
- Verbose production errors.
- Insecure CORS configuration.
- Missing security headers where applicable.

Do not weaken security controls merely to make functionality work.

## 14. Authentication and authorization

If authentication exists:
- Login/logout works.
- Session persistence works.
- Session expiry works.
- Protected routes are actually protected server-side.
- Unauthorized users cannot access protected APIs directly.
- Role/permission checks happen on the server.
- Password reset flow is safe.
- Account deletion behavior is handled where applicable.
- OAuth callback/redirect URLs are production-safe.

## 15. Privacy and analytics

If analytics exists:
- Tracking code is configured for production.
- Development/test traffic is not accidentally mixed with production analytics.
- Consent requirements are respected where applicable.
- Personal/sensitive information is not accidentally sent to analytics.
- Events have meaningful names.
- Important conversion events are tracked.
- Error monitoring does not leak secrets or sensitive data.

## 16. Performance

Check:
- Production build succeeds.
- Images are optimized.
- Images have appropriate dimensions and lazy loading where useful.
- Fonts are not unnecessarily blocking.
- JavaScript bundles are reasonable.
- Code splitting/lazy loading is used where it provides value.
- Third-party scripts are minimized.
- Large dependencies are identified.
- Caching is sensible.
- API requests are not unnecessarily duplicated.
- Loading states prevent perceived slowness.
- Core user flows are responsive.

Do not optimize blindly. Measure or inspect bundle/build output when available.

## 17. Web platform / HTTP behavior

Check where applicable:
- HTTPS in production.
- Correct redirects.
- Secure cookies.
- Appropriate `SameSite` behavior.
- HSTS when appropriate.
- Content Security Policy where practical.
- `X-Content-Type-Options`.
- Referrer policy.
- Permissions policy.
- Cache headers.
- Compression.
- Correct MIME types.
- No mixed content.

## 18. Production configuration

Check:
- Production environment variables.
- No hardcoded localhost URLs.
- No development API endpoints.
- Correct public base URL.
- Correct API URL.
- Correct OAuth URLs.
- Correct CORS origins.
- Production database configuration.
- Logging configuration.
- Error monitoring.
- Build/deploy scripts.
- Node/runtime version compatibility.
- Environment-specific configuration.

Never print secret environment variable values in the audit report.

## 19. Database and backend reliability

For applications with a backend:
- Database migrations are reproducible.
- Production schema is compatible with application code.
- Connection configuration is production-safe.
- Important queries are reasonable.
- User input is validated.
- Transactions are used where necessary.
- Error handling does not corrupt state.
- Rate limiting exists for sensitive endpoints where appropriate.
- Background jobs have failure handling.
- Health checks exist where appropriate.

## 20. API quality

Check:
- Authentication/authorization.
- Input validation.
- Output validation where useful.
- Correct HTTP status codes.
- Consistent error format.
- Rate limiting for abuse-prone endpoints.
- Pagination for potentially large collections.
- Timeouts.
- Retries only where safe.
- No accidental exposure of internal fields.
- API documentation where appropriate.

## 21. Deployment and infrastructure

Check:
- Production build command.
- Start command.
- Deployment configuration.
- Required environment variables documented.
- Domain configuration.
- HTTPS.
- Health check.
- Rollback path.
- Database migration strategy.
- Static asset handling.
- Serverless/runtime limits where applicable.
- Cron/background jobs where applicable.

## 22. PWA/app-like features

If the project is intended to behave like an installable web app:
- Web app manifest.
- App icons.
- Theme/background colors.
- Service worker.
- Offline behavior.
- Installability.
- Cache strategy.
- Update strategy.

Do not add PWA complexity if the product does not need it.

## 23. Content quality

Check:
- No Lorem Ipsum.
- No "TODO" visible to users.
- No fake testimonials.
- No placeholder phone numbers/emails.
- No dummy pricing.
- No accidental developer language.
- No inconsistent terminology.
- Grammar and spelling are acceptable.
- Dates, currency, units, and contact details are consistent.
- Empty states sound intentional.

## 24. UI polish

Check:
- Consistent spacing.
- Typography hierarchy.
- Button states.
- Hover states.
- Focus states.
- Disabled states.
- Loading states.
- Error states.
- Success states.
- Empty states.
- Skeletons where useful.
- Consistent border/radius/shadow conventions.
- No visual clipping.
- No accidental debug UI.
- No browser-native-looking unfinished components where custom UI is expected.

## 25. Observability

For production apps:
- Error monitoring.
- Server logs.
- Important application events.
- Health endpoint where useful.
- Performance monitoring where appropriate.
- Alerts for critical failures.
- No secrets or sensitive personal data in logs.

## 26. Backup and recovery

For apps with persistent data:
- Database backups.
- Restore procedure.
- Migration rollback strategy.
- Critical uploaded-file backup strategy.
- Recovery ownership is known.

Do not claim backups exist unless they are actually configured.

## 27. Browser compatibility

Test important flows in modern:
- Chromium-based browser.
- Firefox.
- Safari/WebKit where available.

Check:
- Layout.
- Forms.
- Authentication.
- Modals.
- File uploads.
- Clipboard.
- Web APIs.
- CSS features.

## 28. Final launch smoke test

Before declaring launch-ready, verify the complete user journey:

1. Open production/home page.
2. Navigate through primary navigation.
3. Open the primary CTA.
4. Submit important forms.
5. Test validation failures.
6. Test successful submission.
7. Test authentication if present.
8. Test protected pages.
9. Test logout.
10. Test important CRUD operations.
11. Test refresh/deep links.
12. Test mobile layout.
13. Test 404.
14. Check browser console for unexpected errors.
15. Check network requests for failed calls.
16. Run production build.
17. Run tests/lint/typecheck if available.

---

# Implementation Rules

When a problem is found:

### Safe to implement automatically
- Missing metadata.
- Missing favicon wiring when assets already exist.
- Basic sitemap/robots configuration.
- Missing semantic labels.
- Obvious broken internal links.
- Missing loading/error/empty states when the implementation is straightforward.
- Accessibility improvements that preserve intended behavior.
- Responsive CSS fixes.
- Production URL configuration when the intended URL is already defined.
- Obvious console/debug cleanup.

### Ask before implementing
- Legal policy wording that requires business facts.
- Pricing or commercial terms.
- Analytics vendors or tracking that affect privacy.
- Authentication provider changes.
- Database/schema changes with data-loss risk.
- Infrastructure changes that can cause downtime.
- Removing functionality.
- Major dependency replacements.
- Security changes that alter product behavior significantly.

---

# Audit Output

At the end, produce a concise report:

## Launch Readiness
`READY` / `READY WITH WARNINGS` / `NOT READY`

## Implemented
- ...

## Verified
- Build: PASS/FAIL
- Tests: PASS/FAIL/NOT CONFIGURED
- Lint: PASS/FAIL/NOT CONFIGURED
- Type check: PASS/FAIL/NOT CONFIGURED
- Accessibility: PASS/NEEDS REVIEW
- Mobile: PASS/NEEDS REVIEW
- SEO: PASS/NEEDS REVIEW
- Security: PASS/NEEDS REVIEW
- Performance: PASS/NEEDS REVIEW

## Remaining Issues
For each issue:
- Severity: BLOCKER / HIGH / MEDIUM / LOW
- Problem
- File/route
- Recommended action

## Human Decisions Needed
List only items requiring product owner/business/legal decisions.

---

# Important Principle

A site is not "production ready" simply because:
- it builds,
- it looks good,
- or the homepage works.

Production readiness means the important user journeys, accessibility, SEO, security, privacy, reliability, mobile experience, metadata, errors, forms, deployment configuration, and operational concerns have been checked and the known issues are explicit.

Always distinguish between:
- **implemented and verified**
- **implemented but not fully verified**
- **not implemented**
- **requires human/business decision**
