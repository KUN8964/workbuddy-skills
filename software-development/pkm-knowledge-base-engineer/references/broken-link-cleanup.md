# 全库断链清理脚本与边缘情况处理

> 基于 3,844 文件 / 1,146 断链 → 0 断链的实战验证（2026-05-08）

## 核心清理脚本（生产就绪）

```python
import os, re
from collections import defaultdict

work_dir = "/Users/kkk/Library/Mobile Documents/iCloud~md~obsidian/Documents"

# Step 1: Build complete filename index from ALL .md files
all_md_files = set()
for root, dirs, files in os.walk(work_dir):
    dirs[:] = [d for d in dirs if not d.startswith('.') and 'backup' not in d.lower() and '备份' not in d]
    for f in files:
        if f.endswith('.md'):
            all_md_files.add(f[:-3])  # strip .md

print(f"Indexed {len(all_md_files)} .md files")

# Step 2: Scan all files, find broken links, remove them
link_pattern = re.compile(r'\[\[([^\]]+)\]\]')
total_processed = 0
total_cleaned = 0
cleaned_files = 0

for root, dirs, files in os.walk(work_dir):
    dirs[:] = [d for d in dirs if not d.startswith('.') and 'backup' not in d.lower() and '备份' not in d]
    for fname in files:
        if not fname.endswith('.md'):
            continue
        fpath = os.path.join(root, fname)
        try:
            with open(fpath, 'r', encoding='utf-8') as f:
                original = f.read()
        except:
            continue
        
        total_processed += 1
        links = link_pattern.findall(original)
        if not links:
            continue
        
        modified = original
        changes = 0
        
        for raw_link in set(links):  # deduplicate to avoid over-counting
            target = raw_link.split('|')[0].strip()
            if target.endswith('.md'):
                target = target[:-3]
            
            if target in all_md_files:
                continue  # ✅ valid link, keep it
            
            # ❌ Broken link: remove [[ ]] but keep display text
            parts = raw_link.split('|', 1)
            target_part = parts[0].strip()
            display = parts[1].strip() if len(parts) > 1 else target_part
            
            full_link = f'[[{raw_link}]]'
            count = modified.count(full_link)
            if count > 0:
                modified = modified.replace(full_link, display)
                changes += count
        
        if changes > 0:
            with open(fpath, 'w', encoding='utf-8') as f:
                f.write(modified)
            cleaned_files += 1
            total_cleaned += changes

print(f"\n=== CLEANUP COMPLETE ===")
print(f"Files scanned: {total_processed}")
print(f"Files modified: {cleaned_files}")
print(f"Broken links removed: {total_cleaned}")
```

## 验证脚本

清理后必须运行验证，确认断链归零：

```python
import os, re

work_dir = "..."

all_md_files = set()
for root, dirs, files in os.walk(work_dir):
    dirs[:] = [d for d in dirs if not d.startswith('.') and 'backup' not in d.lower() and '备份' not in d]
    for f in files:
        if f.endswith('.md'):
            all_md_files.add(f[:-3])

link_pattern = re.compile(r'\[\[([^\]]+)\]\]')
total_links = 0
broken = 0

for root, dirs, files in os.walk(work_dir):
    dirs[:] = [d for d in dirs if not d.startswith('.') and 'backup' not in d.lower() and '备份' not in d]
    for fname in files:
        if not fname.endswith('.md'):
            continue
        with open(os.path.join(root, fname), 'r', encoding='utf-8') as f:
            content = f.read()
        for raw_link in link_pattern.findall(content):
            total_links += 1
            target = raw_link.split('|')[0].strip()
            if target.endswith('.md'):
                target = target[:-3]
            if target not in all_md_files:
                broken += 1
                rel = os.path.relpath(os.path.join(root, fname), work_dir)
                print(f"  BROKEN: [{rel}] → [[{raw_link}]]")

if broken == 0:
    print(f"\n✅ ZERO BROKEN LINKS — {total_links} total, all valid")
```

## 边缘情况与处理

### 1. 嵌套链接 `[[YYYY-MM-DD-[[TERM]]`

