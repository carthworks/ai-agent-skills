# Security, authentication, and platform behavior

Read for every project. The authentication and backend portions apply only where those exist.

Standing rule from the main skill: never weaken a security control to make a feature work, and never print secret values into the report. Report that a key is exposed and where — never what it is.

## Common web security problems

- Secrets committed to source control, including in history, `.env` files, config, and fixtures.
- API keys or credentials present in the frontend bundle. Check the built output, not just the source.
- Unsafe HTML injection — `dangerouslySetInnerHTML`, `v-html`, `innerHTML` on anything derived from user input or an external source.
- User input reaching a query, a shell, a file path, or a template without validation.
- Missing authorization checks on operations that need them.
- Authorization enforced only in the client. Hidden UI is not access control.
- Insecure direct object references — object IDs accepted from the client without checking ownership.
- Weak password handling: plaintext, reversible encryption, fast hashes. Use a memory-hard algorithm.
- Missing CSRF protection on cookie-authenticated state-changing requests.
- Unvalidated redirects, especially post-login `returnTo` parameters.
- File uploads without type, size, and content validation, or served back from a path that allows execution.
- API responses containing internal fields the client should never see — password hashes, internal flags, other users' data embedded in a payload.
- Debug endpoints, admin routes, or verbose error output reachable in production.
- CORS configured with a permissive origin alongside credentials.
- Missing security headers.

## Authentication and authorization

Where authentication exists:

- Login and logout work, and logout actually invalidates rather than only clearing the client.
- Session persistence behaves as intended across reloads.
- Sessions expire, and expiry is handled gracefully in the UI.
- Protected routes are enforced **server-side**. Verify by requesting a protected API endpoint directly, without the UI, using no credentials and then wrong-user credentials. A client-side route guard proves nothing.
- Role and permission checks happen on the server, per request.
- Password reset does not leak account existence, uses single-use time-limited tokens, and invalidates sessions on change.
- Account deletion behaves as documented where offered.
- OAuth redirect URIs are registered for the production domain and do not include wildcards or development hosts.

## HTTP and platform behavior

- HTTPS enforced in production, with HTTP redirected.
- Redirects are correct and not chained or looping.
- Cookies set `Secure`, `HttpOnly` where the client does not need to read them, and an appropriate `SameSite`.
- HSTS where the domain is committed to HTTPS.
- Content Security Policy where practical. A reporting-only policy is a reasonable first step and better than none.
- `X-Content-Type-Options: nosniff`.
- A sensible referrer policy.
- Permissions policy where powerful features are unused and should be disabled.
- Cache headers correct — static assets cached hard with cache-busting names, HTML not cached in a way that pins users to a stale build.
- Compression enabled.
- Correct MIME types.
- No mixed content.

## Analytics and privacy

Where analytics or error monitoring exists:

- Configured for production, with development and test traffic excluded so the numbers mean something.
- Consent respected where required by the audience and the tracking in use.
- No personal or sensitive data sent into analytics — check what is in event payloads, URL parameters, and page titles, since these leak silently.
- Event names are meaningful and consistent.
- The conversion events that matter are actually instrumented.
- Error monitoring scrubs secrets, tokens, and personal data before transmission. Error payloads capture request context by default and are a routine source of accidental credential leakage.
