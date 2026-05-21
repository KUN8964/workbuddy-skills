# WorkBuddy Skills

> `~/.workbuddy/skills/` 和 `~/.hermes/skills/` 的统一版本控制仓库。
> 多设备同步只需 `git pull`。

## 新设备一键初始化

```bash
# 方式一：一键脚本（推荐，叠加模式，不覆盖内置 skills）
bash <(curl -s https://raw.githubusercontent.com/KUN8964/skill-hub/main/setup-skills.sh)

# 方式二：手动克隆
git clone https://github.com/KUN8964/skill-hub.git ~/skill-hub
ln -s ~/skill-hub ~/.workbuddy/skills   # WorkBuddy

# Hermes 推荐用叠加模式（merge），不替换内置 skills：
bash ~/skill-hub/setup-skills.sh --mode merge
```

> **叠加模式（默认）**：git skills 合并到 `~/.hermes/skills/`，内置 skills 保留，同名 skill 不覆盖（保护官方技能）。
> **替换模式**：`bash setup-skills.sh --mode replace`（会丢失内置 skills，不推荐）。

## 自动更新（开机/CLI 启动时检查）

```bash
# 安装开机自动更新服务（macOS launchd）
bash ~/skill-hub/scripts/skills-auto-update.sh --install-launchd

# 手动检查更新
bash ~/skill-hub/scripts/skills-auto-update.sh

# 卸载自动更新
bash ~/skill-hub/scripts/skills-auto-update.sh --uninstall-launchd
```

- 开机时自动运行一次
- 之后每 24 小时检查一次
- 有更新则 `git pull` + 自动合并到 Hermes（不覆盖内置 skills）
- 日志：`~/.workbuddy/skills-update.log`

### IDE/CLI 启动时检查

在 shell profile（`~/.zshrc` 或 `~/.bash_profile`）添加：

```bash
# Skills 自动更新（每次打开终端/IDE 时静默检查）
(bash ~/skill-hub/scripts/skills-auto-update.sh >/dev/null 2>&1 &)
```

这样每次启动终端、VS Code、Cursor 等都会自动检查并同步最新 skills。

## 共享 Skills (`~/.agents/skills/`)

仓库中 12 个 skill 是 symlink → `~/.agents/skills/`：

| skill | symlink |
|-------|---------|
| `agent-skill-creator` | → `../../.agents/skills/agent-skill-creator` |
| `brandkit` `design-taste-frontend` `full-output-enforcement` | 同上 |
| `high-end-visual-design` `image-to-code` `imagegen-*` | 同上 |
| `industrial-brutalist-ui` `minimalist-ui` | 同上 |
| `redesign-existing-projects` `stitch-design-taste` | 同上 |

如果新设备没有 `~/.agents/skills/`，这几个 symlink 会是断的（不影响其他 38 个自包含 skill 正常使用）。

建议也给 `~/.agents/skills/` 做版本控制 — 同样 `git init → gh repo create → push`。

## 日常同步

```bash
cd ~/skill-hub

# 拉取最新（任一台设备修改后）
git pull

# 修改后提交
git add . && git commit -m "描述" && git push
```

## 目录结构

- 独立目录：38 个 skills，完全自包含
- symlink：12 个 skills → `~/.agents/skills/`
- `setup-skills.sh`：新设备一键脚本
- `.gitignore`：排除 .zip、临时文件

<!-- SKILLS_TABLE_START -->

### 💰 金融数据（3 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `a-share-daily-review` | A股每日收盘复盘——交易日15:00执行。 | 📁 独立 |
| `a-share-morning-news` | A股早间隔夜资讯采集——每日09:00执行。 | 📁 独立 |
| `daniumao-perspective-skill` | 大牛猫（招财大牛猫/猫笔刀/股社区）的思维框架与表达方式。基于1245篇公众号文章（~615万字）的深度调研， | 📁 独立 |

### 💻 前端开发（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `frontend-dev` | Full-stack frontend development combining premium UI desi... | 📁 独立 |

### 🎨 设计/前端（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `apple-minimalist-web` | Apple-style minimalist web design, typography, color, spa... | 📁 独立 |

### 🎨 设计/可视化（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `architecture-diagram` | Create professional, dark-themed architecture diagrams as... | 📁 独立 |

### 🎨 设计系统（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `awesome-design-md` | Curated collection of 54 DESIGN.md files extracted from r... | 📁 独立 |