**现象**：外层链接包裹内层有效链接，如 `[[2026-03-24-[[RLHF]]`

**原因**：编译算法缺陷——对已包含 `[[TERM]]` 的文本再次包裹外层链接。

**处理**：直接字符串替换，剥离外层 `[[` 和 `]]`：
```python
old = '[[2026-03-24-[[RLHF]]'  # 外层开头 [[ + 内容 + 内层 ]]
new = '2026-03-24-[[RLHF]]'    # 保留内层有效链接
content = content.replace(old, new)
```

**注意**：必须逐个文件针对性处理，不能用全局正则（会误匹配）。

### 2. 表格中的碎片链接

**现象**：表格单元格中 `[[target` 缺少闭合 `]]`，如 `| 2025-08-12-npm与[[2025-08-12-npm` | missing_file |`

**原因**：表格的 `|` 分隔符干扰了 wikilink 解析，导致 `]]` 丢失。

**检测**：用正则 `\[\[([^\[\]\n]{2,80}?)(?:\n|\| [a-z]| \|)` 匹配未闭合的 `[[...` 片段。

**处理**：去除 `[[` 前缀，保留纯文本：
```python
fragment_pattern = re.compile(r'\[\[([^\[\]\n]{2,80}?)(?:\n|\| [a-z]| \|)')
for m in fragment_pattern.finditer(content):
    inner = m.group(1).strip()
    content = content.replace(f'[[{inner}', inner, 1)
```

### 3. 长句/整段描述作为链接

**现象**：`[[RLHF提升人工智能的情商和德商]]`、`[[RLHF就是让人工智能学习人类偏好和价值观的一套方法]]`

**原因**：编译算法将完整句子错误识别为"术语"并添加链接。

**处理**：标准清理流程即可覆盖——这类链接目标不可能存在于文件名索引中，第一次扫描就会被移除。

### 4. 带 `.md` 后缀的链接目标

**现象**：`[[2026-02-12-数据集.md]]` 或 `[[2026-02-12-数据集.md|显示文本]]`

**处理**：在提取 target 时统一去除 `.md` 后缀：
```python
target = raw_link.split('|')[0].strip()
if target.endswith('.md'):
    target = target[:-3]
```

## 关键坑点

### ❌ 千万不要：盲目剥离所有链接

**错误做法**（本 session 踩坑）：
```python
# 假设文件中所有 [[...]] 都是无效的，全部剥离
for m in pattern.finditer(content):
    content = content.replace(m.group(0), display_text)
```

**问题**：文件中可能混合了有效链接和无效链接。盲目全部剥离会破坏有效链接，需要额外的恢复操作。

**正确做法**：**始终**对每个链接做文件名索引检查：
```python
for raw_link in set(links):
    target = raw_link.split('|')[0].strip()
    if target.endswith('.md'): target = target[:-3]
    
    if target in all_md_files:
        continue  # 保留
    # 只移除无效的
```

### ✅ 正确模式：多轮扫描 + 验证

1. **第一轮**：标准扫描，移除所有文件名索引不匹配的链接
2. **验证**：重新扫描全库
3. **第二轮**：针对性修复边缘情况（嵌套链接、表格碎片）
4. **最终验证**：确认 0 断链
5. **如果有残留**：检查具体文件，逐个修复

### 目录扫描注意事项

- 必须排除备份目录（`backup`、`备份`）和隐藏目录（`.` 开头）
- 使用 `os.walk` 时用 `dirs[:]` 切片过滤：
  ```python
  dirs[:] = [d for d in dirs if not d.startswith('.') and 'backup' not in d.lower() and '备份' not in d]
  ```

## 实战数据（2026-05-08）

| 目录 | 断链数 | 清理后 |
|:--|:--|:--|
| `00_Inbox/` | 913 | 0 |
| `04_Tools/` | 141 | 0 |
| `02_Outputs/` | 91 | 0 |
| `01_Wiki_by_LLM/` | 1 | 0 |
| **全库总计** | **1,146** | **0** |

断链率：18.0% → 0%
修改文件：256 个
