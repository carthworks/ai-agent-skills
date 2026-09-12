---
name: developer-console-signature
description: Inject styled developer signatures, author branding, project metadata, ASCII art, easter eggs, security contact information, and interactive DevTools inspection helpers (window.<App>) into the browser console log. Use whenever the user asks to add developer details, author info, console logs, branding banners, or DevTools easter eggs to a web app or website (React, Next.js, Vite, Vue, HTML).
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - console
    - branding
    - developer-signature
    - easter-egg
    - web
    - devtools
---

# Developer Console Signature & DevTools Branding

## Mission

Inject professional, styled developer signatures, author branding, project metadata, security disclosures, and interactive DevTools helpers into the browser console log (`console.log`) across modern web applications (Next.js, React, Vite, Vue, Vanilla HTML/JS).

Transform the browser console into a refined developer touchpoint that establishes software authenticity, showcases authorship, and provides interactive inspection tools for technical users and recruiters.

---

## The 5 Core Signature Pillars

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                     DEVELOPER CONSOLE SIGNATURE ARCHITECTURE                            │
├───────────────────────────────┬───────────────────────────────┬─────────────────────────┤
│ 1. Developer & Author Info    │ 2. Project & Build Info       │ 3. Visual & CSS Styling │
│ • Name & Social Handles       │ • Project Name & Description  │ • %c CSS Token Styling  │
│ • Email & Contact Links       │ • Version, Branch & Commit    │ • Gradient Headers      │
│ • GitHub, LinkedIn, Portfolio │ • License & Repo URL          │ • ASCII Art / Badges    │
├───────────────────────────────┼───────────────────────────────┼─────────────────────────┤
│ 4. Interactive DevTools API   │ 5. Safety & Performance       │ 6. Hiring & Security    │
│ • window.<AppName> Object     │ • Deduplicated Client Boot    │ • Security/Bug Bounty   │
│ • Helper methods (.help())    │ • Zero Sensitive Leaks        │ • We're Hiring Callouts │
│ • console.table() references  │ • SSR / StrictMode Guard      │ • Secret Hygiene Check  │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Structure of a High-Impact Console Signature

Every developer signature should consist of 4 distinct visual blocks:

### 1.1 Header Banner
A prominent badge or ASCII art block featuring the app name and a vibrant CSS gradient.

### 1.2 Author & Developer Profile
- **Developer Name**: e.g., `Karthikeyan T (@carthworks)`
- **Email**: `tkarthikeyan@gmail.com`
- **LinkedIn**: `https://www.linkedin.com/in/carthworks`
- **GitHub**: `https://github.com/carthworks`
- **Portfolio / Website**: `https://carthworks.github.io`
- **Mission**: A brief tagline or engineering philosophy.

### 1.3 Project & Repository Metadata
- **Project Name & Version**: `v1.2.0`
- **Repository Link**: `https://github.com/carthworks/ai-agent-skills`
- **License**: `Apache-2.0` / `MIT`
- **Documentation**: Live documentation or guide link.

### 1.4 Interactive DevTools Helper (`window.<AppName>`)
Expose an exploration object on `window` allowing fellow developers to run commands directly in DevTools (e.g., `App.help()`, `App.version`, `App.contact`).

---

## 2. Framework Implementation Patterns

### 2.1 Next.js (App Router) / React

Create a dedicated client component or utility hook:

