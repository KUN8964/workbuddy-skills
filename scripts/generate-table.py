#!/usr/bin/env python3
"""
skills 分类表格生成器
扫描所有 SKILL.md → 按分类输出 Markdown 表格 → 写入 README.md
"""
import os
import re
import sys
from pathlib import Path
from datetime import datetime

SKILLS_DIR = Path(os.environ.get("SKILLS_DIR", Path(__file__).resolve().parent.parent))
README = SKILLS_DIR / "README.md"
MARKER_START = "<!-- SKILLS_TABLE_START -->"
MARKER_END = "<!-- SKILLS_TABLE_END -->"

# ---------- 顶层 skill → 分类映射 ----------
TOP_LEVEL_CATEGORY = {
    "a-share-daily-review": "💰 金融数据",
    "a-share-morning-news": "💰 金融数据",
    "daniumao-perspective-skill": "💰 金融数据",
    "QQ邮箱": "🔧 工具/通讯",
    "dogfood": "🔧 质量测试",
    "hue": "🎨 设计工具",
    "domain": "🔧 基础设施",
    "email": "📧 邮件",
    "feeds": "📡 信息源",
    "gifs": "🎬 媒体",
    "gaming": "🎮 游戏",
    "inference-sh": "🤖 AI 推理",
    "mcp": "🔗 MCP 协议",
    "media": "🎬 媒体",
    "note-taking": "📝 笔记",
    "smart-home": "🏠 智能家居",
    "social-media": "📱 社交",
    "yuanbao": "💬 元宝",
    "architecture-diagram": "🎨 设计/可视化",
    "apple-minimalist-web": "🎨 设计/前端",
    "awesome-design-md": "🎨 设计系统",
    "frontend-dev": "💻 前端开发",
    "html-ppt": "🎨 PPT 制作",
    "品牌设计风格专家": "🎨 品牌设计",
    "小红书": "📱 小红书",
    "小红书助手": "📱 小红书",
}

# 嵌套目录 → 分类映射
NESTED_CATEGORY = {
    "creative": "🎨 创意",
    "mlops": "🤖 AI/ML",
    "autonomous-ai-agents": "🤖 自主代理",
    "research": "🔬 研究",
    "data-science": "📊 数据科学",
    "software-development": "🛠 软件开发",
    "devops": "🔧 DevOps",
    "github": "🐙 GitHub",
    "productivity": "🔧 效能工具",
    "gaming": "🎮 游戏",
    "media": "🎬 媒体",
    "apple": "🍎 Apple",
    "email": "📧 邮件",
    "note-taking": "📝 笔记",
    "smart-home": "🏠 智能家居",
    "social-media": "📱 社交",
    "red-teaming": "🔴 红队安全",
    "mcp": "🔗 MCP 协议",
}

CATEGORY_ORDER = [
    "💰 金融数据", "💻 前端开发", "🎨 设计/前端", "🎨 设计/可视化",
    "🎨 设计系统", "🎨 品牌设计", "🎨 设计工具", "🎨 PPT 制作",
    "🎨 创意", "🤖 AI/ML", "🤖 AI 推理", "🤖 自主代理",
    "🔬 研究", "📊 数据科学", "🛠 软件开发", "🔗 MCP 协议",
    "🔧 DevOps", "🐙 GitHub", "🍎 Apple", "📧 邮件",
    "📱 社交", "📱 小红书", "💬 元宝", "📡 信息源",
    "🎬 媒体", "🎮 游戏", "🔧 工具/通讯", "🔧 基础设施",
    "🔧 质量测试", "🔧 效能工具", "📝 笔记", "🏠 智能家居",
    "🔴 红队安全",
]


