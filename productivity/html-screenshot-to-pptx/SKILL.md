---
name: html-screenshot-to-pptx
description: "Convert a screenshot/PNG image to a PowerPoint presentation. Extract page content via OCR (macOS Vision framework Swift), then generate a styled PPTX using pptxgenjs. Use when the user has a screenshot of a page/UI and wants it turned into a presentation."
---

# Screenshot → PPTX Converter

## When to Use

- User has a screenshot (PNG/JPG) of a webpage, UI, or design and wants a PPT from it
- User says "截图 → 自动生成 PPT"
- vision_analyze tool fails (model doesn't support image_url)

## Prerequisites

```bash
# pptxgenjs (global install)
npm install -g pptxgenjs

# For OCR (macOS only — uses Vision framework)
# No install needed, just Swift compiler
```

## Step 1: Find the Screenshot

```bash
# Search common locations
search_files(target='files', path='~/Desktop', pattern='*.png')
search_files(target='files', path='~/Downloads', pattern='*.png')
search_files(target='files', path='~/Desktop', pattern='*1920*')
```

## Step 2: OCR via macOS Vision Framework (Swift)

When vision_analyze fails (DeepSeek models don't support image_url), use macOS native OCR:

### Create the OCR script

Write `/tmp/ocr.swift`:

```swift
import Vision
import AppKit

guard CommandLine.arguments.count > 1 else {
    print("Usage: ocr <image_path>")
    exit(1)
}

let path = CommandLine.arguments[1]
guard let image = NSImage(contentsOfFile: path) else {
    print("Cannot load image at: \(path)")
    exit(1)
}

let request = VNRecognizeTextRequest()
request.recognitionLevel = .accurate
request.usesLanguageCorrection = false
request.recognitionLanguages = ["zh-Hans", "en-US"]  // For Chinese content

guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    print("Cannot get CGImage")
    exit(1)
}

let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
try! handler.perform([request])

guard let results = request.results else {
    print("No results")
    exit(0)
}

for observation in results {
    if let text = observation.topCandidates(1).first?.string {
        print(text)
    }
}
```

### Handle large images (>2000px)

For very long/tall images (e.g. 2880x6294), crop into chunks:

```python
# Use PIL (pip install Pillow --trusted-host pypi.org --trusted-host files.pythonhosted.org)
from PIL import Image
img = Image.open('/path/to/image.png')
w, h = img.size
chunk_h = h // 4
for i in range(4):
    top = i * chunk_h
    bottom = (i+1) * chunk_h if i < 3 else h
    chunk = img.crop((0, top, w, bottom))
    chunk = chunk.convert('RGB')
    out = f'/path/to/chunk_{i}.jpg'
    ratio = 2000 / w
    chunk = chunk.resize((2000, int(chunk.size[1] * ratio)), Image.LANCZOS)
    chunk.save(out, 'JPEG', quality=85)
```

Then OCR each chunk:

```bash
swift /tmp/ocr.swift "/path/to/chunk_0.jpg"
swift /tmp/ocr.swift "/path/to/chunk_1.jpg"
...
```

## Step 3: Generate PPTX with pptxgenjs

Create a Node.js script using pptxgenjs. Key patterns:

```javascript
const pptxgen = require('pptxgenjs');
let pres = new pptxgen();
pres.layout = 'LAYOUT_16x9';  // 10" x 5.625"

// Use NODE_PATH for global modules
// NODE_PATH=$(npm root -g) node script.js
```

### Color Palette Pattern

```javascript
const C = {
  darkBg: '0F172A',      // slate-900 for dark slides
  primary: '2563EB',     // blue-600
  accent: '06B6D4',      // cyan-500
  white: 'FFFFFF',
  offWhite: 'F8FAFC',
  lightGray: 'E2E8F0',
  midGray: '64748B',
  darkText: '1E293B',
};
```

### Design Elements to Include

- **Card shadow**: use factory function to avoid object mutation bug
  ```javascript
  const cardShadow = () => ({ type: 'outer', color: '000000', blur: 8, offset: 2, angle: 135, opacity: 0.10 });
  ```
- **Step labels**: colored rectangle + text overlay for numbered steps
- **Form simulation**: rectangles with text placeholders to mimic login forms
- **Feature cards**: 3-column cards with top accent bar, icon, title, description
- **Flow lines**: dashed lines connecting numbered circles for process flows

### Content Structure

1. **Title slide** — brand name, main title, subtitle, URL
2. **Overview** — feature cards (3 columns)
3. **Process overview** — numbered flow with connecting line (4 steps)
4-6. **Step details** — one slide per step or grouped
7. **Summary** — recap with CTA button
8. **Thank you** — closing slide

## Step 4: Verify Content

```python
import zipfile, xml.etree.ElementTree as ET
z = zipfile.ZipFile('/path/to/output.pptx')
slides = sorted([f for f in z.namelist() if f.startswith('ppt/slides/slide') and f.endswith('.xml')])
for slide_file in slides:
    root = ET.fromstring(z.read(slide_file))
    ns = {'a': 'http://schemas.openxmlformats.org/drawingml/2006/main'}
    texts = [t.text for t in root.findall('.//a:t', ns) if t.text]
    print('\n'.join(texts[:8]))
```

## Common Pitfalls

- **DeepSeek model doesn't support vision** — `vision_analyze` always fails with `unknown variant image_url`. Use Swift OCR instead.
- **PIL not in execute_code sandbox** — Install Pillow in terminal with `--trusted-host` flags due to SSL issues
- **pptxgenjs as global module** — Must use `NODE_PATH=$(npm root -g)` prefix when running the script
- **pptxgenjs object mutation bug** — Never reuse option objects across calls; use factory functions
- **Large images fail OCR** — Crop into chunks, resize to max 2000px wide before OCR
- **Swift OCR needs `recognitionLanguages`** for Chinese text — set `["zh-Hans", "en-US"]`
