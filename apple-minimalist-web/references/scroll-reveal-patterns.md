# Scroll-Reveal Animation Patterns

Reliable patterns for Apple-style scroll-triggered reveal animations in pure HTML/CSS/JS (no framework).

## The Core Problem: Why CSS Transitions Fail

CSS `transition` is unreliable for scroll reveals. When IntersectionObserver fires, it often adds the `.revealed` class in the same render frame as the initial `.reveal` class. The browser never renders the hidden state, so the transition has no starting point and silently does nothing. The element just appears at its final position.

Double `requestAnimationFrame` sometimes helps but does not guarantee a fix. Some browsers (especially on `file://` URLs and with extensions) batch multiple frames together.

## Solution: CSS @keyframes (Always Works)

```css
/* Keyframes always start from frame 0 regardless of timing */
@keyframes revealUp {
  from { opacity: 0; transform: translateY(48px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* Initial hidden state (no transition!) */
.reveal {
  opacity: 0;
  transform: translateY(48px);
}

/* Animation triggers when revealed class is added */
.reveal.revealed {
  animation: revealUp 0.75s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
```

The `forwards` fill mode is critical. Without it, the element snaps back to hidden after the animation completes.

## Staggered Card Grids

```css
@keyframes cardReveal {
  from { opacity: 0; transform: translateY(44px) scale(0.96); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* All children hidden initially */
.reveal-stagger > * {
  opacity: 0;
  transform: translateY(44px) scale(0.96);
}

/* Base animation for all children when parent gets .revealed */
.reveal-stagger.revealed > * {
  animation-name: cardReveal;
  animation-duration: 0.7s;
  animation-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
  animation-fill-mode: forwards;
}

/* Staggered delays: 100ms per child */
.reveal-stagger.revealed > *:nth-child(1)  { animation-delay: 0.00s; }
.reveal-stagger.revealed > *:nth-child(2)  { animation-delay: 0.10s; }
.reveal-stagger.revealed > *:nth-child(3)  { animation-delay: 0.20s; }
.reveal-stagger.revealed > *:nth-child(4)  { animation-delay: 0.30s; }
.reveal-stagger.revealed > *:nth-child(5)  { animation-delay: 0.40s; }
.reveal-stagger.revealed > *:nth-child(6)  { animation-delay: 0.50s; }
.reveal-stagger.revealed > *:nth-child(7)  { animation-delay: 0.60s; }
.reveal-stagger.revealed > *:nth-child(8)  { animation-delay: 0.70s; }
.reveal-stagger.revealed > *:nth-child(9)  { animation-delay: 0.80s; }
.reveal-stagger.revealed > *:nth-child(10) { animation-delay: 0.90s; }
.reveal-stagger.revealed > *:nth-child(11) { animation-delay: 1.00s; }
.reveal-stagger.revealed > *:nth-child(12) { animation-delay: 1.10s; }
```

Important: `.reveal-stagger > *` matches DIRECT children only. If there are wrapper elements inside the grid, this won't work.

## IntersectionObserver Pattern (with Mandatory Fallback)

```js
function initScrollReveal() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('revealed');
        observer.unobserve(entry.target);  // cleanup
      }
    });
  }, {
    threshold: 0.10,           // 10% visible triggers
    rootMargin: '0px 0px -60px 0px'  // 60px into viewport
  });

  // Find visible page (SPA pattern)
  const visiblePage = Array.from(document.querySelectorAll('.page-content'))
    .find(p => p.style.display !== 'none');

  const targets = [];

  // Mark section titles/descs (skip hero sections)
  visiblePage.querySelectorAll('.section-label, .section-title, .section-desc').forEach(el => {
    if (!el.closest('.hero-home, .hero-ai, .hero-about')) {
      el.classList.add('reveal');
      targets.push(el);
    }
  });

  // Mark grid containers for stagger
  visiblePage.querySelectorAll('.product-grid, .card-grid, .pricing-grid').forEach(grid => {
    grid.classList.add('reveal-stagger');
    targets.push(grid);
  });

  // Start observing
  targets.forEach(el => observer.observe(el));

  // CRITICAL FALLBACK
  // IntersectionObserver can be silently blocked by:
  // - Ad blockers / privacy browser extensions
  // - iframe sandbox restrictions
  // - Slow rendering on low-end devices
  // - file:// URL quirks in some browsers
  // Always include a setTimeout fallback that force-reveals everything.
  setTimeout(() => {
    targets.forEach(el => {
      if (!el.classList.contains('revealed')) {
        el.classList.add('revealed');
        observer.unobserve(el);
      }
    });
  }, 600);
}

document.addEventListener('DOMContentLoaded', initScrollReveal);
```

## SPA Page Navigation: Re-init Animations

When switching pages in a client-side SPA (no framework), call `initScrollReveal` after showing the new page:

```js
function navigateTo(page) {
  document.querySelectorAll('.page-content').forEach(p => p.style.display = 'none');
  document.getElementById('page-' + page).style.display = 'block';
  window.scrollTo({ top: 0, behavior: 'instant' });
  setTimeout(initScrollReveal, 50);  // re-init for new page content
}
```

## Hero Animations (Immediate, No Observer)

Hero elements don't need IntersectionObserver. They animate on load:

```css
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(32px); }
  to   { opacity: 1; transform: translateY(0); }
}
.animate-in { animation: fadeInUp 0.7s cubic-bezier(0.16, 1, 0.3, 1) both; }
.delay-1 { animation-delay: 0.12s; }
.delay-2 { animation-delay: 0.24s; }
```

HTML: `<h1 class="animate-in">Title</h1>`

## Animation Parameters Reference

| Parameter | Value |
|---|---|
| Easing curve | `cubic-bezier(0.16, 1, 0.3, 1)` |
| translateY (single reveal) | 48px |
| translateY (stagger) | 44px |
| Scale start (stagger) | 0.96 |
| Duration (single) | 0.75s |
| Duration (stagger per child) | 0.7s |
| Stagger interval | 100ms |
| Observer threshold | 0.10 |
| Observer rootMargin | -60px |
| Fallback timeout | 600ms |
| Hero animation delay | 120ms per level |

## Accessibility

Always include `prefers-reduced-motion` support:

```css
@media (prefers-reduced-motion: reduce) {
  .reveal,
  .reveal-stagger > * {
    opacity: 1;
    transform: none;
    animation: none;
  }
}
```

## Debugging Checklist

When animations don't appear:

1. Check if `.revealed` class is being added (use DevTools Elements panel)
2. Verify the element has `animation` in computed styles (not `transition`)
3. Check Console for JS errors (missing selectors, null refs)
4. Verify `.reveal-stagger > *` matches DIRECT children (no wrapper divs inside grid)
5. Check `prefers-reduced-motion` in OS Accessibility settings
6. Hard-refresh to clear cached old version (Cmd+Shift+R)
7. Try the fallback: wait 1 second, check if `.revealed` appeared
8. For SPA pages: ensure `initScrollReveal()` is called after page becomes visible
