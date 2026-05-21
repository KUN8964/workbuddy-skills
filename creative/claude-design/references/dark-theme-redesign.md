# Dark Theme Redesign Workflow

Session-specific pattern for converting light-themed sites to dark theme, inspired by reference sites like Framer.

## Workflow

1. **Version the current artifact** — `cp index.html index_v1.html` before any changes.
2. **Extract target design system** — if the reference is a live site (not a static mockup), use `browser_console` with `getComputedStyle()` queries rather than pixel sampling. Key values: `body` background, `h1` color/size/weight, button styles, accent color, card backgrounds, nav blur.
3. **Swap CSS variables in `:root`** — map old tokens to new values. Don't scatter hard-coded colors.
4. **Replace full `<style>` block** — for large overhauls, use `html[:style_start] + new_css + html[style_end:]` rather than targeted `str.replace()` patches. Targeted patches on multi-line CSS blocks fail silently with whitespace mismatches.
5. **Verify with `browser_console`** — zero JS errors, computed styles match target, all 12 pages display. Don't attempt `browser_vision` on DeepSeek (it will fail).

## Framer-Style Dark Theme (Session Example)

Extracted from framer.com/domains/ via `getComputedStyle()` queries:

```
background: #000000
text: #ffffff
text-secondary: rgba(255,255,255,0.6)
accent: #0099FF
accent-bg: rgba(0,153,255,0.12)
card-bg: rgba(255,255,255,0.04)
border: rgba(255,255,255,0.08)
h1: 80px / weight 500 / Inter
nav: rgba(0,0,0,0.85) + backdrop-filter blur(20px)
```

## Badge/Logo Adaptation

Certification badges (ISO, compliance) with white backgrounds become invisible on dark backgrounds. Fix:
- `.cert-badge { filter: brightness(0) invert(1); }`
- Alternatively, use dark-mode logo variants if available
- Verify with `browser_console`: check `offsetWidth`/`offsetHeight` (zero = hidden)

## CSS Replacement Fragility (Key Pitfall)

Three times in this session, `html.replace(old_css_block, new_css_block)` failed silently. Root cause: multi-line CSS strings with invisible whitespace differences (trailing spaces, tab/space mixing, BOM). Symptoms:
- File writes with correct byte count
- `search_files` shows CSS class in HTML but not in `<style>`
- Browser shows elements without the expected styling

Reliable fallback: `html.replace('</style>', new_css + '\n</style>')` for incremental additions, or replace entire `<style>` block for full overhauls.
