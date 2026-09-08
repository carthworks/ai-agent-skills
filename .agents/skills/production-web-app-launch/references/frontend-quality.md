# Frontend quality

Forms, error handling, interface states, dead links, polish, and performance. Read for every project.

Forms, errors, and polish all converge on the same underlying question — what the interface does when things are loading, empty, or broken — so they are audited together here to avoid reporting the same gap three times.

## Forms

For every form in the project:

- Input types match the data (`email`, `tel`, `number`, `url`), which improves both validation and the mobile keyboard.
- Labels present and associated.
- Required fields handled and communicated.
- Client-side validation for immediate feedback.
- Server-side validation wherever the submission reaches a server. Client validation is a convenience, never a control — anything enforced only in the browser is not enforced.
- Error messages say what to do, not just that something is wrong.
- A submission state exists so the user knows the click registered.
- Duplicate submission is prevented — disable on submit, or make the operation idempotent.
- Distinct, visible success and failure outcomes.
- Spam or rate-limit protection on public forms.
- Sensitive fields are not logged, echoed back, or persisted where they should not be.
- No secrets embedded in client-side code. Anything shipped to the browser is public, whatever the variable is named.

## Error handling

- Custom 404 page that offers a route back rather than dead-ending.
- Error boundary or equivalent so one failing component does not blank the whole app.
- API errors are caught and surfaced meaningfully.
- Network failure and timeout are handled distinctly from a server error.
- Retry where the operation is safe to retry.
- Session and authentication expiry is handled — a silent redirect loop or a blank screen is a common and confusing failure.
- Production error output never exposes stack traces, secrets, database details, internal paths, or architecture.

## Interface states

Every view that fetches data needs all four defined:

- Loading — skeleton or spinner, sized to prevent layout shift.
- Empty — explains why it is empty and what to do about it.
- Error — recoverable where possible.
- Populated.

Missing empty states are the most frequent gap and the most visible on day one, when every account is new and every list is empty.

## Links and routes

Check internal links, navigation, footer, CTA targets, navigating buttons, dynamic routes, external links, images and assets, and any API endpoint the frontend references.

Fix or remove: links that 404, placeholder `#` hrefs that should navigate, buttons wired to nothing, routes rendering a blank screen, and any link pointing at localhost, a staging host, or a preview deployment.

## UI polish

- Spacing, border radius, and shadow follow one consistent convention rather than several.
- Typographic hierarchy is deliberate.
- Buttons have hover, focus, active, disabled, and loading states.
- No visual clipping or overflow at standard widths.
- No leftover debug UI, test data, or dev-only panels.
- No unstyled browser-native components sitting inside otherwise custom UI.

## Performance

- Production build succeeds. Nothing downstream matters if this fails.
- Images are optimized, correctly sized, in a modern format, and lazy-loaded below the fold. Oversized hero images are the most common single cause of a slow first load.
- Fonts do not block render unnecessarily; subset where practical and set an appropriate `font-display`.
- Bundle size is reasonable — inspect the actual build output rather than guessing.
- Code splitting where it demonstrably helps.
- Third-party scripts minimized; each one is a performance and privacy cost.
- Large dependencies identified, with lighter alternatives noted where they exist.
- Caching headers and cache busting are sensible.
- No duplicated or waterfalled API requests on core screens.
- Core user flows feel responsive.

Do not optimize blindly. Measure, or read the build output, or say you did neither.