### 🎨 品牌设计（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `品牌设计风格专家` | Curated collection of 54 DESIGN.md files extracted from r... | 📁 独立 |

### 🎨 设计工具（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `hue` | Meta-skill that generates new design language skills. Tri... | 📁 独立 |

### 🎨 PPT 制作（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `html-ppt` | HTML PPT Studio — author professional static HTML present... | 📁 独立 |

### 🎨 创意（20 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `architecture-diagram` | Dark-themed SVG architecture/cloud/infra diagrams as HTML. | 📁 独立 |
| `ascii-art` | ASCII art: pyfiglet, cowsay, boxes, image-to-ascii. | 📁 独立 |
| `ascii-video` | ASCII video: convert video/audio to colored ASCII MP4/GIF. | 📁 独立 |
| `baoyu-article-illustrator` | Article illustrations: type × style × palette consistency. | 📁 独立 |
| `baoyu-comic` | Knowledge comics (知识漫画): educational, biography, tutorial. | 📁 独立 |
| `baoyu-infographic` | Infographics: 21 layouts x 21 styles (信息图, 可视化). | 📁 独立 |
| `claude-design` | Design one-off HTML artifacts (landing, deck, prototype). | 📁 独立 |
| `comfyui` | Generate images, video, and audio with ComfyUI — install,... | 📁 独立 |
| `creative-ideation` | Generate project ideas via creative constraints. | 📁 独立 |
| `design-md` | Author/validate/export Google's DESIGN.md token spec files. | 📁 独立 |
| `excalidraw` | Hand-drawn Excalidraw JSON diagrams (arch, flow, seq). | 📁 独立 |
| `humanizer` | Humanize text: strip AI-isms and add real voice. | 📁 独立 |
| `manim-video` | Manim CE animations: 3Blue1Brown math/algo videos. | 📁 独立 |
| `p5js` | p5.js sketches: gen art, shaders, interactive, 3D. | 📁 独立 |
| `pixel-art` | Pixel art w/ era palettes (NES, Game Boy, PICO-8). | 📁 独立 |
| `popular-web-designs` | 54 real design systems (Stripe, Linear, Vercel) as HTML/CSS. | 📁 独立 |
| `pretext` | Use when building creative browser demos with @chenglou/p... | 📁 独立 |
| `sketch` | Throwaway HTML mockups: 2-3 design variants to compare. | 📁 独立 |
| `songwriting-and-ai-music` | Songwriting craft and Suno AI music prompts. | 📁 独立 |
| `touchdesigner-mcp` | Control a running TouchDesigner instance via twozero MCP ... | 📁 独立 |

### 🤖 AI/ML（13 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `lm-evaluation-harness` | lm-eval-harness: benchmark LLMs (MMLU, GSM8K, etc.). | 📁 独立 |
| `weights-and-biases` | W&B: log ML experiments, sweeps, model registry, dashboards. | 📁 独立 |
| `huggingface-hub` | HuggingFace hf CLI: search/download/upload models, datasets. | 📁 独立 |
| `llama-cpp` | llama.cpp local GGUF inference + HF Hub model discovery. | 📁 独立 |
| `obliteratus` | OBLITERATUS: abliterate LLM refusals (diff-in-means). | 📁 独立 |
| `outlines` | Outlines: structured JSON/regex/Pydantic LLM generation. | 📁 独立 |
| `vllm` | vLLM: high-throughput LLM serving, OpenAI API, quantization. | 📁 独立 |
| `audiocraft` | AudioCraft: MusicGen text-to-music, AudioGen text-to-sound. | 📁 独立 |
| `segment-anything` | SAM: zero-shot image segmentation via points, boxes, masks. | 📁 独立 |
| `dspy` | DSPy: declarative LM programs, auto-optimize prompts, RAG. | 📁 独立 |
| `axolotl` | Axolotl: YAML LLM fine-tuning (LoRA, DPO, GRPO). | 📁 独立 |
| `trl-fine-tuning` | TRL: SFT, DPO, PPO, GRPO, reward modeling for LLM RLHF. | 📁 独立 |
| `unsloth` | Unsloth: 2-5x faster LoRA/QLoRA fine-tuning, less VRAM. | 📁 独立 |

