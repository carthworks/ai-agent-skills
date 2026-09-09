---
name: web-trust-and-compliance
description: Audit web applications and websites for legal compliance, consumer trust, privacy policies, terms of service, cookie consent, licensing, accessibility, and anti-dark-pattern practices. Use when auditing or preparing a site for launch, legal compliance review, privacy check, removing dark patterns, hidden fees, fake reviews, or verifying copyright and business details. Don't use for generic backend performance tuning or non-web tasks.
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

Inspect the live codebase, assets, pages, forms, and scripts to uncover legal vulnerabilities, privacy leaks, deceptive UI designs (dark patterns), hidden pricing tricks, fake social proof, and asset licensing issues.

---

## The 14 Core Compliance & Trust Pillars

Every audit evaluates the following 14 critical checkpoints:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       14 PILLARS OF TRUST & COMPLIANCE                      │
├──────────────────────────┬──────────────────────────┬───────────────────────┤
│ 1. Legal & Governance    │ 2. Privacy & Data Ethics │ 3. Consumer Trust & UX│
│ • Terms of Service (TOS) │ • Privacy Policy         │ • Anti-Dark Patterns  │
│ • Cookie Policy          │ • Cookie & Form Consent  │ • No Hidden Fees      │
│ • Refund/Return Policy   │ • SDK & Tracking Audit   │ • No Fake Reviews     │
│ • Business Disclosures   │ • Data Minimization      │ • Substantiated Claims│
├──────────────────────────┴──────────────────────────┴───────────────────────┤
│ 4. Intellectual Property & Assets     5. Core Accessibility                 │
│ • Licenses, Copyright & Trademarks    • Alt Text, Contrast & Keyboard Nav   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Legal Policies & Corporate Disclosures

### 1.1 Privacy Policy
- **Requirement**: A dedicated, publicly accessible Privacy Policy page linked from the global footer and every form/signup page.
- **Content Checklist**:
  - Exact types of personal data collected (e.g. email, IP, cookies, telemetry).
  - Legal basis and purpose for processing (GDPR Art. 6 / CCPA / CPRA).
  - Third-party data recipients (analytics, CDNs, payment processors).
  - Data retention duration and storage locations.
  - User rights instructions (access, rectification, erasure/deletion, portability).
  - Contact details of Data Protection Officer (DPO) or privacy team.

### 1.2 Terms of Service (TOS) / Terms of Use
- **Requirement**: Comprehensive terms governing user rights, limitations, account usage, and liability.
- **Content Checklist**:
  - Acceptable use rules and prohibited behaviors.
  - User-generated content ownership, intellectual property rights, and DMCA notice procedure.
  - Limitation of liability, warranty disclaimers, and dispute resolution / governing law clause.
  - Clear account termination conditions.

### 1.3 Cookie Policy
- **Requirement**: Distinct cookie declaration or detailed privacy section.
- **Content Checklist**:
  - Categorization of cookies: Strictly Necessary, Functional, Analytics/Performance, Advertising/Targeting.
  - Specific cookie tables: cookie name, provider, purpose, and expiration lifespan.
  - Plain instructions on how users can withdraw or adjust cookie preferences anytime.

### 1.4 Refund & Cancellation Policy
- **Requirement**: Clear, unambiguous refund and cancellation terms linked in footer and checkout step.
- **Content Checklist**:
  - Eligibility windows (e.g. 14-day statutory right of withdrawal, 30-day money-back guarantee).
  - Subscription cancellation procedure (must be self-serve and straightforward).
  - Processing timeline and payment method for refunds.
  - Explicit terms for non-refundable items or digital downloads.

### 1.5 Business Identity & Contact Details
- **Requirement**: Transparency regarding the operating legal entity.
- **Content Checklist**:
  - Full registered business/company name and legal structure (LLC, Inc, Ltd, GmbH, etc.).
  - Physical registered business address (not just a P.O. Box where required by jurisdiction).
  - Business registration number / Company number / Tax ID (VAT, GST, EIN, etc.).
  - Direct, functioning contact channels (email, phone, or live support contact form).

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

### 3.2 Transparent Pricing (Remove Hidden Fees & Drip Pricing)
- **Requirement**: Complete, upfront price clarity across the entire user journey.
- **Audit Rules**:
  - All mandatory fees (service charges, booking fees, processing fees, mandatory taxes) must be displayed upfront on product/pricing pages, not revealed at the final checkout step.
  - Subscription frequencies must be explicit (e.g. "$120/year billed annually", not simply "$10/mo" in giant text with tiny annual billing disclaimer).
  - Renewal terms and price increases after promotional periods must be prominent.

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
1. Scan project routes, footer components, and navigation menus for legal links (`/privacy`, `/terms`, `/cookies`, `/refunds`, `/contact`).
2. Inspect package dependencies, scripts, and asset directories (`/public`, `/assets`, `/images`, `/fonts`).
3. Audit forms, newsletter signups, modals, and checkout / billing components.

### Phase 2 — Triage & Severity Classification
Group all findings into the standard severity levels:
- **BLOCKER**: Missing Privacy Policy / TOS on live transaction or data-collection site; non-compliant payment data collection; deceptive forced subscriptions; illegal copyright infringement.
- **HIGH**: Pre-ticked consent boxes; analytics firing before cookie consent; hidden checkout fees / drip pricing; fake reviews or unsubstantiated guarantees; inaccessible forms.
- **MEDIUM**: Missing business registration number / physical address; missing cookie category toggles; missing font license documentation; confirm-shaming copy; color contrast failures.
- **LOW**: Minor copy clarity polish, missing aria labels on decorative icons.

### Phase 3 — Remediation & Code Fixes
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
| 1 | Privacy Policy | Missing DPO contact & retention details | MEDIUM | OPEN | Add retention clause & contact email |
| 2 | Cookie Consent | Google Analytics loads before consent | HIGH | OPEN | Wrap script injection in consent gate |
| 3 | Dark Patterns | Confirm-shaming on discount modal | HIGH | FIXED | Replace with neutral "No thanks" |
| 4 | Hidden Fees | $5 handling fee added only on Step 3 | BLOCKER| OPEN | Display total itemized cost on Step 1 |
| 5 | Accessibility | Low contrast on secondary button (#888 on #fff)| MEDIUM | FIXED | Increase text contrast to #4b5563 (4.8:1)|

---

## Detailed Findings & Action Items

### 1. Legal & Regulatory Compliance
- [x] Privacy Policy URL linked across all layouts.
- [ ] Terms of Service updated with limitation of liability and governing law.
- [ ] Registered business address and entity identifier added to footer / contact page.

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
