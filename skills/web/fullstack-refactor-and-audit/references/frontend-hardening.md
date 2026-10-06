# Frontend Hardening & Code-Splitting Guide

This guide provides actionable patterns for frontend performance optimization via code-splitting, bundle reduction, and UI resilience against security and crash risks.

---

## 1. Route-Based & Component Code-Splitting

A monolithic frontend bundle forces users to download JavaScript for every page and modal up front, resulting in poor Largest Contentful Paint (LCP) and high Interaction to Next Paint (INP).

### Pattern A: React Router with `React.lazy()` and `Suspense`

```tsx
import React, { Suspense, lazy } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import LoadingSpinner from './components/LoadingSpinner';
import ErrorBoundary from './components/ErrorBoundary';

// Lazy-load route pages into separate chunks
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));
const Analytics = lazy(() => import('./pages/Analytics'));

export function AppRoutes() {
  return (
    <BrowserRouter>
      <ErrorBoundary fallback={<div role="alert">Something went wrong loading this view.</div>}>
        <Suspense fallback={<LoadingSpinner />}>
          <Routes>
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/settings" element={<Settings />} />
            <Route path="/analytics" element={<Analytics />} />
          </Routes>
        </Suspense>
      </ErrorBoundary>
    </BrowserRouter>
  );
}
```

### Pattern B: Dynamic Component Loading for Heavy Dependencies

Defer loading massive client libraries (e.g., Chart.js, Monaco Editor, PDF viewers, syntax highlighters) until the user actually opens or interacts with them:

```tsx
import React, { useState, Suspense, lazy } from 'react';

// Defer chart bundle (~300kb+) until explicitly toggled
const HeavyChart = lazy(() => import('./components/HeavyChart'));

export function AnalyticsWidget() {
  const [showChart, setShowChart] = useState(false);

  return (
    <div className="widget-card">
      <h3>Performance Metrics</h3>
      <button onClick={() => setShowChart(true)}>View Interactive Chart</button>

      {showChart && (
        <Suspense fallback={<div>Loading chart visualization...</div>}>
          <HeavyChart />
        </Suspense>
      )}
    </div>
  );
}
```

### Pattern C: Next.js Dynamic Imports (`next/dynamic`)

```tsx
import dynamic from 'next/dynamic';

const RichTextEditor = dynamic(() => import('@/components/RichTextEditor'), {
  ssr: false, // Avoid server-side rendering for browser-only canvas/DOM tools
  loading: () => <p>Loading editor...</p>,
});
```

---

## 2. Frontend Security Hardening

### Defense-in-Depth UI Checklist

1. **XSS Mitigation & Dangerous Sinks**:
   - Audit code for `dangerouslySetInnerHTML`, `innerHTML`, `document.write`, or `eval()`.
   - If HTML rendering is mandatory, always sanitize through `DOMPurify`:
     ```tsx
     import DOMPurify from 'dompurify';

     export function SafeHTML({ content }: { content: string }) {
       const clean = DOMPurify.sanitize(content, { USE_PROFILES: { html: true } });
       return <div dangerouslySetInnerHTML={{ __html: clean }} />;
     }
     ```
2. **Content Security Policy (CSP)**:
   - Configure HTTP response headers or `<meta http-equiv="Content-Security-Policy">`:
     ```
     default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self' https://api.yourapp.com;
     ```
3. **Open Redirects**:
   - Validate redirect parameters (`?redirect=/dashboard`). Disallow external origins:
     ```ts
     function isValidRedirect(url: string): boolean {
       return url.startsWith('/') && !url.startsWith('//');
     }
     ```
4. **Clickjacking Defense**:
   - Verify `X-Frame-Options: DENY` or CSP `frame-ancestors 'none'`.

---

## 3. UI Resilience & Error Boundaries

Prevent whole-app white screens when a single component encounters an unhandled runtime error.

```tsx
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = { hasError: false };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error("Uncaught UI error caught by boundary:", error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="error-fallback-container" role="alert">
          <h2>Something went wrong in this section.</h2>
          <button onClick={() => this.setState({ hasError: false })}>Try again</button>
        </div>
      );
    }
    return this.props.children;
  }
}
```

---

## 4. Memory Leaks & Resource Cleanup

Audit `useEffect` hooks for:
- Event listeners without `removeEventListener`.
- Timers (`setInterval`, `setTimeout`) without `clearInterval` / `clearTimeout`.
- Open WebSocket or EventSource connections without close calls.
- Uncancelled async state updates after component unmounts (`AbortController`).

```tsx
useEffect(() => {
  const controller = new AbortController();

  async function fetchData() {
    try {
      const res = await fetch('/api/v1/data', { signal: controller.signal });
      const data = await res.json();
      setData(data);
    } catch (err: any) {
      if (err.name !== 'AbortError') console.error(err);
    }
  }

  fetchData();
  return () => controller.abort(); // Cleanup on unmount
}, []);
```