### 🤖 自主代理（5 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `claude-code` | Delegate coding to Claude Code CLI (features, PRs). | 📁 独立 |
| `codex` | Delegate coding to OpenAI Codex CLI (features, PRs). | 📁 独立 |
| `hermes-agent` | Configure, extend, or contribute to Hermes Agent. | 📁 独立 |
| `kanban-codex-lane` | Use when a Hermes Kanban worker wants to run Codex CLI as... | 📁 独立 |
| `opencode` | Delegate coding to OpenCode CLI (features, PR review). | 📁 独立 |

### 🔬 研究（5 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `arxiv` | Search arXiv papers by keyword, author, category, or ID. | 📁 独立 |
| `blogwatcher` | Monitor blogs and RSS/Atom feeds via blogwatcher-cli tool. | 📁 独立 |
| `llm-wiki` | Karpathy's LLM Wiki: build/query interlinked markdown KB. | 📁 独立 |
| `polymarket` | Query Polymarket: markets, prices, orderbooks, history. | 📁 独立 |
| `research-paper-writing` | Write ML papers for NeurIPS/ICML/ICLR: design→submit. | 📁 独立 |

### 📊 数据科学（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `jupyter-live-kernel` | Iterative Python via live Jupyter kernel (hamelnb). | 📁 独立 |

### 🛠 软件开发（15 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `debugging-hermes-tui-commands` | Debug Hermes TUI slash commands: Python, gateway, Ink UI. | 📁 独立 |
| `hermes-agent-skill-authoring` | Author in-repo SKILL.md: frontmatter, validator, structure. | 📁 独立 |
| `huashu-nuwa` | 女娲造人：输入人名/主题/甚至只是模糊需求，自动深度调研→思维框架提炼→生成可运行的人物Skill。 | 📁 独立 |
| `munger-perspective` | 查理·芒格的思维框架与表达方式。基于《穷查理宝典》、伯克希尔/Daily Journal股东会、 | 📁 独立 |
| `node-inspect-debugger` | Debug Node.js via --inspect + Chrome DevTools Protocol CLI. | 📁 独立 |
| `pkm-knowledge-base-engineer` | 资深个人知识管理(PKM)架构师，精通基于LLM+Obsidian搭建工程化个人知识生产系统，严格遵循「源码-编译... | 📁 独立 |
| `plan` | Plan mode: write markdown plan to .hermes/plans/, no exec. | 📁 独立 |
| `python-debugpy` | Debug Python: pdb REPL + debugpy remote (DAP). | 📁 独立 |
| `requesting-code-review` | Pre-commit review: security scan, quality gates, auto-fix. | 📁 独立 |
| `spike` | Throwaway experiments to validate an idea before build. | 📁 独立 |
| `subagent-driven-development` | Execute plans via delegate_task subagents (2-stage review). | 📁 独立 |
| `systematic-debugging` | 4-phase root cause debugging: understand bugs before fixing. | 📁 独立 |
| `test-driven-development` | TDD: enforce RED-GREEN-REFACTOR, tests before code. | 📁 独立 |
| `web-pm` | AI 原生 Web 项目需求架构师。通过友好、循序渐进的多轮对话，帮助用户将模糊的 Web 项目想法梳理成极度清晰... | 📁 独立 |
| `writing-plans` | Write implementation plans: bite-sized tasks, paths, code. | 📁 独立 |

### 🔗 MCP 协议（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `native-mcp` | MCP client: connect servers, register tools (stdio/HTTP). | 📁 独立 |

### 🔧 DevOps（3 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `kanban-orchestrator` | Decomposition playbook + anti-temptation rules for an orc... | 📁 独立 |
| `kanban-worker` | Pitfalls, examples, and edge cases for Hermes Kanban work... | 📁 独立 |
| `webhook-subscriptions` | Webhook subscriptions: event-driven agent runs. | 📁 独立 |

### 🐙 GitHub（6 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `codebase-inspection` | Inspect codebases w/ pygount: LOC, languages, ratios. | 📁 独立 |
| `github-auth` | GitHub auth setup: HTTPS tokens, SSH keys, gh CLI login. | 📁 独立 |
| `github-code-review` | Review PRs: diffs, inline comments via gh or REST. | 📁 独立 |
| `github-issues` | Create, triage, label, assign GitHub issues via gh or REST. | 📁 独立 |
| `github-pr-workflow` | GitHub PR lifecycle: branch, commit, open, CI, merge. | 📁 独立 |
| `github-repo-management` | Clone/create/fork repos; manage remotes, releases. | 📁 独立 |

