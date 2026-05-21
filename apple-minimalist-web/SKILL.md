---
name: apple-minimalist-web
description: "Apple-style minimalist web design, typography, color, spacing, frosted-glass nav, and scroll-reveal animations. Reliable pure-CSS animation patterns with IntersectionObserver fallbacks."
category: creative
---

# Apple Minimalist Web Design

Design and build brand/landing pages in the Apple aesthetic: clean whitespace, frosted glass, PingFang SC typography, and scroll-triggered reveal animations.

## 1. Visual System

### Color Palette
- Background: `#ffffff` (cards, main) / `#f5f5f7` (alternating sections)
- Text: `#1d1d1f` (headings) / `#6e6e73` (body) / `#aeaeb2` (muted)
- Accent: `#0071E3` (Apple blue), single accent, no purple/neon
- Borders: `rgba(0,0,0,0.08)` default / `rgba(0,0,0,0.15)` hover
- Never pure black `#000`, use off-black `#1d1d1f`

### Typography
- Stack: `-apple-system, BlinkMacSystemFont, "SF Pro Display", "PingFang SC", "Helvetica Neue", sans-serif`
- Headings: `font-weight: 650-700`, `letter-spacing: -0.025em to -0.04em`
- Body: `font-size: 15-18px`, `color: var(--text-secondary)`, `line-height: 1.6-1.7`
- Section titles: `52px`, hero: `64-80px`
- NO Inter font (banned for premium feel)

### Spacing and Layout
- Sections: `padding: 100px 40px`
- Max content width: `1200px` with `margin: 0 auto`
- Cards: `border-radius: 20px` (standard), `28px` (large)
- Shadows: subtle diffusion, `0 4px 20px rgba(0,0,0,0.06)`
- Grid over flexbox math, use `grid-template-columns`

### Navigation
- Frosted glass: `background: rgba(255,255,255,0.8); backdrop-filter: saturate(180%) blur(20px)`
- Height: `52px`, fixed, border appears on scroll
- Pill buttons: `border-radius: 24px`, background accent

## 2. Icons
- Inline SVG with `stroke="currentColor"` and `fill="none"`
- Standard stroke width: `1.5`
- Icon containers: `48x48px`, `background: var(--accent-light)`, `border-radius: 14px`
- NO emojis in production code

## 3. Button System
- Primary: `background: var(--accent); color: #fff; padding: 14px 32px; border-radius: 28px`
- Outline: `border: 1.5px solid rgba(0,0,0,0.15); background: transparent`
- Active: `transform: scale(0.97)` on press

## 4. Scroll-Reveal Animations

See `references/scroll-reveal-patterns.md` for full implementation code.

### Golden Rule: Use @keyframes, Never transitions
CSS `transition` is unreliable for scroll-triggered reveals. If the class is added in the same frame, the browser never paints the hidden state and the transition silently fails.

```css
/* Always use this pattern */
@keyframes revealUp {
  from { opacity: 0; transform: translateY(48px); }
  to   { opacity: 1; transform: translateY(0); }
}
.reveal { opacity: 0; transform: translateY(48px); }
.reveal.revealed { animation: revealUp 0.75s cubic-bezier(0.16,1,0.3,1) forwards; }
```

### Staggered Grids
```css
.reveal-stagger > * { opacity: 0; transform: translateY(44px) scale(0.96); }
.reveal-stagger.revealed > *:nth-child(1) { animation-delay: 0.00s; }
.reveal-stagger.revealed > *:nth-child(2) { animation-delay: 0.10s; }
/* 100ms intervals up to 12 children */
```

### IntersectionObserver with Fallback (MANDATORY)
```js
const observer = new IntersectionObserver(callback, {
  threshold: 0.10,
  rootMargin: '0px 0px -60px 0px'
});
targets.forEach(el => observer.observe(el));

// Fallback: observer can be blocked by browser extensions.
// Always force-reveal after 600ms.
setTimeout(() => {
  targets.forEach(el => {
    if (!el.classList.contains('revealed')) el.classList.add('revealed');
  });
}, 600);
```

### Hero Animations (immediate on load)
```css
.animate-in { animation: fadeInUp 0.7s cubic-bezier(0.16,1,0.3,1) both; }
.delay-1 { animation-delay: 0.12s; }
.delay-2 { animation-delay: 0.24s; }
```

### Accessibility
Always include `prefers-reduced-motion: reduce` support:
```css
@media (prefers-reduced-motion: reduce) {
  .reveal, .reveal-stagger > * { opacity: 1; transform: none; animation: none; }
}
```

## 5. SPA Page Switching (no framework)
```js
function navigateTo(page) {
  document.querySelectorAll('.page-content').forEach(p => p.style.display = 'none');
  document.getElementById('page-' + page).style.display = 'block';
  window.scrollTo({ top: 0, behavior: 'instant' });
  setTimeout(initScrollReveal, 50);  // re-init animations for new page
}
```

## 6. Anti-Patterns (Forbidden)
- Dark backgrounds for Apple-style (use white/light gray)
- Purple/neon gradients as accent (use single desaturated accent)
- Emojis as icons (use inline SVG)
- `#000000` black (use `#1d1d1f`)
- Oversized centered hero text at high DESIGN_VARIANCE (use split or left-aligned)
- 3-column equal card grids for features (use bento or asymmetric)
- CSS transitions for scroll reveals (use @keyframes)
- No fallback for IntersectionObserver (always add setTimeout)
