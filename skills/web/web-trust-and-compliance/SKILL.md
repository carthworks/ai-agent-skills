---
name: web-trust-and-compliance
description: Audit web applications and websites for legal compliance, consumer trust, privacy policies, terms of service / terms & conditions, cancellation/refund policies, about & contact pages, pricing & support information, cookie consent, licensing, accessibility, and anti-dark-pattern practices. Use when auditing or preparing a site for launch, legal compliance review, privacy check, trust verification, removing dark patterns, hidden fees, fake reviews, or verifying copyright and business details. Don't use for generic backend performance tuning or non-web tasks.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - compliance
    - privacy
    - trust
    - legal
    - accessibility
    - web
---

# Web Trust & Compliance Audit

## Mission

Transform websites and web applications into legally sound, privacy-respecting, transparent, and trustworthy digital products before or after launch.

Inspect the live codebase, assets, pages, forms, and scripts to uncover legal vulnerabilities, privacy leaks, deceptive UI designs (dark patterns), hidden pricing tricks, fake social proof, missing trust pages (About, Contact, Privacy, Terms, Cancellation/Refund, Pricing/Support), and asset licensing issues.

---

## The 6 Essential Trust Anchors & Core Pillars

Every consumer-facing website and web app must provide clear, easily discoverable trust anchors and meet compliance standards:

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           CORE TRUST ANCHORS & COMPLIANCE                               │
├───────────────────────────────┬───────────────────────────────┬─────────────────────────┤
│ 1. Essential Trust Pages      │ 2. Legal & Governance         │ 3. Privacy & Ethics     │
│ • About Page (/about)         │ • Terms & Conditions (T&C/TOS)│ • Privacy Policy        │
│ • Contact Page (/contact)     │ • Cancellation/Refund Policy  │ • Cookie & Form Consent │
│ • Pricing & Support Info      │ • Business & Tax Disclosures  │ • Data Minimization     │
├───────────────────────────────┼───────────────────────────────┼─────────────────────────┤
│ 4. Consumer Protection & UX   │ 5. Intellectual Property      │ 6. Core Accessibility   │
│ • Anti-Dark Patterns / FTC    │ • Licenses & Copyright        │ • WCAG 2.1 AA Standards │
│ • Upfront Transparent Pricing │ • Font & Stock Asset Audits   │ • Alt Text & Contrast   │
│ • Authentic Social Proof      │ • Third-Party Trademarks      │ • Keyboard Navigation   │
└───────────────────────────────┴───────────────────────────────┴─────────────────────────┘
```

---

## 1. Essential Trust Pages & Legal Policies

### 1.1 About Page & Company Identity
- **Requirement**: A dedicated, publicly accessible About page (`/about` or `/about-us`) linked from the primary navigation and/or global footer.
- **Content Checklist**:
  - Clear narrative on company background, origin, and core mission.
  - Identification of the operating entity, founders, leadership team, or managing organization.
  - Physical headquarters / operating country / jurisdiction to establish legitimate corporate presence.
  - Verifiable business credentials, certifications, or regulatory registrations where applicable.

### 1.2 Contact Page & Direct Support Channels
- **Requirement**: A dedicated Contact page (`/contact`, `/contact-us`, or `/support`) easily accessible from the header and footer with functioning, verified communication channels.
- **Content Checklist**:
  - Direct, monitored contact email address (e.g. `support@domain.com`, `contact@domain.com`).
  - Physical registered business address and mailing location.
  - Telephone support number or live chat widget where available.
  - Working contact form with clear submission confirmation, error handling, and privacy consent note.
  - Stated support hours of operation and expected response time SLA (e.g., "We respond within 24 hours on business days").

### 1.3 Privacy Policy
- **Requirement**: A dedicated, comprehensive Privacy Policy page (`/privacy` or `/privacy-policy`) linked in the global footer, signup pages, contact forms, and checkout steps.
- **Content Checklist**:
  - Exact categories of personal data collected (e.g., names, emails, IP addresses, telemetry, device identifiers).
  - Legal bases and explicit purposes for processing under applicable privacy regulations (GDPR Art. 6, CCPA/CPRA, etc.).
  - Third-party data recipients and sub-processors (analytics, CDNs, hosting providers, payment processors).
  - Data retention periods and international data transfer safeguards.
  - Explicit user rights and instructions for exercising them (access, correction, export, deletion, opt-out).
  - Direct contact details for the Data Protection Officer (DPO) or privacy compliance team.

### 1.4 Terms & Conditions (T&C) / Terms of Service (TOS)
- **Requirement**: A comprehensive Terms & Conditions / Terms of Service agreement (`/terms`, `/terms-and-conditions`, or `/tos`) linked in the global footer, registration forms, and purchase flows.
- **Content Checklist**:
  - Acceptable use policies, account responsibilities, and prohibited activities.
  - Intellectual property rights, license grants, and user-generated content terms.
  - Warranty disclaimers, limitation of liability, and indemnification provisions.
  - Governing law, jurisdiction, and dispute resolution mechanisms (e.g., arbitration or venue selection).
  - Termination clauses detailing suspension or cancellation of user accounts.

### 1.5 Cancellation & Refund Policy
- **Requirement**: A clear, unambiguous Cancellation and Refund Policy (`/refund`, `/cancellation`, or `/refund-policy`) linked in the global footer, pricing pages, and checkout workflows.
- **Content Checklist**:
  - Explicit refund eligibility window (e.g., 14-day statutory right of withdrawal, 30-day money-back guarantee).
  - Clear, step-by-step self-serve cancellation instructions (FTC Click-to-Cancel compliance: cancellation must be as easy as signing up).
  - Detailed refund processing timelines (e.g., "Refunds processed within 5-7 business days") and payout methods.
  - Clearly articulated terms for non-refundable items, prorated billing, digital downloads, or service tiers.

### 1.6 Pricing & Support Information
- **Requirement**: Transparent pricing breakdowns and comprehensive customer support information available upfront on pricing pages (`/pricing`), product pages, and help centers (`/help`, `/support`).
- **Content Checklist**:
  - **Pricing Transparency**:
    - Itemized tier pricing, billing intervals (monthly vs. annual), recurring renewal terms, and trial conversion dates.
    - Upfront disclosure of applicable taxes, VAT, currency, and zero hidden checkout fees (no drip pricing).
  - **Support Information**:
    - Direct access to support portals, FAQs, ticketing systems, documentation, or knowledge base.
    - Clearly communicated support availability, escalation paths, and service level agreements (SLAs).

### 1.7 Cookie Policy & Business Disclosures
- **Requirement**: Detailed cookie disclosures and verified legal entity identification.
- **Content Checklist**:
  - Categorization of cookies (Strictly Necessary, Functional, Analytics/Performance, Advertising/Targeting).
  - Table of active cookies: name, provider, purpose, and expiration lifespan.
  - Clear instructions and mechanisms for users to update or revoke cookie preferences at any time.
  - Full registered corporate legal name, entity type (LLC, Inc, Ltd, GmbH, etc.), and official registration/tax IDs (VAT, GST, EIN).

---

## 2. Privacy, Consent & Tracking Audits

### 2.1 Cookie & Form Consent Controls
- **Requirement**: Granular, explicit, prior consent before any non-essential data collection.
- **Audit Rules**:
  - **No Pre-checked Checkboxes**: Marketing opt-ins and newsletters must require explicit opt-in (GDPR compliant).
  - **Prior Consent**: Analytics and advertising scripts must not execute until the user clicks "Accept".
  - **Equal Choice**: "Reject All" / "Decline" option must have equal visual prominence and simplicity as "Accept All" (no dark pattern button contrast).
  - **Consent Logging**: Consent state must be recorded with timestamp and preference category.

### 2.2 Third-Party SDKs, External Tools & Analytics Audit
- **Requirement**: Comprehensive inventory of all third-party code.
- **Audit Rules**:
  - Audit all `<script>` tags, CDN imports, Tag Managers, tracking pixels (Meta Pixel, Google Tag Manager, TikTok Pixel, Hotjar, Mixpanel, Sentry, Clarity).
  - Ensure external tools are declared in the Privacy Policy.
  - Verify that analytics events do NOT leak Personally Identifiable Information (PII) such as plaintext emails, names, phone numbers, or passwords into URL queries or event properties.
  - Implement Content Security Policy (`CSP`) headers restricting unauthorized third-party script injection.

### 2.3 Data Minimization (Don't Collect Unnecessary & Sensitive Data)
- **Requirement**: Collect only the minimum personal data strictly necessary for the immediate function.
- **Audit Rules**:
  - Eliminate unnecessary form fields (e.g. requiring phone number, physical address, or date of birth for a simple newsletter or free account).
  - Never collect sensitive personal data (health, religion, biometric, government IDs) unless strictly mandated and safeguarded.
  - Use PCI-DSS compliant iframe/tokenization (e.g. Stripe Elements, PayPal SDK) for credit card data — never send raw card numbers to application servers.

---

## 3. Consumer Protection & Ethical UX

### 3.1 Anti-Dark Patterns
- **Requirement**: Honest UI/UX that respects user autonomy without coercion or deception.
- **Prohibited Patterns**:
  - **Click-to-Cancel Asymmetry**: Canceling a subscription or deleting an account must be as fast and easy as signing up (FTC Click-to-Cancel Rule). No forcing phone calls or complex maze-like cancellation flows.
  - **Confirm-shaming**: Manipulative decline copy (e.g. "No thanks, I don't want to save money", "No, I prefer paying full price").
  - **Sneak into Basket**: Automatically adding warranties, recurring subscriptions, or companion items to the user's cart without active selection.
  - **Forced Continuity**: Free trials converting silently without prior notice or easy cancellation before billing.
  - **Fake Urgency / Scarcity**: Fabricated countdown timers, fake stock counters ("Only 2 left!"), or fake live purchase toasts ("Someone in Seattle just bought this!").

### 3.2 Transparent Pricing & Support Information
- **Requirement**: Complete, upfront price clarity across the entire user journey with accessible support guidance.
- **Audit Rules**:
  - All mandatory fees (service charges, booking fees, processing fees, mandatory taxes) must be displayed upfront on product/pricing pages, not revealed at the final checkout step.
  - Subscription frequencies must be explicit (e.g. "$120/year billed annually", not simply "$10/mo" in giant text with tiny annual billing disclaimer).
  - Renewal terms, trial conversion dates, and price increases after promotional periods must be prominent.
  - Accessible customer support channels, SLAs, and troubleshooting links must be linked alongside pricing plans and purchase confirmations.

### 3.3 Authentic Social Proof (Remove Fake Reviews & Testimonials)
- **Requirement**: All reviews, testimonials, ratings, and endorsements must represent real, verifiable experiences.
- **Audit Rules**:
  - Remove hardcoded generic testimonials with fake user avatars, stock photo models, or placeholder names ("John D., CEO").
  - Disclose any material connection or incentivized reviews (FTC Endorsement Guides).
  - Do not suppress negative reviews or cherry-pick only 5-star ratings misleadingly.

### 3.4 Substantiated Claims (Remove Unsupported & Exaggerated Claims)
- **Requirement**: Every objective performance, health, security, or comparative claim must be verifiable.
- **Audit Rules**:
  - Audit superlative claims ("#1 Rated", "100% Unhackable", "Guaranteed 10x ROI", "Doctor Recommended", "Fastest Platform").
  - Require citations, verifiable benchmarks, third-party certifications, or clear qualification of marketing puffery vs factual representations.

---

## 4. Intellectual Property & Asset Licensing

### 4.1 Licenses, Copyright & Trademarks
- **Requirement**: Ensure all site assets have verified licensing and proper attribution.
- **Audit Rules**:
  - **Fonts**: Confirm web font licenses (SIL Open Font License, Google Fonts, Adobe Fonts, commercial license covering pageviews/domains).
  - **Images, Vectors & Icons**: Verify stock photos, illustrations, icon packs (Heroicons, Lucide, FontAwesome, Unsplash, Freepik) comply with license requirements. Replace any unlicensed or watermarked assets.
  - **Third-Party Trademarks**: Ensure proper trademark notices (® / ™) and avoid infringing use of partner/vendor logos without permission.
  - **Code Dependencies**: Audit `package.json` / dependency licenses (`license-checker`) to ensure no viral GPL incompatibilities in proprietary commercial distributions.

---

## 5. Core Accessibility & Inclusivity

### 5.1 Baseline Accessibility (WCAG 2.1 AA)
- **Requirement**: Accessible, perceivable, and operable for all users.
- **Audit Rules**:
  - **Alt Text**: All informative `<img>`, `<svg>`, and graphic elements must have accurate `alt` text. Purely decorative graphics must use `alt=""` or `aria-hidden="true"`.
  - **Color Contrast**: Text and interactive UI components must meet minimum WCAG contrast ratios (minimum 4.5:1 for normal text, 3:1 for large text / graphical objects).
  - **Keyboard Navigation**: Full keyboard operability (Tab, Shift+Tab, Enter, Space, Escape), visible `:focus-visible` focus outlines, logical tab order, and no keyboard traps.
  - **Form Accessibility**: Every form input must have an explicitly associated `<label>` or `aria-label`.

---

## Step-by-Step Audit Workflow

### Phase 1 — Codebase & Asset Inventory
1. Scan project routes, navigation menus, and global footers for essential trust pages and legal links:
   - About page: `/about`, `/about-us`
   - Contact page: `/contact`, `/contact-us`
   - Privacy Policy: `/privacy`, `/privacy-policy`
   - Terms & Conditions / Terms of Service: `/terms`, `/terms-and-conditions`, `/tos`
   - Cancellation & Refund Policy: `/refund`, `/cancellation`, `/refund-policy`
   - Pricing & Support Information: `/pricing`, `/support`, `/help`, `/faq`
2. Inspect package dependencies, scripts, and asset directories (`/public`, `/assets`, `/images`, `/fonts`).
3. Audit forms, newsletter signups, modals, and checkout / billing components.

### Phase 2 — Triage & Severity Classification
Group all findings into the standard severity levels:
- **BLOCKER**: Missing Privacy Policy / Terms & Conditions on live transaction or data-collection site; non-compliant payment data collection; deceptive forced subscriptions; hidden checkout fees; illegal copyright infringement.
- **HIGH**: Missing Cancellation/Refund policy or About/Contact pages; pre-ticked consent boxes; analytics firing before cookie consent; fake reviews or unsubstantiated guarantees; inaccessible forms.
- **MEDIUM**: Missing business registration number / physical address; missing cookie category toggles; missing font license documentation; confirm-shaming copy; color contrast failures.
- **LOW**: Minor copy clarity polish, missing aria labels on decorative icons.

### Phase 3 — Remediation & Code Fixes
- Add missing trust pages and routes (About, Contact, Privacy Policy, Terms & Conditions, Cancellation/Refund Policy, Pricing/Support Info).
- Fix accessibility attributes (`alt`, `aria-label`, focus rings).
- Remove deceptive copy, pre-checked checkboxes, and fake urgency timers.
- Generate compliant boilerplate templates for missing policy routes if requested.
- Wire up explicit consent states and data minimization form cleanups.

---

## Audit Report Format

```markdown
# Trust, Compliance & Legal Readiness Report

