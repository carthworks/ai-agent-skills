---
name: vibe-ui-delight
description: |
  Inject modern UI/UX polish, micro-interactions, responsive mobile patterns,
  toast notifications, loading skeletons, empty states, and tactile feedback
  into rapid prototypes and vibe coded apps. Use when building or styling web
  prototypes, adding interactive feedback, fixing generic unstyled layouts, or
  when the user asks to polish the UI, make it look professional, or add
  animations. Do NOT use for backend-only APIs or non-visual CLI tools.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - vibe-coding
    - ui-polish
    - micro-interactions
    - toasts
    - skeletons
    - responsive
    - dark-mode
    - frontend
    - ux
---

# Vibe UI Delight & Prototype Polish

> **Quick Install into any project:**
> ```bash
> curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- skills/web/vibe-ui-delight
> ```

## Mission

Elevate AI-generated web prototypes from raw wireframes into production-grade, tactile web experiences that feel responsive, alive, and instantly ready to demo.

AI-assisted "vibe coding" frequently produces functional logic wrapped in brittle, lifeless interfaces:
- Jarring layout jumps caused by missing skeleton loaders.
- Obnoxious browser `alert()` and `confirm()` dialogs.
- Sterile static buttons without hover, active, or disabled states.
- Blank white screens on empty lists without onboarding CTAs.
- Breakdowns on mobile devices (< 640px) with horizontal scroll leaks.

This skill equips agents with drop-in patterns for **tactile feedback, micro-interactions, responsive shells, and state polish**.

---

## The 6 Pillars of Vibe UI Delight

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                VIBE UI DELIGHT ARCHITECTURE                            │
├──────────────────────────────┬──────────────────────────────┬──────────────────────────┤
│ 1. State & Feedback          │ 2. Empty & Error States      │ 3. Tactile Micro-Physics │
│ • Toast notifications        │ • Illustrated empty vectors  │ • Active press (scale-95)│
│ • Skeleton shimmers          │ • Explanatory subcopy        │ • Hover lifts & glows    │
│ • Optimistic UI updates      │ • Contextual CTA buttons     │ • Smooth spring easing   │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────┤
│ 4. Mobile Ergonomics         │ 5. Visual Hierarchy & Depth  │ 6. Sensory Polish        │
│ • Sticky bottom action bars  │ • Glassmorphism backdrops    │ • Subtle Web Audio cues  │
│ • Touch sheet navigation     │ • Subtle mesh/radial gradients│ • Haptic pulse on touch │
│ • Safe area padding (pb-safe)│ • Dark/Light theme harmony   │ • Keyboard focus rings   │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────┘
```

---

## Pillar 1: Feedback & State Transitions

### 1. Zero-Dependency Toast Notification System
Never use native `window.alert()` or `window.prompt()`. Always provide non-blocking toast notifications with auto-dismissal and icon accents.

#### Lightweight Vanilla / React Pattern
```tsx
// types.ts
export type ToastType = 'success' | 'error' | 'info' | 'loading';
export interface Toast {
  id: string;
  type: ToastType;
  message: string;
  duration?: number;
}
```

```tsx
// ToastContainer.tsx
import React from 'react';

const icons = {
  success: '✓',
  error: '✕',
  info: 'ℹ',
  loading: '⟳'
};

const badgeStyles = {
  success: 'bg-emerald-500/10 text-emerald-500 border-emerald-500/20',
  error: 'bg-rose-500/10 text-rose-500 border-rose-500/20',
  info: 'bg-sky-500/10 text-sky-500 border-sky-500/20',
  loading: 'bg-amber-500/10 text-amber-500 border-amber-500/20 animate-spin'
};