```typescript
// components/ConsoleSignature.tsx or hooks/useConsoleSignature.ts
'use client';

import { useEffect, useRef } from 'react';

export function ConsoleSignature() {
  const initialized = useRef(false);

  useEffect(() => {
    if (initialized.current) return;
    initialized.current = true;

    // Prevent running during SSR or test environments
    if (typeof window === 'undefined') return;

    const titleStyle = 'font-size: 15px; font-weight: 700; color: #8b5cf6; background: #0f1117; padding: 6px 12px; border-radius: 6px; border: 1px solid rgba(139,92,246,0.4);';
    const labelStyle = 'font-weight: 600; color: #06b6d4;';
    const textStyle = 'color: #94a3b8;';
    const linkStyle = 'color: #8b5cf6; font-weight: 500; text-decoration: underline;';
    const quoteStyle = 'font-style: italic; color: #10b981;';

    console.log('%c🧠 Developer Agent Stack — ai-agent-skills', titleStyle);
    console.log(
      '%c👨‍💻 Developer:%c Karthikeyan T (@carthworks)\n' +
      '%c✉️  Email:     %ctkarthikeyan@gmail.com\n' +
      '%c💼 LinkedIn:  %chttps://www.linkedin.com/in/carthworks\n' +
      '%c🐙 GitHub:    %chttps://github.com/carthworks\n' +
      '%c📦 Project:   %chttps://github.com/carthworks/ai-agent-skills\n' +
      '%c📜 License:   %cApache-2.0\n' +
      '%c✨ Mission:   %c"Supercharging the next generation of software engineering."',
      labelStyle, textStyle,
      labelStyle, textStyle,
      labelStyle, linkStyle,
      labelStyle, linkStyle,
      labelStyle, linkStyle,
      labelStyle, textStyle,
      labelStyle, quoteStyle
    );

    console.log(
      '%c💡 Quick Tip:%c Run %cAgentStack.help()%c in this console to interactively explore available tools!',
      'font-weight:bold; color:#f59e0b;',
      'color:#94a3b8;',
      'font-family:monospace; color:#06b6d4; background:rgba(6,182,212,0.1); padding:1px 4px; border-radius:3px;',
      'color:#94a3b8;'
    );

    // Global DevTools Helper
    (window as any).AgentStack = {
      developer: {
        name: 'Karthikeyan T',
        handle: '@carthworks',
        email: 'tkarthikeyan@gmail.com',
        linkedIn: 'https://www.linkedin.com/in/carthworks',
        github: 'https://github.com/carthworks'
      },
      project: {
        name: 'Developer Agent Stack',
        repo: 'https://github.com/carthworks/ai-agent-skills',
        license: 'Apache-2.0'
      },
      help: () => {
        console.table({
          'AgentStack.developer': 'Author and contact information',
          'AgentStack.project': 'Repository and licensing metadata'
        });
        return '🚀 Ready to inspect!';
      }
    };
  }, []);

  return null;
}
```

Include `<ConsoleSignature />` inside your root `app/layout.tsx` or `pages/_app.tsx`.

---

### 2.2 Vanilla HTML / JavaScript / Vite

Add directly in your main script or entrypoint:

```javascript
// src/main.js or inline <script>
(function initConsoleSignature() {
  if (typeof window === 'undefined') return;

  const headerStyle = 'font-size: 14px; font-weight: bold; background: linear-gradient(135deg, #8b5cf6, #06b6d4); color: white; padding: 4px 10px; border-radius: 4px;';
  const labelStyle = 'color: #06b6d4; font-weight: bold;';
  const valStyle = 'color: #94a3b8;';
  const linkStyle = 'color: #a78bfa; text-decoration: underline;';

  console.log('%c🚀 My Application v1.0.0', headerStyle);
  console.log(
    '%cCrafted by:%c Karthikeyan T (@carthworks)\n' +
    '%cLinkedIn:  %chttps://www.linkedin.com/in/carthworks\n' +
    '%cGitHub:    %chttps://github.com/carthworks',
    labelStyle, valStyle,
    labelStyle, linkStyle,
    labelStyle, linkStyle
  );

  window.MyApp = {
    version: '1.0.0',
    developer: 'Karthikeyan T (@carthworks)',
    help: () => console.log('Welcome to MyApp DevTools helper!')
  };
})();
```

---

## 3. Production Rules & Safety Checklist

When injecting console signatures into any web project, always enforce these rules:

- [ ] **Run Exactly Once**: Guard with `useRef(false)` in React or an IIFE flag to avoid duplicate logs in React 18+ `StrictMode`.
- [ ] **No Sensitive Data**: NEVER print `.env` secrets, API private keys, database connection strings, JWT tokens, or internal credentials.
- [ ] **Zero Performance Impact**: Do not perform heavy synchronous loops, unmemoized JSON parsing, or network requests during console initialization.
- [ ] **Graceful Degradation**: Guard against headless environments, SSR, or Node.js runtimes with `typeof window !== 'undefined'`.
- [ ] **Safe Links**: Ensure all portfolio, GitHub, and social links use `https://`.
