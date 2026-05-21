# 2.5D 等距无透视儿童沙盒 — 前端实现模式

> 来源：proj_20260515_001 MVP 实现，2026-05-15
> 参考文件：`/Users/kkk/hermes-projects/proj_20260515_001/mvp/index.html`

---

## 1. CSS 等距无透视投影

**核心思路**：地面容器 `rotateZ(45deg)` + 元素反向旋转，无需 CSS 3D perspective。

```css
/* 地面容器 — 等距投影 */
.iso-ground {
  transform: rotateZ(45deg);
  transform-origin: center center;
}

/* 地面上的元素 — 取消旋转，保持正向面向观众 */
.entity {
  transform: rotateZ(-45deg);  /* 反向抵消 */
}
```

**瓦片坐标计算**：
```
screenX = (gx - gy) * (TILE_W / 2)
screenY = (gx + gy) * (TILE_H / 2)
```

**关键约束**：
- 不使用 `perspective` 属性 → 真正无透视，平行线保持平行
- 元素阴影用椭圆（`scaleX(0.7)` + `border-radius: 50%`）模拟等距投影
- 拖拽时元素需要保持在反向旋转状态：`transform: rotateZ(-45deg)` 始终保留
- 装饰元素（树、房子）同样反向旋转

---

## 2. Pointer Events 统一 Tap/Drag 模式

**问题**：`click` 事件与 `pointer` capture 冲突——`setPointerCapture` 会吃掉 click。

**解法**：用 `pointerdown → pointermove → pointerup` 统一处理，`moved` 标志区分 tap 和 drag。

```javascript
let dragData = { moved: false };

element.addEventListener('pointerdown', (e) => {
  e.preventDefault();
  element.setPointerCapture(e.pointerId);
  dragData.moved = false;
});

element.addEventListener('pointermove', (e) => {
  const dx = e.clientX - startX;
  const dy = e.clientY - startY;
  if (Math.abs(dx) < 5 && Math.abs(dy) < 5) return; // 阈值防抖
  dragData.moved = true;
  // 执行拖拽移动...
});

element.addEventListener('pointerup', (e) => {
  element.releasePointerCapture(e.pointerId);
  if (!dragData.moved) {
    // 没有移动 = 点击
    handleClick();
  }
});
```

**iPad 适配要点**：
- `touch-action: manipulation` 防双击缩放
- `-webkit-user-select: none` 防长按选中
- `document.addEventListener('touchmove', preventDefault, {passive: false})` 防橡皮筋
- `-webkit-tap-highlight-color: transparent` 去高亮

---

## 3. Web Audio API 零依赖音效合成

无需外部 MP3 文件，用 Web Audio API 合成简单音效：

```javascript
function playBeep(freq = 600, duration = 0.12, type = 'sine') {
  const ctx = new AudioContext();
  const osc = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.type = type;           // 'sine', 'triangle', 'square'
  osc.frequency.value = freq;
  gain.gain.setValueAtTime(0.15, ctx.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + duration);
  osc.connect(gain);
  gain.connect(ctx.destination);
  osc.start();
  osc.stop(ctx.currentTime + duration);
}

// 点击音效：双音连奏
function playClickSound() {
  playBeep(800, 0.08, 'sine');
  setTimeout(() => playBeep(1000, 0.08, 'sine'), 80);
}

// 成功音效：上行三连音
function playSuccessSound() {
  playBeep(523, 0.12);
  setTimeout(() => playBeep(659, 0.12), 120);
  setTimeout(() => playBeep(784, 0.20), 240);
}

// 错误音效：低音三角波
function playWrongSound() {
  playBeep(200, 0.20, 'triangle');
}
```

**注意**：`AudioContext` 需要用户交互后才能创建（浏览器自动播放策略）。在首次 `pointerdown` 时调用 `initAudio()`。

---

## 4. localStorage 进度存储模式

```javascript
function saveProgress() {
  const data = { countingScore, habitCompleted, lastPlayed: new Date().toISOString() };
  try {
    localStorage.setItem('car_world_progress', JSON.stringify(data));
  } catch (e) { /* 静默失败 */ }
}

function loadProgress() {
  try {
    const raw = localStorage.getItem('car_world_progress');
    if (raw) {
      const data = JSON.parse(raw);
      countingScore = data.countingScore || 0;
    }
  } catch (e) { /* 忽略损坏数据 */ }
}
```

**要点**：
- 始终 try/catch（隐私模式可能禁用 localStorage）
- 损坏数据静默降级，不阻塞启动
- 只存摘要数据（分数/完成次数），不存完整状态

---

## 5. 浏览器自动化测试注意事项

`browser_click` 走无障碍树点击，不触发 pointer 事件。测试触摸交互时用 `browser_console` 手动 dispatch：

```javascript
el.dispatchEvent(new PointerEvent('pointerdown', {bubbles: true, pointerId: 1, clientX: x, clientY: y}));
el.dispatchEvent(new PointerEvent('pointerup', {bubbles: true, pointerId: 1, clientX: x, clientY: y}));
```

实际 iPad/触摸设备上 pointer 事件正常工作，无需额外处理。
