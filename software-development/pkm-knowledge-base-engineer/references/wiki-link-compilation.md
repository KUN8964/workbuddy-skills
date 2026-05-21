# Wiki链接编译：保护-添加-恢复策略与级联污染修复脚本

> 来自 2026-05-08 AI日报批量编译实战。13个文件通过2556篇Wiki词条的术语索引进行交叉链接。

## 1. 完整的一次性编译脚本（保护-添加-恢复策略）

```python
import os, re

WORK_DIR = "/path/to/obsidian/vault"
INBOX_DIR = os.path.join(WORK_DIR, "00_Inbox", "待编译")
WIKI_DIR = os.path.join(WORK_DIR, "01_Wiki_by_LLM")

# ── 构建Wiki术语索引 ──
wiki_files = [f for f in os.listdir(WIKI_DIR) if f.endswith('.md')]
title_to_fullname = {}
for f in wiki_files:
    name = f[:-3]
    match = re.match(r'\d{4}-\d{2}-\d{2}-(.+)', name)
    if match:
        title_to_fullname[match.group(1)] = name

# ── 定义要链接的术语（只链接Wiki中实际存在的） ──
TARGET_TERMS = ["GPT", "MoE", "RAG", "Agent", "Transformer", ...]
existing = {t: title_to_fullname[t] for t in TARGET_TERMS if t in title_to_fullname}

# 短缩写词（需要严格词边界）
SHORT = {"GPT", "RAG", "MoE", "SFT", "DPO", "TTS", "LoRA", "RLHF", "GRPO", "Agent"}

# ── 处理每个文件 ──
source_files = [f for f in os.listdir(INBOX_DIR) if f.endswith('.md')]

for fname in source_files:
    fpath = os.path.join(INBOX_DIR, fname)
    with open(fpath, 'r') as f:
        content = f.read()

    date_str = re.search(r'(\d{4}-\d{2}-\d{2})', fname).group(1)

    # 添加YAML frontmatter
    yaml = f'---\ntitle: {fname[:-3]}\ndate: {date_str}\nsource: {fname}\ntags: []\n---\n\n'
    content = yaml + content

    # 分离YAML和正文
    yaml_end = content.find('---', 3)
    yaml_block = content[:yaml_end+3]
    body = content[yaml_end+3:]

    # ========== 保护已有链接和代码块 ==========
    protected = {}
    counter = [0]

    def make_protect():
        def protect(m):
            counter[0] += 1
            key = f'\x00P{counter[0]}\x00'
            protected[key] = m.group(0)
            return key
        return protect

    body = re.sub(r'```[\s\S]*?```', make_protect(), body)
    body = re.sub(r'`[^`]+`', make_protect(), body)
    body = re.sub(r'\[\[[^\]]+\]\]', make_protect(), body)
    body = re.sub(r'\[([^\]]+)\]\([^)]+\)', make_protect(), body)

    # ========== 添加新链接 ==========
    sorted_terms = sorted(existing.items(), key=lambda x: len(x[0]), reverse=True)
    for term, fullname in sorted_terms:
        escaped = re.escape(term)
        if term in SHORT:
            pattern = rf'(?<![a-zA-Z0-9]){escaped}(?![a-zA-Z0-9])'
        else:
            pattern = rf'(?<!\[){escaped}(?!\])'
        body = re.sub(pattern, f'[[{fullname}]]', body)

    # ========== 恢复保护内容 ==========
    for key in sorted(protected.keys(), key=len, reverse=True):
        body = body.replace(key, protected[key])

    # ========== 写入Wiki目录 ==========
    new_filename = f"{date_str}-{fname}"
    new_path = os.path.join(WIKI_DIR, new_filename)
    with open(new_path, 'w') as f:
        f.write(yaml_block + body)

    # ========== 删除待编译源文件 ==========
    os.remove(fpath)

    links_count = len(re.findall(r'\[\[([^\]]+)\]\]', yaml_block + body))
    print(f"  ✅ {fname} → {new_filename} ({links_count} links)")
```

## 2. 级联污染修复脚本（事后清理）

当保护-添加策略未正确执行，导致文件中出现日期前缀污染或嵌套链接时使用：

```python
import os, re

WIKI_DIR = "/path/to/01_Wiki_by_LLM"
target_files = [f for f in os.listdir(WIKI_DIR) if f.endswith('.md')]

for fname in target_files:
    fpath = os.path.join(WIKI_DIR, fname)
    with open(fpath, 'r') as f:
        content = f.read()

    original = content

    # 修复1: 双重日期前缀
    content = re.sub(
        r'\d{4}-\d{2}-\d{2}-\d{4}-\d{2}-\d{2}-(\[\[[^\]]+\]\])',
        r'\1', content
    )

    # 修复2: 单重日期前缀
    content = re.sub(
        r'\d{4}-\d{2}-\d{2}-(\[\[[^\]]+\]\])',
        r'\1', content
    )

    # 修复3: 合成词中间的链接（[[GPT]]-Realtime → GPT-Realtime）
    def fix_midword(m):
        inner = re.search(r'\[\[(\d{4}-\d{2}-\d{2}-(.+?))\]\]', m.group(1))
        if inner:
            return inner.group(2) + m.group(2)
        return m.group(1) + m.group(2)

    content = re.sub(
        r'(\[\[\d{4}-\d{2}-\d{2}-[^\]]+\]\])(-[a-zA-Z0-9].*)',
        fix_midword, content
    )

    # 修复4: 嵌套链接（迭代清理，最多3层）
    for _ in range(3):
        if not re.search(r'\[\[[^\]]*\[\[', content):
            break
        content = re.sub(
            r'\[\[([^\[\]]*\[\[[^\]]*\]\][^\[\]]*)\]\]',
            lambda m: re.sub(r'\[\[([^\]]+)\]\]', r'\1', m.group(0)),
            content
        )

    if content != original:
        with open(fpath, 'w') as f:
            f.write(content)

    # 验证
    nested = re.findall(r'\[\[[^\]]*\[\[', content)
    date_pfx = re.findall(r'\d{4}-\d{2}-\d{2}-\[\[', content)
    status = '✅' if not nested and not date_pfx else f'❌ N:{len(nested)} D:{len(date_pfx)}'
    print(f"  {status} {fname}")
```

## 3. 验证脚本（检查所有Wiki文件的链接健康度）

```python
import os, re

WIKI_DIR = "/path/to/01_Wiki_by_LLM"
files = [f for f in os.listdir(WIKI_DIR) if f.endswith('.md')]

total_links = 0
issues = 0

for fname in sorted(files):
    fpath = os.path.join(WIKI_DIR, fname)
    with open(fpath) as f:
        content = f.read()

    links = re.findall(r'\[\[([^\]]+)\]\]', content)
    nested = re.findall(r'\[\[[^\]]*\[\[', content)
    date_pfx = re.findall(r'\d{4}-\d{2}-\d{2}-\[\[', content)
    invalid = [l for l in links if not re.match(r'\d{4}-\d{2}-\d{2}-', l)]

    file_issues = []
    if nested: file_issues.append(f'NESTED:{len(nested)}')
    if date_pfx: file_issues.append(f'DATE-PFX:{len(date_pfx)}')
    if invalid: file_issues.append(f'INVALID:{invalid}')

    status = '✅' if not file_issues else '❌ ' + ' '.join(file_issues)
    print(f"  {status} {fname}: {len(links)} links")
    total_links += len(links)
    if file_issues:
        issues += 1

print(f"\n  Total: {len(files)} files, {total_links} links, {issues} with issues")
```

## 关键教训总结

1. **绝不剥离再重新链接** — 使用保护-添加-恢复三步法
2. **短缩写词必须用严格词边界** — `(?<![a-zA-Z0-9])GPT(?![a-zA-Z0-9])` 而非 `(?<!\[)GPT(?!\])`
3. **术语按长度降序处理** — 长术语优先，防止短术语先匹配吃掉长术语的一部分
4. **保护内容用唯一占位符** — 使用不可打印字符（`\x00`）作为占位符标记，避免与正文冲突
5. **恢复时按key长度降序** — 防止短key先匹配吃掉长key的一部分