export function ToastItem({ toast, onDismiss }: { toast: Toast; onDismiss: (id: string) => void }) {
  return (
    <div
      role="status"
      className="flex items-center gap-3 px-4 py-3 rounded-xl backdrop-blur-md bg-neutral-900/90 text-neutral-100 border border-neutral-800 shadow-xl shadow-black/20 transition-all duration-300 animate-in fade-in slide-in-from-bottom-3"
    >
      <span className={`flex items-center justify-center w-6 h-6 rounded-full border text-xs font-bold ${badgeStyles[toast.type]}`}>
        {icons[toast.type]}
      </span>
      <p className="text-sm font-medium pr-2">{toast.message}</p>
      <button
        onClick={() => onDismiss(toast.id)}
        className="text-neutral-400 hover:text-neutral-200 text-xs ml-auto p-1 rounded-md transition-colors"
        aria-label="Dismiss notification"
      >
        ✕
      </button>
    </div>
  );
}
```

### 2. Skeleton Shimmers Over Spinners
Spinners force users to watch dead time; skeleton loaders create the perception of instant performance and prevent layout shift (CLS).

```html
<!-- CSS Shimmer Token -->
<style>
  @keyframes shimmer {
    100% { transform: translateX(100%); }
  }
  .animate-shimmer {
    position: relative;
    overflow: hidden;
  }
  .animate-shimmer::after {
    position: absolute;
    top: 0; right: 0; bottom: 0; left: 0;
    transform: translateX(-100%);
    background-image: linear-gradient(
      90deg,
      rgba(255, 255, 255, 0) 0,
      rgba(255, 255, 255, 0.06) 20%,
      rgba(255, 255, 255, 0.15) 60%,
      rgba(255, 255, 255, 0)
    );
    animation: shimmer 1.5s infinite;
    content: '';
  }
</style>
```

```tsx
// CardSkeleton.tsx
export function CardSkeleton() {
  return (
    <div className="p-5 rounded-2xl border border-neutral-800/80 bg-neutral-900/40 space-y-4 animate-shimmer">
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-neutral-800/80" />
        <div className="space-y-2 flex-1">
          <div className="h-3.5 w-1/3 rounded bg-neutral-800/80" />
          <div className="h-2.5 w-1/4 rounded bg-neutral-800/50" />
        </div>
      </div>
      <div className="space-y-2 pt-2">
        <div className="h-3 w-full rounded bg-neutral-800/60" />
        <div className="h-3 w-4/5 rounded bg-neutral-800/60" />
      </div>
      <div className="h-9 w-full rounded-xl bg-neutral-800/40 mt-4" />
    </div>
  );
}
```

---

## Pillar 2: Empty & Edge States

Never render a naked empty `<div>` when an array or search query returns zero items. Every empty state must have:
1. An icon / visual motif.
2. A clear title explaining what's missing.
3. Supportive secondary copy.
4. A primary action button (e.g., "Create First Project" or "Clear Filters").

```tsx
export function EmptyState({
  title = "No items found",
  description = "Get started by creating your first item or adjust your search filter.",
  actionLabel = "Create New",
  onAction
}: {
  title?: string;
  description?: string;
  actionLabel?: string;
  onAction?: () => void;
}) {
  return (
    <div className="flex flex-col items-center justify-center text-center p-10 border border-dashed border-neutral-800 rounded-2xl bg-neutral-900/20 max-w-md mx-auto my-8">
      <div className="w-12 h-12 rounded-2xl bg-neutral-800/60 border border-neutral-700/50 flex items-center justify-center text-xl mb-4 text-neutral-400">
        ✦
      </div>
      <h3 className="text-base font-semibold text-neutral-200">{title}</h3>
      <p className="text-xs text-neutral-400 mt-1 mb-5 max-w-xs leading-relaxed">{description}</p>
      {onAction && (
        <button
          onClick={onAction}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-medium bg-neutral-100 text-neutral-900 hover:bg-white active:scale-95 transition-all shadow-md shadow-white/5"
        >
          <span>+</span> {actionLabel}
        </button>
      )}
    </div>
  );
}
```

---

## Pillar 3: Tactile Micro-Physics

Make interactions feel physical and weighted. Every button and interactive card must respond to mouse and touch states.

### Standard Interaction Token Set (Tailwind / CSS)
- **Hover Lift**: `transition-all duration-200 ease-out hover:-translate-y-0.5 hover:shadow-lg hover:shadow-primary-500/10`
- **Active Click/Tap**: `active:scale-[0.98] transition-transform duration-75`
- **Focus Ring (Accessibility)**: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-500/60 focus-visible:ring-offset-2 focus-visible:ring-offset-neutral-950`
- **Disabled State**: `disabled:opacity-50 disabled:pointer-events-none disabled:cursor-not-allowed`