def parse_frontmatter(filepath: Path) -> dict:
    """提取 SKILL.md 的 YAML frontmatter"""
    text = filepath.read_text(encoding="utf-8", errors="ignore")
    m = re.match(r"^---\s*\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return {}
    fm = {}
    for line in m.group(1).split("\n"):
        kv = re.match(r"^(\w+):\s*(.*)", line)
        if kv:
            fm[kv.group(1)] = kv.group(2).strip().strip('"').strip("'")
    return fm


def get_category(skill_path: Path, skill_dir: Path) -> str:
    """判断 skill 分类"""
    rel = skill_dir.relative_to(SKILLS_DIR)
    parts = rel.parts

    # 嵌套在分类目录中（如 creative/xxx）
    if len(parts) >= 2 and parts[0] in NESTED_CATEGORY:
        return NESTED_CATEGORY[parts[0]]

    # 顶层 skill
    return TOP_LEVEL_CATEGORY.get(parts[0], "📦 其他")


def get_type_label(skill_dir: Path) -> str:
    """判断类型"""
    if skill_dir.is_symlink():
        return "🔗 symlink"
    return "📁 独立"


def get_skill_name(skill_dir: Path) -> str:
    """获取 skill 显示名称"""
    return skill_dir.name


def get_description(filepath: Path) -> str:
    """提取描述（第一句，最多60字）"""
    fm = parse_frontmatter(filepath)
    desc = fm.get("description", "")

    # 多行 description（以 | 开头）
    if desc == "|":
        text = filepath.read_text(encoding="utf-8", errors="ignore")
        m2 = re.search(r"^description:\s*\|\s*\n\s+(.+)", text, re.MULTILINE)
        if m2:
            desc = m2.group(1).strip()

    if not desc:
        return "无描述"

    # 截断
    desc = desc.split("\n")[0].strip()
    if len(desc) > 60:
        desc = desc[:57] + "..."
    return desc


def main():
    print("=== 扫描 skills 并生成表格 ===")

    # 收集数据
    categories = {}
    all_skills = []

    for md in sorted(SKILLS_DIR.rglob("SKILL.md")):
        if ".git" in md.parts or "node_modules" in md.parts:
            continue
        if ".agents" in md.parts:
            continue

        skill_dir = md.parent
        name = get_skill_name(skill_dir)
        desc = get_description(md)
        cat = get_category(md, skill_dir)
        type_label = get_type_label(skill_dir)

        categories.setdefault(cat, []).append((name, desc, type_label))
        all_skills.append(name)
        print(f"  ✓ {cat} → {name}")

    # 构建表格
    table = ""
    for cat in CATEGORY_ORDER:
        items = categories.pop(cat, [])
        if not items:
            continue
        table += f"### {cat}（{len(items)} 个）\n\n"
        table += "| Skill | 功能描述 | 类型 |\n"
        table += "|-------|----------|------|\n"
        for name, desc, t in items:
            table += f"| `{name}` | {desc} | {t} |\n"
        table += "\n"

    # 剩余未分类
    for cat, items in sorted(categories.items()):
        table += f"### {cat}（{len(items)} 个）\n\n"
        table += "| Skill | 功能描述 | 类型 |\n"
        table += "|-------|----------|------|\n"
        for name, desc, t in items:
            table += f"| `{name}` | {desc} | {t} |\n"
        table += "\n"

    total = len(all_skills)
    table += f"> **总计：{total} 个 skills** · 更新时间：{datetime.now().strftime('%Y-%m-%d %H:%M')}\n"

    # 写入 README
    readme_text = README.read_text(encoding="utf-8", errors="ignore")

    if MARKER_START in readme_text:
        # 替换已有表格
        new_block = f"{MARKER_START}\n\n{table}\n{MARKER_END}"
        readme_text = re.sub(
            re.escape(MARKER_START) + r".*?" + re.escape(MARKER_END),
            new_block,
            readme_text,
            flags=re.DOTALL,
        )
    else:
        readme_text += f"\n{MARKER_START}\n\n{table}\n{MARKER_END}\n"

    README.write_text(readme_text, encoding="utf-8")
    print(f"\n✅ 表格已更新 → {README}")
    print(f"   {total} 个 skills 已分类")


if __name__ == "__main__":
    main()
