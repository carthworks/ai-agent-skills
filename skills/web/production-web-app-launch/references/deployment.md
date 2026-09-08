# Production configuration and deployment

Read for every project. The PWA section applies only where the product is meant to be installable.

## Production configuration

- Production environment variables are defined wherever the app runs, and the app fails loudly at startup on a missing required one rather than silently misbehaving later.
- No hardcoded `localhost` URLs anywhere in code shipped to production.
- No development or staging API endpoints in the production build.
- Public base URL is correct — canonical tags, OG images, sitemaps, and email links all depend on it, and a wrong value fails quietly in ways nobody notices for weeks.
- API base URL correct for the production environment.
- OAuth redirect URIs registered for the production domain.
- CORS origins list the production origin and do not include a permissive wildcard.
- Database configuration points at production, with appropriate credentials and TLS.
- Logging level appropriate — debug logging in production is both noise and a leak risk.
- Error monitoring configured with the right environment tag.
- Build and deploy scripts work from a clean checkout.
- The runtime version the platform will use matches what the project requires. Confirm the platform's actual default rather than assuming it matches your local version.
- Environment-specific config is separated cleanly rather than branching on hostname deep in application code.

Never print environment variable values into the report. Naming a required variable is fine; showing what it contains is not.

## Deployment and infrastructure

- Production build command is correct and reproducible.
- Start command is correct for the target runtime.
- Deployment configuration is committed rather than living only in a dashboard someone configured once.
- Required environment variables are documented so the next person can deploy without archaeology.
- Domain and DNS are configured, including the apex-versus-www decision and a redirect between them.
- HTTPS with valid certificates and automatic renewal.
- Health check wired to whatever the platform uses to decide the app is alive.
- A rollback path exists and is known — the answer to "the deploy is bad, what now" should not be improvised at the time.
- Migration strategy defined relative to deploys, including whether migrations run before or during the rollout.
- Static assets served with correct headers and cache busting.
- Serverless limits understood where applicable: execution timeout, payload size, cold start behavior, and whether anything depends on state persisting between invocations.
- Scheduled and background jobs are configured in the production environment, not only locally.

## PWA and installable behavior

Only if the product is genuinely meant to be installed. Do not add PWA machinery to a site that does not need it — a stale service worker serving cached assets is a genuinely difficult failure to diagnose and to fix remotely.

- Web app manifest present, valid, and linked.
- Icons at required sizes, including maskable.
- Theme and background colors set.
- Service worker registered with a deliberate caching strategy rather than a copied default.
- Offline behavior is defined, even if it is only a graceful offline page.
- Installability criteria met if install is the goal.
- **Update strategy is explicit.** This is the section that causes real production incidents: without a working update path, returning users are pinned to an old build indefinitely and cannot be reached by a deploy. Verify that a new deploy actually reaches an already-installed client.