## Executive Summary
**Compliance Status**: COMPLIANT / ACTION REQUIRED / NON-COMPLIANT
**Risk Level**: LOW / MEDIUM / CRITICAL

---

## Findings Matrix

| # | Pillar | Finding | Severity | Status | Recommended Fix |
|---|--------|---------|----------|--------|-----------------|
| 1 | About & Contact | Missing direct contact email & company origin | HIGH | OPEN | Create /contact & /about with physical address & email |
| 2 | Privacy Policy | Missing DPO contact & retention details | MEDIUM | OPEN | Add retention clause & contact email |
| 3 | Terms & Conditions | Missing limitation of liability & governing law | BLOCKER | OPEN | Add standard governing law and liability caps |
| 4 | Cancellation/Refund | No self-serve cancellation flow documented | HIGH | OPEN | Add transparent refund timelines & 1-click cancel steps |
| 5 | Pricing & Support | $5 handling fee added only on Step 3 | BLOCKER | OPEN | Display total itemized cost and support SLA upfront |
| 6 | Cookie Consent | Google Analytics loads before consent | HIGH | OPEN | Wrap script injection in consent gate |
| 7 | Dark Patterns | Confirm-shaming on discount modal | HIGH | FIXED | Replace with neutral "No thanks" |
| 8 | Accessibility | Low contrast on secondary button (#888 on #fff)| MEDIUM | FIXED | Increase text contrast to #4b5563 (4.8:1)|

---

## Detailed Findings & Action Items

### 1. Essential Pages & Legal Policies
- [ ] **About Page**: Add company narrative, leadership/team info, and operating location.
- [ ] **Contact Page**: Provide working email, physical address, support hours, and contact form.
- [ ] **Privacy Policy**: Link Privacy Policy across all footers, signups, and checkout steps.
- [ ] **Terms & Conditions**: Update with acceptable use, dispute resolution, and liability limits.
- [ ] **Cancellation/Refund Policy**: Publish explicit return windows and self-serve cancellation process.
- [ ] **Pricing & Support Information**: Ensure all pricing is upfront and support channels/SLAs are accessible.

### 2. Privacy & Consent
- [ ] Remove pre-checked marketing checkboxes on checkout form.
- [ ] Implement opt-in cookie consent barrier before tracking scripts.

### 3. Transparency & Consumer Ethics
- [ ] Remove hardcoded fake customer reviews from landing page.
- [ ] Verify claims ("100% Guaranteed") and add qualification or citation.

### 4. Assets & Licensing
- [x] Fonts verified under SIL Open Font License.
- [x] All stock images have documented commercial licenses.

### 5. Accessibility
- [x] Keyboard focus visible across all navigation items.
- [x] Alt text added to product showcase images.

---

## Next Steps for Legal & Business Signoff
List specific items that require legal counsel or business management approval (e.g. specific refund duration, official business entity registration).
```
