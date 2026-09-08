# Accessibility, responsive, and cross-browser

Read for every project.

Before starting: much of this section needs a rendering browser. Check what Phase 0 established. Source inspection catches semantics, labels, and alt text. It does **not** catch contrast, focus visibility, overflow, or layout breakage — those need something that actually renders. Be explicit about which half you did.

## Accessibility

Structure and semantics:

- Semantic HTML before ARIA. A `div` with a click handler and `role="button"` is worse than a `button` in every respect.
- ARIA only where semantic HTML genuinely cannot express the pattern, and only where you can state what it does.
- Heading hierarchy reflects document structure.
- Landmarks (`main`, `nav`, `header`, `footer`) present.
- Skip-to-content link where navigation is long.

Keyboard and focus:

- Every interactive element is reachable and operable by keyboard.
- Focus is visibly indicated. Removing the default outline without replacing it is a defect, not a style choice.
- Tab order follows visual order.
- Modals and dialogs trap focus while open, restore it on close, and close on Escape.
- No keyboard traps anywhere else.

Forms:

- Every input has an associated label. Placeholder text is not a label — it disappears on focus and fails most assistive tooling.
- Required fields are marked programmatically, not only visually.
- Errors are associated with their field and announced, not just rendered in red somewhere nearby.

Content:

- Informative images have alt text describing their information. Decorative images use `alt=""`.
- Do not write "image", "photo", or keyword strings as alt text. Empty is better than noise.
- Color is never the only carrier of meaning — pair it with text, icon, or shape.
- Contrast is adequate. This needs measurement, not judgment; if you cannot measure, say so.
- `prefers-reduced-motion` respected wherever motion is significant.

Targets:

- Touch targets are large enough and spaced enough to hit on a phone.

## Responsive and mobile

Test at small phone, large phone, tablet, and desktop widths at minimum.

- No horizontal overflow at any width. This is the most common mobile defect and usually traces to a fixed width, a long unbroken string, or an unconstrained image or table.
- Navigation and menus work, including opening, closing, and closing on route change.
- Tables remain usable — scroll container, stacked layout, or reduced columns.
- Forms are usable, and the on-screen keyboard does not obscure the field being typed into or break the layout.
- Buttons are tappable without precision.
- Modals fit within the viewport and scroll internally when content is long.
- Text does not overlap or clip.
- Images scale and do not distort.
- Sticky or fixed elements do not cover content or the final actionable element on a page.

## Cross-browser

Exercise the important flows in a modern Chromium browser, Firefox, and Safari/WebKit where available.

WebKit is where cross-browser defects concentrate — date inputs, flex and grid edge cases, `100vh` behavior with mobile browser chrome, scroll behavior, and clipboard permissions all differ there. If no WebKit build is available in this environment, say so directly rather than implying coverage; on Linux, Playwright's WebKit build is the practical substitute for real Safari and is worth installing if the project is public-facing.

Check across browsers: layout, forms, authentication flows, modals, file uploads, clipboard actions, any newer web API in use, and any recent CSS feature the project relies on.
