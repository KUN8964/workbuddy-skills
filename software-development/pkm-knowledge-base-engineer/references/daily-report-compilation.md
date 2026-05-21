# 日报/系列内容批量编译模式

> 适用于多篇同类型素材的批量压榨：AI 日报、周报、专题系列等。
> 核心目标：去噪、浓缩、串线，产出高质量 Wiki 笔记 + 综述 hub 页。

## 触发条件

- `00_Inbox/待编译/` 中存在 3+ 篇命名规则一致的文件（如 `AI日报_2026-05-*.md`）
- 用户使用「压榨」「编译」「处理」等关键词

## 工作流

### 第一步：全量读取

一次性读取所有待编译文件，使用 `execute_code` 批量读取，获取结构概览（标题、条目数、主题）。

```python
import glob, os
vault = os.environ.get("OBSIDIAN_VAULT_PATH", "~/Documents/Obsidian Vault")
vault = os.path.expanduser(vault)
inbox = os.path.join(vault, "00_Inbox/待编译")
files = sorted(glob.glob(os.path.join(inbox, "AI日报_*.md")))
for f in files:
    with open(f) as fh:
        # 提取标题和结构
        lines = fh.read().split('\n')
        headings = [l.strip() for l in lines if l.startswith('##')]
        print(f"{os.path.basename(f)}: {len(headings)} headings")
```

### 第二步：逐篇编译

每篇压缩为：
- 标题：`YYYY-MM-DD-AI日报`
- YAML frontmatter（title, date, source, tags）
- 一句话摘要（可选）
- 每条新闻浓缩为：标题 + 核心事实（1-2句） + 关联 wikilink
- 结尾：`上游：[[hub页面名]]`

**压榨原则**：
- 删除情绪化点评（「乡亲们」「值得关注」「利好/利空」标注）
- 删除冗余解释（「值得关注的原因」→ 直接保留原因中最核心的 1-2 条）
- 关键数据必须保留（数字、百分比、金额、日期）
- 每条新闻添加 2-4 个关联 wikilink
- 使用表格展示多条目对比信息

**对比示例**：

| 原始（冗余） | 编译后（压榨） |
|---|---|
| > 乡亲们，今儿个AI圈相当热闹...信息量爆炸 | （删除，无信息量） |
| **值得关注的原因：** ...（5条要点） | 合并为 1-2 条核心事实 |
| **立场：利好** — 垂直行业 Agent 化是... | （删除立场标注，保留事实） |

### 第三步：创建综述 Hub 页

跨日串联主题，生成 `YYYY-MM-AI新闻月报.md`：

- 日刊索引（wikilink 列表 + 一句话描述）
- 3-5 条主线提炼（每条主线带关键事件表格）
- 其他值得追踪（次要主题列表）
- 每个主题段落的关联 wikilink 行

**主线提炼方法**：
- 识别跨日重复出现的关键词（如 Google I/O、编程Agent、推理加速）
- 按时间线排列同一主线的事件
- 用表格对比不同玩家/方案

### 第四步：归档原始文件

编译完成后，原始文件移入 `99_Archive/`：

```bash
mkdir -p "$VAULT/99_Archive/AI日报_2026-05"
mv "$VAULT/00_Inbox/待编译"/AI日报_*.md "$VAULT/99_Archive/AI日报_2026-05/"
```

## 命名规范

- 日报笔记：`YYYY-MM-DD-AI日报.md`
- 综述页：`YYYY-MM-AI新闻月报.md`（按月）
- 归档目录：`99_Archive/AI日报_YYYY-MM/`

## 双向链接约定

- 每篇日报末尾：`上游：[[YYYY-MM-AI新闻月报]]`
- Hub 页日刊索引：`[[YYYY-MM-DD-AI日报]] — 关键事件摘要`
- 跨日概念链接到对应的专题页面（如 [[Gemini]]、[[编程Agent]]）

## 常见系列类型

| 类型 | 命名模式 | 编译频率 |
|------|----------|----------|
| AI 日报 | `AI日报_YYYY-MM-DD.md` | 每周一批次 |
| 周报 | `周报_YYYY-MM-DD.md` | 每月一批次 |
| 专题系列 | `专题名_YYYY-MM-DD.md` | 累积满 3 篇后编译 |