### 🍎 Apple（5 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `apple-notes` | Manage Apple Notes via memo CLI: create, search, edit. | 📁 独立 |
| `apple-reminders` | Apple Reminders via remindctl: add, list, complete. | 📁 独立 |
| `findmy` | Track Apple devices/AirTags via FindMy.app on macOS. | 📁 独立 |
| `imessage` | Send and receive iMessages/SMS via the imsg CLI on macOS. | 📁 独立 |
| `macos-computer-use` | Drive the macOS desktop in the background — screenshots, ... | 📁 独立 |

### 📧 邮件（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `himalaya` | Himalaya CLI: IMAP/SMTP email from terminal. | 📁 独立 |

### 📱 社交（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `xurl` | X/Twitter via xurl CLI: post, search, DM, media, v2 API. | 📁 独立 |

### 📱 小红书（2 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `小红书` | 小红书（RedNote）内容工具。使用场景：搜索小红书笔记并获取详情、获取首页推荐列表、获取帖子详情（正文、图片、... | 📁 独立 |
| `小红书助手` | 小红书（RED/XHS）自动化助手。提供完整的小红书操作能力：登录、发布图文/视频、搜索笔记、浏览详情、点赞收藏评... | 📁 独立 |

### 💬 元宝（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `yuanbao` | Yuanbao (元宝) groups: @mention users, query info/members. | 📁 独立 |

### 🎬 媒体（5 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `gif-search` | Search/download GIFs from Tenor via curl + jq. | 📁 独立 |
| `heartmula` | HeartMuLa: Suno-like song generation from lyrics + tags. | 📁 独立 |
| `songsee` | Audio spectrograms/features (mel, chroma, MFCC) via CLI. | 📁 独立 |
| `spotify` | Spotify: play, search, queue, manage playlists and devices. | 📁 独立 |
| `youtube-content` | YouTube transcripts to summaries, threads, blogs. | 📁 独立 |

### 🎮 游戏（2 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `minecraft-modpack-server` | Host modded Minecraft servers (CurseForge, Modrinth). | 📁 独立 |
| `pokemon-player` | Play Pokemon via headless emulator + RAM reads. | 📁 独立 |

### 🔧 工具/通讯（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `QQ邮箱` | QQ邮箱 IMAP receive and SMTP send via Node.js scripts; cred... | 📁 独立 |

### 🔧 质量测试（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `dogfood` | Exploratory QA of web apps: find bugs, evidence, reports. | 📁 独立 |

### 🔧 效能工具（10 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `airtable` | Airtable REST API via curl. Records CRUD, filters, upserts. | 📁 独立 |
| `google-workspace` | Gmail, Calendar, Drive, Docs, Sheets via gws CLI or Python. | 📁 独立 |
| `html-screenshot-to-pptx` | Convert a screenshot/PNG image to a PowerPoint presentati... | 📁 独立 |
| `linear` | Linear: manage issues, projects, teams via GraphQL + curl. | 📁 独立 |
| `maps` | Geocode, POIs, routes, timezones via OpenStreetMap/OSRM. | 📁 独立 |
| `nano-pdf` | Edit PDF text/typos/titles via nano-pdf CLI (NL prompts). | 📁 独立 |
| `notion` | Notion API + ntn CLI: pages, databases, markdown, Workers. | 📁 独立 |
| `ocr-and-documents` | Extract text from PDFs/scans (pymupdf, marker-pdf). | 📁 独立 |
| `powerpoint` | Create, read, edit .pptx decks, slides, notes, templates. | 📁 独立 |
| `teams-meeting-pipeline` | Operate the Teams meeting summary pipeline via Hermes CLI... | 📁 独立 |

### 📝 笔记（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `obsidian` | Read, search, create, and edit notes in the Obsidian vault. | 📁 独立 |

### 🏠 智能家居（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `openhue` | Control Philips Hue lights, scenes, rooms via OpenHue CLI. | 📁 独立 |

### 🔴 红队安全（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `godmode` | Jailbreak LLMs: Parseltongue, GODMODE, ULTRAPLINIAN. | 📁 独立 |

### 📦 其他（1 个）

| Skill | 功能描述 | 类型 |
|-------|----------|------|
| `vibe-coding-father` | 工程化代码审查官。从架构、独立性、可维护性、安全四个维度审查项目代码，可选提取核心需求生成需求文档，并分析代码修改... | 📁 独立 |

> **总计：112 个 skills** · 更新时间：2026-05-21 17:41

<!-- SKILLS_TABLE_END -->
