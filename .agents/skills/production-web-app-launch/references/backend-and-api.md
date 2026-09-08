# Backend, API, and operations

Read only when the project has a backend, an API, or a database. Skip entirely for a static site — an audit padded with N/A rows for database backups on a portfolio page wastes the owner's attention.

## Database and backend reliability

- Migrations are reproducible from a clean state and run in order.
- The production schema is compatible with the application code being deployed. Deploy ordering matters — a migration that removes a column the currently running code still reads will break production during the rollout window.
- Connection configuration is production-appropriate: pooling sized for the runtime, sensible timeouts, TLS where the connection crosses a network.
- Queries on paths that will grow have indexes. A table scan is invisible at 100 rows and fatal at 100,000.
- Input is validated before it reaches the database.
- Multi-step writes use transactions so a failure halfway does not leave inconsistent state.
- Error paths do not leave partial or corrupt state.
- Rate limiting on expensive or abuse-prone endpoints.
- Background jobs have failure handling, retry with backoff, and a visible dead-letter path — silent job failure is a common way data quietly stops being processed.
- Health check endpoint where the platform can use one.

## API quality

- Authentication and authorization enforced per endpoint, not assumed from the gateway or the UI.
- Input validated against a schema, including types, ranges, and unexpected fields.
- Correct HTTP status codes — a 200 carrying an error body defeats client error handling and monitoring.
- One consistent error format across the API.
- Rate limiting on abuse-prone endpoints: auth, search, anything sending mail, anything expensive.
- Pagination on any collection that can grow.
- Timeouts on outbound calls.
- Retries only on idempotent operations.
- Responses do not include internal fields — serialize explicitly rather than returning whole records.
- Documentation where the API has consumers beyond this codebase.

## Observability

- Error monitoring is configured and actually receiving events. Verify with a test event if possible; a monitoring integration that was never confirmed is a common false comfort.
- Server logs are captured and retrievable after a restart or redeploy.
- Important application events are logged with enough context to reconstruct what happened.
- Health endpoint where useful.
- Performance monitoring where load is expected.
- Alerts exist for the failures that matter, routed to someone who will see them.
- No secrets or personal data in logs.

## Backup and recovery

Where persistent data exists:

- Database backups are configured, running, and retained on a schedule that matches how much data loss the product can tolerate.
- The restore procedure has been performed at least once. An untested backup is a hypothesis.
- Migration rollback strategy exists, or the forward-only approach is deliberate and stated.
- User-uploaded files are backed up too — they usually live outside the database and are usually forgotten.
- Someone is identified as responsible for recovery.

Do not report that backups exist because the platform offers them. Confirm they are enabled for this project, or mark NOT VERIFIED.