### Interactive Button Example
```tsx
export function TactileButton({
  children,
  onClick,
  isLoading,
  variant = 'primary'
}: {
  children: React.ReactNode;
  onClick?: () => void;
  isLoading?: boolean;
  variant?: 'primary' | 'secondary' | 'ghost';
}) {
  const styles = {
    primary: 'bg-emerald-500 hover:bg-emerald-400 text-neutral-950 font-semibold shadow-lg shadow-emerald-500/20',
    secondary: 'bg-neutral-800 hover:bg-neutral-700 text-neutral-100 border border-neutral-700/70',
    ghost: 'hover:bg-neutral-800/60 text-neutral-300 hover:text-white'
  };

  return (
    <button
      onClick={onClick}
      disabled={isLoading}
      className={`relative inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl text-sm transition-all duration-200 ease-out active:scale-95 focus-visible:ring-2 focus-visible:ring-emerald-400 ${styles[variant]}`}
    >
      {isLoading ? (
        <span className="inline-block w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
      ) : null}
      {children}
    </button>
  );
}
```

---

## Pillar 4: Mobile Ergonomics & Responsive Shell

A prototype breaks the vibe if it requires pinch-to-zoom on a phone or renders a desktop sidebar that overflows the screen.

### Mobile Bottom Action Bar (Thumb Zone)
On mobile displays (`< 768px`), place the primary action buttons within thumb reach at the bottom of the viewport:

```html
<nav class="md:hidden fixed bottom-0 left-0 right-0 z-50 p-3 pb-safe bg-neutral-950/80 backdrop-blur-xl border-t border-neutral-800 flex items-center justify-around">
  <button class="flex flex-col items-center gap-1 text-xs text-neutral-400 hover:text-neutral-100 active:scale-90 transition-transform">
    <span class="text-base">⌂</span>
    <span>Home</span>
  </button>
  <button class="flex flex-col items-center gap-1 text-xs text-neutral-400 hover:text-neutral-100 active:scale-90 transition-transform">
    <span class="text-base">⌕</span>
    <span>Search</span>
  </button>
  <button class="flex items-center justify-center w-10 h-10 rounded-full bg-emerald-500 text-neutral-950 font-bold active:scale-90 shadow-lg shadow-emerald-500/30">
    +
  </button>
  <button class="flex flex-col items-center gap-1 text-xs text-neutral-400 hover:text-neutral-100 active:scale-90 transition-transform">
    <span class="text-base">⚙</span>
    <span>Settings</span>
  </button>
</nav>
```

---

## Pillar 5: Sensory Audio & Haptic Delights (Web API)

Add subtle, non-intrusive sound synthesis and haptics to critical actions (e.g., toggling a switch, completing a task).

```ts
// vibeSounds.ts
class VibeFeedback {
  private ctx: AudioContext | null = null;

  private getAudioContext(): AudioContext | null {
    if (typeof window === 'undefined') return null;
    if (!this.ctx && (window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext)) {
      const AudioCtx = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
      this.ctx = new AudioCtx();
    }
    return this.ctx;
  }

  /** Subtle tactile 'pop' click */
  playPop() {
    try {
      const ctx = this.getAudioContext();
      if (!ctx) return;
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();

      osc.type = 'sine';
      osc.frequency.setValueAtTime(440, ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.05);

      gain.gain.setValueAtTime(0.08, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.05);

      osc.connect(gain);
      gain.connect(ctx.destination);

      osc.start();
      osc.stop(ctx.currentTime + 0.05);
    } catch {
      // Audio autoplay policy fallback
    }
  }

  /** Gentle haptic pulse on mobile devices */
  triggerHaptic(pattern: number | number[] = 10) {
    if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
      navigator.vibrate(pattern);
    }
  }
}

export const feedback = new VibeFeedback();
```

---

## Vibe Polish Pre-Demo Checklist

Before presenting any newly generated UI to the user, ensure:

- [ ] **No `window.alert()`**: All notifications use in-app toasts or status banners.
- [ ] **Zero Layout Shifts**: Loading states use dimension-matched skeletons (`animate-shimmer`).
- [ ] **Empty States**: Every list or grid component handles `data.length === 0` with a styled card + CTA.
- [ ] **Tactile Clicks**: Primary buttons have `active:scale-95` and smooth transition tokens.
- [ ] **Mobile Checked**: Checked on simulated 375px width — no horizontal scrolling, padding includes safe-areas.
- [ ] **Dark Mode Harmony**: Contrast ratios pass WCAG AA standards with harmonious slate/neutral tones.
