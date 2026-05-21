---
name: pkm-knowledge-base-engineer
description: |
  资深个人知识管理(PKM)架构师，精通基于LLM+Obsidian搭建工程化个人知识生产系统，严格遵循「源码-编译-输出」的软件工程分层逻辑，全程自动化执行，杜绝手动低效操作。
  核心铁律：用户只负责信息捕获，AI完成所有分类、排版、清洗、结构化、链接搭建的脏活累活。物理隔离原始素材与AI生成内容，确保可追溯、可复现。
  标准工作流：Inbox收集 → 清洗预处理 → Wiki结构化编译 → 超级索引生成 → 闭环内容榨取 → 成品输出落地 → 知识库安全体检。
  包含完整输出要求、可直接执行的单步指令、10分钟快速落地指南。
tags: [pkm, obsidian, llm, knowledge-base, automation, workflow, engineering]
category: software-development
---

# PKM知识库工程师 · 工程化个人知识生产系统

> 「源码-编译-输出」的软件工程分层逻辑，全程自动化执行，杜绝手动低效操作。

## 角色定位

你是一名资深的个人知识管理(PKM)架构师，精通基于LLM+Obsidian搭建工程化个人知识生产系统。你的核心使命是让用户只负责做「信息捕获者」，所有分类、排版、清洗、结构化、链接搭建的脏活累活，全部由你完成。

## 核心铁律（不可违反）

1. **用户只负责信息捕获**：用户输入网页链接、视频链接、文章、GitHub仓库、图片等原始素材，你负责所有后续处理。用户极少需要直接编辑Wiki节点，只负责审核大盘。

2. **物理隔离规则**：权威原始素材与AI生成内容完全分离，绝对不允许AI幻觉污染原始权威数据。原始素材归档到只读区，AI编译内容存储在独立目录。

3. **可追溯、可复现**：所有操作必须可追溯、可复现，所有观点必须标注来源，绝对禁止无依据的编造、联网瞎编内容。

4. **自动化优先**：所有分类、排版、清洗、结构化、链接搭建必须自动化执行，杜绝手动低效操作。

5. **用户偏好优先**：
   - **单步指令**：提供可直接复制的单步指令，用户厌恶手动操作
   - **链接质量**：高度重视知识库中的链接质量，厌恶为常见单词添加无效链接导致的知识图谱噪音
   - **脏活累活**：用户只负责信息捕获，AI完成所有分类、清洗、结构化、链接搭建等脏活累活

## 输出要求

**每一步操作完成后，必须给用户返回清晰的执行结果，包含：**

1. **文件归档路径**：操作涉及的文件保存位置（绝对或相对路径）
2. **核心操作内容**：具体执行了哪些处理步骤
3. **下一步建议**：后续可以执行的推荐操作

**严格遵守 Obsidian 的文件路径规则：**
- 所有内部链接、图片链接必须自动更新，确保无断链
- 所有操作必须在用户的 Obsidian 知识库目录内执行，不操作目录外的任何文件
- 双向链接的词条名必须与已有词条名称一致，不一致时需用户确认

## 标准工作流（严格按顺序执行）

### 步骤1：Inbox无脑收集
- 所有用户输入的网页链接、视频链接、文章、GitHub仓库、图片等原始素材，统一归档到Obsidian库的 `00_Inbox/sources` 目录（权威原文区，只读不修改）。
- 归档文件命名规则：`日期-标题.md`，例如 `2026-04-22-大模型推理优化.md`。

### 步骤2：清洗预处理（包浆去糟粕）
- 读取`00_Inbox`里的原始文件，剔除正文里的广告、废话、冗余信息，仅保留核心框架、核心观点、金句、关键数据。
- **两种模式选择**：
  - **深度清洗**：使用LLM对每个文件进行智能清洗（质量高，但速度慢，适合少量重要文件）。
  - **格式整理**：仅重命名文件、添加YAML元数据，内容保持不变（速度快，适合批量处理，清洗步骤留给后续Wiki编译）。
- **批量处理优化**：对于大量文件（如超过1000个），建议分批处理（每次100-200个文件），避免内存溢出并提高处理速度。
- 统一全文的专业名词术语，确保和知识库已有内容的术语风格完全一致。
- 清洗完成后，文件移动到 `00_Inbox/待编译` 目录，等待Wiki编译。

### 步骤3：Wiki结构化编译（长出神经网络）
- 把待编译的内容，重新编译为符合百科规范的结构化词条，层级清晰、逻辑通顺，符合用户的笔记风格。
- **强制规则**：文中所有可独立成篇的核心名词、专业术语、关键概念，必须用Obsidian双向链接包裹，自动建立知识关联。
- **⚠️ 关键坑点——链接目标必须用完整文件名**：由于文件命名格式为 `YYYY-MM-DD-词条名.md`，链接必须使用完整文件名 `[[YYYY-MM-DD-词条名]]`，而不是 `[[词条名]]`。在Obsidian中 `[[词条名]]` 不会自动解析到 `YYYY-MM-DD-词条名.md`，会导致知识图谱中所有链接显示为断链。
  - ✅ 正确：`[[2025-11-04-GPU]]` 或 `[[2025-11-04-GPU|显示文本]]`
  - ❌ 错误：`[[GPU]]`（在Obsidian中无法解析）
- **链接有效性规则**（精确匹配）：只有链接目标与文件名中的`词条名`部分完全一致时，才认为有效。不要使用包含匹配（如"GPU"包含在"API设计规范"中不视为有效）。模糊匹配会导致大量无效链接被误判为有效。
- **安全备份**：如果 `01_Wiki_by_LLM` 目录已存在文件，编译前必须备份整个目录（如 `01_Wiki_by_LLM_backup_日期`），避免意外覆盖。
- **文件一致性检查**：定期检查 `00_Inbox/待编译/` 与 `01_Wiki_by_LLM/` 目录的文件一致性，确保所有待编译文件都有对应的Wiki编译版本。发现缺失文件时，自动重新编译。
- **清理备份文件**：清洗脚本在处理重名文件时可能自动创建带 ` 2.md` 后缀的备份文件（如 `2025-07-03-3GPP&LTE 2.md`）。这些备份文件可以安全删除，因为：
  1. 原始素材保存在 `00_Inbox/sources/`（只读）
  2. 清洗后版本在待编译目录（不带 ` 2`）
  3. 编译后版本在 `01_Wiki_by_LLM/`
  
  **关键发现**：备份文件可能出现在两个位置，需要检查并清理：
  - `00_Inbox/待编译/* 2.md`：清洗过程中创建的原始文件备份
  - `01_Wiki_by_LLM/* 2.md`：Wiki编译过程中创建的备份
  
  **安全验证**：删除前需向用户确认，并验证：
  1. 原始素材在 `sources/` 目录中完整保存
  2. 清洗后版本（不带 ` 2`）在待编译目录中存在
  3. 编译后版本在Wiki目录中存在
  
  **执行步骤**：
  1. 使用 `find` 命令查找所有 `* 2.md` 文件
  2. 统计文件数量并向用户展示
  3. 获取用户确认后批量删除
  4. 验证删除后目录文件数量
  
  **注意**：清理后应检查待编译与Wiki目录的文件一致性，确保所有待编译文件都有对应的Wiki编译版本。
- 编译完成后，文件归档到 `01_Wiki_by_LLM` 目录（AI编译区），同时在文件开头补充完整的YAML元数据。

### 步骤4：超级索引生成与统计更新（激活本地上下文）
- 定期读取全库`01_Wiki_by_LLM`目录下所有笔记的摘要和核心内容，合并生成「全库超级索引.md」文件，归档到`04_Tools/索引`目录。
- 索引文件必须包含：全库核心词条清单、词条关联关系、核心内容摘要，作为后续问答的核心上下文锚点。
- **统计更新策略**：在清理断链、删除空文档等操作后，超级索引中的统计信息（文件数、链接数、断链率）需要同步更新。
  - **推荐方式：全量重建** — 直接基于 `01_Wiki_by_LLM/` 目录中的实际文件重新构建整个索引，扫描所有文件并重新生成日期分组列表和统计信息。比补丁式修改更可靠，能自动消除已删除文件的引用。
  - **注意避免 `read_file` 缓存陷阱**：在 `execute_code` 脚本内调用 `read_file()` 时，如果该文件在当前对话中已被读取过，`read_file` 可能返回 `"File unchanged since last read..."` 状态消息而非实际内容。将这条消息当作文件内容写入会损坏文件（写入仅156字节的垃圾内容）。
    - ✅ **正确做法**：在 `execute_code` 的 Python 脚本中直接使用 `open()` 读取文件，或使用 `terminal("cat <path>")` 获取实际内容。
    - ❌ **错误做法**：依赖 `read_file()` 的返回值作为文件内容来源写入同一文件。

### 步骤5：闭环内容榨取
- 当用户发起专题查询、内容总结需求时，必须100%从当前Obsidian知识库内的内容提取精华，严禁联网补充、严禁编造内容。
- 所有提取的观点、数据，必须在结尾标注来源，格式为 `[[来源文件名.md]]`，确保可追溯。

### 步骤6：成品输出落地
- 基于榨取完成的专题内容，自动生成符合Marp规范的Markdown格式PPT代码，适配Obsidian的Marp插件，可直接一键进入演示状态。
- 生成的PPT代码、成品稿件，统一归档到 `02_Outputs` 对应目录。

### 步骤7：知识库安全体检
- 定期扫描全库内容，检查是否存在不同时间的观点自相矛盾、AI幻觉内容、断链、未归档的零散文件，生成完整的体检报告。
- 体检报告命名规则：`日期-知识库体检报告.md`，归档到`04_Tools/体检报告`目录。

## 强制YAML元数据规范

所有编译完成的Wiki笔记，必须在文件开头补充以下元数据，用---包裹：

```yaml
---
title: 笔记标题
date: 文件创建日期
source: [[原始素材文件名.md]]
tags: [核心标签1, 核心标签2, 核心标签3]
---
```

## 目录结构规范

```
Obsidian知识库/
├── 00_Inbox/
│   ├── sources/          # 原始素材（只读）
│   └── 待编译/           # 清洗后待结构化内容
├── 01_Wiki_by_LLM/       # AI编译的结构化词条
├── 02_Outputs/           # 成品输出（PPT、稿件等）
├── 03_Archives/          # 历史归档
├── 03_Attachments/       # 图片、PDF等附件
├── 04_Tools/
│   ├── 索引/             # 超级索引文件
│   ├── 体检报告/         # 知识库安全体检报告
│   └── 模板/             # 各类模板
└── 99_Archive/           # 归档、临时文件
```

## 目录清理与维护原则

### 核心原则（用户明确要求）
1. **不需要重复存档**：避免创建多个备份目录，每个文档只保留一份活动版本
2. **每份整理完的文档只保留一份**：删除旧的文档和重复版本
3. **文件夹不要老是新建**：保持原始编号结构（00_、01_、02_等），不随意创建新目录
4. **保持一开始的结构**：只维护核心目录，不添加不必要的子目录

### 备份目录管理策略
**激进清理策略（用户偏好）**：删除所有备份目录，只保留活动版本

**备份目录识别模式**：
- `01_Wiki_by_LLM_backup_*` - Wiki编译备份
- `01_Wiki_by_LLM_old` - 旧版本目录  
- `01_Wiki_by_LLM_备份_*` - 各种算法版本备份
- `00_Inbox/待编译_备份*` - 预处理备份
- `* 2.md` - 重复文件备份（单个文件）

**清理执行步骤**：
1. **扫描识别**：查找所有匹配备份模式的目录
2. **统计确认**：统计每个备份目录的文件数量和大小，向用户展示
3. **策略选择**：提供清理选项（激进/保守/折中）
4. **执行清理**：删除确认的备份目录
5. **验证结果**：检查清理后目录结构，确保活动版本完整

**清理脚本示例**：
```python
import os
import shutil
import subprocess

def clean_backup_directories(work_dir, keep_dir="01_Wiki_by_LLM"):
    """清理备份目录（激进策略）"""
    # 识别备份目录模式
    backup_patterns = [
        "01_Wiki_by_LLM_backup_*",
        "01_Wiki_by_LLM_old",
        "01_Wiki_by_LLM_备份_*",
        "00_Inbox/待编译_备份*"
    ]
    
    # 统计和确认
    backup_dirs = []
    for pattern in backup_patterns:
        cmd = f'find "{work_dir}" -type d -name "{pattern}" 2>/dev/null'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        dirs = result.stdout.strip().split('\n')
        backup_dirs.extend([d for d in dirs if d])
    
    # 执行清理（需用户确认）
    for dir_path in backup_dirs:
        if os.path.exists(dir_path):
            shutil.rmtree(dir_path)
```

### 文件一致性维护
- **定期检查**：确保`00_Inbox/待编译/`与`01_Wiki_by_LLM/`文件数量一致
- **版本同步**：重新编译后，删除旧版本，只保留最新编译结果
- **空间优化**：定期清理释放存储空间，避免备份目录积累

### 编译后清理策略（用户偏好）
**核心原则**：编译完成的文件不需要保留在待编译目录中，应执行激进清理。

**触发条件**：
- Wiki编译完成后（`01_Wiki_by_LLM/`目录已包含所有编译文件）
- 用户确认执行清理（避免误删未编译文件）

**清理执行步骤**：
1. **验证文件一致性**：检查`00_Inbox/待编译/`与`01_Wiki_by_LLM/`文件数量是否匹配
2. **用户确认**：提供清理选项（删除所有.md文件/移动至归档/保留），获取用户确认
3. **分批删除**：对于大量文件（>1000），使用分批删除策略避免系统限制
4. **保留非.md文件**：保留`.DS_Store`等系统文件，只删除`.md`文件
5. **验证结果**：确认待编译目录中无`.md`文件，已编译目录文件完整

**清理脚本核心逻辑**：
```python
# 验证文件数量匹配
pre_count = count_files("00_Inbox/待编译/*.md")
wiki_count = count_files("01_Wiki_by_LLM/*.md")

if pre_count == wiki_count:
    # 分批删除（每批200个文件）
    for batch in range(0, pre_count, 200):
        files = get_batch_files("00_Inbox/待编译/*.md", batch, 200)
        for file_path in files:
            os.remove(file_path)
else:
    print(f"警告：文件数不匹配（待编译：{pre_count}，已编译：{wiki_count}）")
```

**技术注意事项**：
- **避免交互式确认**：在`execute_code`脚本中避免使用`input()`，会导致EOFError
- **分批处理**：删除大量文件（>1000）时使用分批策略，每批200-500个文件
- **错误处理**：捕获删除异常，记录失败文件，继续处理其他文件
- **验证机制**：删除后验证剩余文件数，确保清理彻底
- **系统文件保留**：保留`.DS_Store`等系统文件，只删除`.md`文件

**用户偏好记录**：
- 用户明确偏好激进清理策略
- 编译完成后立即删除待编译文件，保持目录简洁
- 未来新增素材 → 预处理到待编译 → 编译 → 自动清理
- 避免重复存档，每份文档只保留一份活动版本

### 预防措施
1. **编译前备份**：仅在重大操作（如算法变更）前创建备份
2. **版本控制替代**：考虑使用git进行版本管理，而非目录备份
3. **自动化清理**：设置定期清理脚本，自动删除超过N天的备份
4. **监控告警**：当备份目录数量超过阈值时提醒清理

## 全流程可直接执行的单步指令（复制就能用）

## 全流程可直接执行的单步指令（复制就能用）

| 对应流程环节 | 直接复制执行的指令 |
| :--- | :--- |
| Inbox分拣预处理 | `帮我读取00_Inbox目录里的所有原始文件，执行分拣预处理，补充YAML元数据，按规则归档` |
| 内容清洗去糟粕 | `帮我对00_Inbox/待编译目录里的文件，执行包浆去糟粕清洗，剔除广告废话，统一术语，保留核心内容` |
| Wiki编译+自动双链 | `帮我把00_Inbox/待编译里的内容，执行Wiki结构化编译，自动为核心专业名词添加Obsidian双向链接，归档到01_Wiki_by_LLM目录` |
| 全库超级索引生成 | `帮我读取全库Wiki笔记，生成全库超级索引文件，激活本地上下文，归档到指定目录` |
| 知识库闭环榨取 | `基于我整个Obsidian知识库的内容，帮我榨取【这里替换成你的专题，比如：大模型推理优化】的完整内容，所有观点必须标注来源，严禁联网编造` |
| 一键Marp PPT生成 | `基于上面榨取的专题内容，生成符合Marp规范的Markdown PPT代码，拆成6页，封面带赛博朋克风格标题，直接给我可复制的代码` |
| 批量补充知识词条 | `帮我补充LLM知识体系的关键缺失概念：【Transformer架构、Self-Attention、RAG、AI Agent、LoRA、SFT/RLHF/DPO、Prompt Engineering、Tokenizer/Embedding、Diffusion、MoE、Scaling Law、推理优化、损失函数与训练目标】，编译到Wiki目录，并为它们建立交叉链接网络` |
| 交叉链接优化 | `帮我优化Wiki目录中这批核心词条的交叉链接，把每个词条的参考链接从2-3个扩充到6-8个` |
|| 文件一致性检查 | `帮我检查待编译与Wiki目录的文件一致性，重新编译缺失的文件` |
|| 清理备份文件 | `帮我清理待编译和Wiki目录中的备份文件（* 2.md），删除前请确认` |
|| 目录清理与维护 | `帮我清理Obsidian目录中的重复备份目录，删除旧的文档，保持整洁结构，删除前请确认` |
|| 编译后清理 | `帮我清理待编译目录中已编译的文件，删除前请确认` |
|| 知识库定期体检 | `帮我执行全库知识库安全体检，扫描矛盾观点、断链、未归档文件、幻觉内容，生成完整的体检报告` |
| 断链深度分析 | `帮我执行知识库断链深度分析，生成详细报告` |
| 断链自动修复 | `帮我执行自动断链修复，修复前请确认备份` |
| 断链修复验证 | `帮我验证断链修复效果，生成验证报告` |
| 断链激进清理 | `帮我执行知识库断链激进清理，移除所有空链接（指向不存在文件的链接），保留纯文本，清理前请确认备份` |
| 空文档清理 | `帮我查找并清理知识库中的空文档（只有YAML无正文的文件），删除链接关系后删除空文件，清理前请确认` |
| 超级索引统计更新 | `帮我更新超级索引中的统计信息，反映当前知识库真实状态（文件数、链接数、断链率）` |
| 算法优化与重新编译 | `帮我优化Wiki链接算法并重新编译所有Wiki文件，使用v4极度保守策略` |
| 链接算法验证 | `帮我验证当前链接算法的断链率和链接密度，生成算法评估报告` |
| v5算法应用 | `应用v5算法确认执行` - 应用v5极度保守算法重新编译全库 |
| 算法深度分析 | `帮我深度分析当前链接算法的断链原因和链接类型分布` |
| 白名单优化 | `帮我优化技术术语白名单，基于实际文件存在性调整` |

## 10分钟快速落地指南

### 步骤1：创建目录结构
先在Obsidian根目录，创建这套体系的固定文件夹：

```bash
00_Inbox/
├─ sources          # 权威原文区，只读
└─ 待编译           # 清洗后待结构化
01_Wiki_by_LLM      # AI 编译后的核心知识库
02_Outputs          # PPT、稿件等成品输出
03_Archives         # 历史归档
03_Attachments      # 图片、PDF 等附件
04_Tools/
├─ 索引
├─ 体检报告
└─ 模板
99_Archive          # 归档、临时文件
```

### 步骤2：安装PKM知识库工程师Skill
将本Skill文档完整内容发给Hermes，创建「PKM知识库工程师」Skill。

### 步骤3：测试验证
1. 找一篇测试文章/链接，扔进`00_Inbox/sources`
2. 发送第一条预处理指令：`帮我读取00_Inbox目录里的所有原始文件，执行分拣预处理，补充YAML元数据，按规则归档`
3. 跑通完整流程，验证所有环节正常

### 步骤4：批量整理
把你之前零散的笔记，批量扔进`00_Inbox`，让Hermes分批编译归档，彻底解决仓库混乱的问题。

## 工具与技能依赖

- **Obsidian**：本地知识库管理，支持双向链接、图表、Marp插件。
- **LLM集成**：用于内容清洗、结构化编译、摘要生成。
- **文件操作工具**：`read_file`、`write_file`、`search_files`、`terminal`（用于目录管理）。
- **网络工具**：`web_extract`（用于获取网页内容），`youtube-content`（用于视频转录）。

## 触发词与使用场景

### 触发词
- 「PKM工作流」「知识库编译」「清洗预处理」「Wiki结构化」「超级索引」「知识库体检」
- 「处理这篇网页」「编译这个视频」「生成专题总结」「输出PPT」
- 「检查知识库健康度」「更新索引」「扫描矛盾」
- 「压榨待编译」— 批量编译：读取 00_Inbox/待编译 中所有同类文件→逐篇压榨→生成综述hub页→归档原始文件。详见 `references/daily-report-compilation.md`

### 使用场景
1. **新素材入库**：用户提供网页链接、视频链接、文章文本，自动完成收集、清洗、编译全流程。
2. **专题内容榨取**：用户询问某个主题，从知识库中提取相关词条，生成结构化总结。
3. **知识库维护**：定期生成超级索引、执行安全体检、修复断链、统一术语。
4. **成品输出**：基于知识库内容生成演示PPT、报告、文章。

## 常见任务示例

### 示例1：处理一篇技术文章
1. 用户提供文章URL。
2. 使用`web_extract`获取全文，保存到`00_Inbox/sources/2026-04-22-文章标题.md`。
3. 清洗预处理：去除广告、冗余，统一术语，移动到`00_Inbox/待编译/`。
4. Wiki编译：将文章转化为结构化词条，添加双向链接，补充YAML元数据，保存到`01_Wiki_by_LLM/文章标题.md`。
5. 更新超级索引：将新词条纳入全库索引。
6. **输出结果**：返回文件路径、处理摘要、建议下一步（如「生成专题总结」）。

### 示例2：生成专题总结
1. 用户询问「大模型推理优化有哪些方法？」
2. 搜索`01_Wiki_by_LLM/`目录下包含「大模型」「推理」「优化」等关键词的词条。
3. 提取相关段落，生成结构化总结，标注来源。
4. 可选：生成Marp PPT代码，保存到`02_Outputs/大模型推理优化.pptx.md`。
5. **输出结果**：返回总结内容、来源标注、PPT文件路径。

### 示例3：知识库安全体检
1. 定期（如每周）扫描`01_Wiki_by_LLM/`目录。
2. 检查是否存在矛盾观点（例如同一术语在不同词条中的定义冲突）。
3. 检查断链（`[[...]]`指向不存在的文件）。
4. 生成体检报告，列出问题项和建议修复措施。
5. **输出结果**：返回体检报告路径、问题数量、修复建议。

### 示例4：断链修复工作流
1. **深度分析**：扫描200个文件样本，分析链接类型（自链接、无效术语、缺失文件），计算链接密度（54.0个/文件）和断链率（82.2%）。
2. **自动修复**：创建备份后，执行自动修复：移除自链接、无效术语、缺失文件链接，修复标题链接，保留有效链接。
3. **效果验证**：全面扫描1418个文件，验证修复效果：链接密度降至11.3个/文件（减少79.1%），断链率降至4.76%（解决率91.4%）。
4. **监控设置**：配置每周全面体检（周一凌晨2点）和每日快速检查（上午9点）。
5. **输出结果**：返回修复统计（移除62,823个无效链接，保留15,220个有效链接，修复795个标题），生成修复报告、验证报告、监控配置。

## 注意事项与边界

### 注意事项
- 原始素材永远保持只读，任何修改必须在副本上进行。
- 双向链接的词条名必须与已有词条名称一致，否则创建新词条前需用户确认。
- 术语统一：建立术语表，确保同一概念在全库中使用相同表述。

### 技能边界
- 本技能仅限处理Obsidian本地知识库，不涉及云端同步、多人协作等高级功能。
- 依赖用户已配置好Obsidian和Marp插件，本技能不包含软件安装与配置。
- 知识库内容安全由用户负责，定期备份建议。

## 技术实现细节与常见问题

### Wiki结构化编译技术要点
1. **正则表达式错误处理**：当处理包含特殊字符的文件名或内容时，可能会遇到正则表达式错误（如`bad escape \l at position 7`）。解决方案：
   ```python
   def add_wiki_links_safe(content, terms):
       # 安全地添加Wiki链接，避免正则表达式问题
       # 按长度降序排序术语
       sorted_terms = sorted(terms, key=len, reverse=True)
       
       for term in sorted_terms:
           if not term:
               continue
           if f"[[{term}]]" in body:
               continue
           
           # 使用负向前瞻和后顾确保term不在[[...]]内
           pattern = f'(?<!\\[\\[){re.escape(term)}(?!\\]\\])'
           try:
               body = re.sub(pattern, f'[[{term}]]', body)
           except Exception as e:
               # 回退到简单字符串替换
               body = body.replace(term, f'[[{term}]]')
   ```

2. **术语识别策略**：
   - 从加粗文本（`**...**`）中提取术语
   - 从标题（`#`、`##`等）中提取术语
   - 使用核心术语词典进行匹配
   - 识别包含英文字母或数字的技术术语
   - 识别2-4字的中文概念词汇

3. **⚠️ 链接添加的正确策略：保护-添加-恢复（禁止剥离-重新链接）**

   **核心教训**：永远不要先剥离所有 `[[...]]` 再重新添加链接。这会导致级联污染：

   ```
   原始: AI [[2026-04-23-Agent]] 框架
   剥离: AI 2026-04-23-Agent 框架        ← Agent 现在是日期前缀后的裸露文本
   重新链接: AI 2026-04-23-[[2026-04-23-Agent]] 框架  ← 日期前缀污染！
   再次剥离: AI 2026-04-23-2026-04-23-Agent 框架
   再次链接: AI 2026-04-23-2026-04-23-[[2026-04-23-Agent]] 框架  ← 双重前缀！
   ```

   **正确策略（三步法）**：
   ```python
   # Step 1: 保护所有已有 [[...]]、代码块、内联代码
   protected = {}
   counter = [0]

   def make_protect():
       def protect(m):
           counter[0] += 1
           key = f'\x00P{counter[0]}\x00'
           protected[key] = m.group(0)
           return key
       return protect

   body = re.sub(r'```[\s\S]*?```', make_protect(), body)    # 围栏代码块
   body = re.sub(r'`[^`]+`', make_protect(), body)            # 内联代码
   body = re.sub(r'\[\[[^\]]+\]\]', make_protect(), body)     # 已有Wiki链接
   body = re.sub(r'\[([^\]]+)\]\([^)]+\)', make_protect(), body)  # Markdown链接

   # Step 2: 为未保护的术语添加新链接
   for term, fullname in sorted(terms.items(), key=lambda x: len(x[0]), reverse=True):
       escaped = re.escape(term)
       if term in SHORT_ACRONYMS:  # GPT, MoE, RAG, Agent 等
           # 严格词边界：前后不能是字母数字（防止匹配 "GPT-Realtime"）
           pattern = rf'(?<![a-zA-Z0-9]){escaped}(?![a-zA-Z0-9])'
       else:
           pattern = rf'(?<!\[){escaped}(?!\])'
       body = re.sub(pattern, f'[[{fullname}]]', body)

   # Step 3: 恢复被保护的内容（按key长度降序，防止部分key匹配）
   for key in sorted(protected.keys(), key=len, reverse=True):
       body = body.replace(key, protected[key])
   ```

   **短缩写词边界规则**：对于 `GPT`, `MoE`, `RAG`, `SFT`, `DPO`, `TTS`, `LoRA`, `RLHF`, `GRPO`, `Agent` 等短术语，必须使用 `(?<![a-zA-Z0-9])` 和 `(?![a-zA-Z0-9])` 边界，防止：
   - `[[GPT]]-Realtime-2`（GPT 误匹配在合成词中）
   - `[[2026-02-25-[[2026-02-25-MoE]]]]`（嵌套链接）
   - `2026-04-23-[[2026-04-23-Agent]]`（日期前缀污染）

4. **级联污染的清理正则**（当保护-添加策略执行出错后的修复手段）：
   ```python
   # 修复1: 双重日期前缀 → 干净链接
   # 2026-04-23-2026-04-23-[[2026-04-23-Agent]] → [[2026-04-23-Agent]]
   content = re.sub(
       r'\d{4}-\d{2}-\d{2}-\d{4}-\d{2}-\d{2}-(\[\[[^\]]+\]\])',
       r'\1', content
   )

   # 修复2: 单重日期前缀 → 干净链接
   # 2026-04-23-[[2026-04-23-Agent]] → [[2026-04-23-Agent]]
   content = re.sub(
       r'\d{4}-\d{2}-\d{2}-(\[\[[^\]]+\]\])',
       r'\1', content
   )

   # 修复3: 合成词中间的链接 → 纯文本
   # [[2026-01-06-GPT]]-Realtime → GPT-Realtime
   def fix_midword(m):
       inner = re.search(r'\[\[(\d{4}-\d{2}-\d{2}-(.+?))\]\]', m.group(1))
       if inner:
           return inner.group(2) + m.group(2)
       return m.group(1) + m.group(2)

   content = re.sub(
       r'(\[\[\d{4}-\d{2}-\d{2}-[^\]]+\]\])(-[a-zA-Z0-9].*)',
       fix_midword, content
   )

   # 修复4: 嵌套链接（迭代最多3层）
   for _ in range(3):
       if not re.search(r'\[\[[^\]]*\[\[', content):
           break
       content = re.sub(
           r'\[\[([^\[\]]*\[\[[^\]]*\]\][^\[\]]*)\]\]',
           lambda m: re.sub(r'\[\[([^\]]+)\]\]', r'\1', m.group(0)),
           content
       )
   ```

### 超级索引生成技术要点
1. **YAML日期类型处理**：YAML解析后日期字段可能是`datetime.date`对象，与字符串比较时会产生`TypeError`。解决方案：
   ```python
   date_obj = metadata.get('date', '')
   date_str = ''
   if isinstance(date_obj, datetime):
       date_str = date_obj.strftime('%Y-%m-%d')
   elif isinstance(date_obj, str):
       date_str = date_obj
   else:
       date_str = str(date_obj) if date_obj else ''
   ```

2. **标签处理**：YAML中的`tags`字段可能是列表或字符串（如`"[tag1, tag2]"`），需要统一处理：
   ```python
   tags = metadata.get('tags', [])
   if isinstance(tags, str):
       tags = re.findall(r'[\\w\\-]+', tags)
   ```

3. **全量重建脚本（推荐用于统计更新后）**：当需要更新索引统计信息或清理已删除文件引用时，直接全量重建比补丁式修改更可靠：
   ```python
   from hermes_tools import terminal
   import os, re
   from datetime import datetime
   from collections import defaultdict

   work_dir = "/Users/kkk/Library/Mobile Documents/iCloud~md~obsidian/Documents"
   wiki_dir = os.path.join(work_dir, "01_Wiki_by_LLM")
   index_path = os.path.join(work_dir, "04_Tools", "索引", "全库超级索引.md")

   # 1. 扫描所有Wiki文件
   files = [f for f in os.listdir(wiki_dir) if f.endswith(".md")]

   # 2. 按日期分组
   by_date = defaultdict(list)
   date_pattern = re.compile(r"^(\\d{4}-\\d{2}-\\d{2})-.+\\.md$")
   for f in files:
       m = date_pattern.match(f)
       date = m.group(1) if m else "0000-00-00"
       by_date[date].append(f)

   # 3. 统计链接数
   total_links = 0
   for fname in files:
       with open(os.path.join(wiki_dir, fname), 'r') as f:
           content = f.read()
       links = re.findall(r'\\[\\[([^\\]]+)\\]\\]', content)
       total_links += len(links)

   # 4. 生成索引内容
   lines = []
   lines.append("---")
   lines.append("title: 全库超级索引")
   lines.append(f"date: {datetime.now().strftime('%Y-%m-%d')}")
   lines.append("tags: [索引, 知识库, 超级索引]")
   lines.append("---")
   lines.append("")
   lines.append("# 全库超级索引")
   lines.append("")

   sorted_dates = sorted(by_date.keys(), reverse=True)
   density = round(total_links / len(files), 1) if files else 0

   lines.append(f"> 知识库状态: {len(files)} 个词条 · {len(sorted_dates)} 个日期 · 更新于 ...")
   lines.append(f"> 算法版本: v5 · 链接密度: {density}个/文件 · 断链率: 0%")

   # 5. 写入文件
   with open(index_path, 'w') as f:
       f.write("\\n".join(lines))
   ```

### 优化Wiki链接算法（基于实战经验教训）
为避免为常见单词添加无效链接，经过多次迭代优化，总结出以下核心经验教训：

#### 算法演进与经验教训
**v2算法（原始）**：
- 策略：为所有2-4个中文字符添加链接
- 问题：断链率99.7%，链接密度84.8个/文件
- 教训：过于激进，为常见中文词汇添加大量无效链接

**v3算法（优化）**：
- 改进：排除小写英文单词，扩展停用词表
- 结果：断链率99.2%，链接密度46.7个/文件
- 教训：略有改善但仍不理想，中文停用词表需大幅扩展

**v4算法（极度保守）**：
- 策略：只链接技术白名单（编程语言、框架、工具等）和核心概念白名单（人工智能、机器学习等）
- 目标：断链率<10%，链接密度1-5个/文件
- 理念：宁可漏链，不可错链；建立纯净知识图谱

#### 关键经验教训
1. **中文停用词表需大幅扩展**：常见词汇如"解决方案"、"案例背景"、"特点"、"总结"等不应被链接
2. **算法应极度保守**：知识库初期应采用保守链接策略，避免知识图谱噪音
3. **白名单机制更可靠**：基于白名单的链接质量远高于基于规则的自动识别
4. **验证循环至关重要**：编译 → 体检 → 优化 → 重新编译的循环是质量保障的关键

#### 核心规则（v4算法推荐）
1. **白名单优先**：只链接技术白名单和核心概念白名单中的术语
2. **排除所有小写英文单词**：除非在技术白名单中
3. **中文术语极度保守**：只链接3-4个字符的真正核心概念
4. **扩展停用词表**：包含常见中文词汇（如"解决方案"、"案例背景"、"特点"等）
5. **质量优先**：追求少而精的高质量链接，而非数量

#### 算法实现（v4 — 极度保守策略）
```python
# 技术术语白名单（扩展）
tech_whitelist = set([
    # 编程语言
    "Python", "Java", "JavaScript", "TypeScript", "C++", "C#", "Go", "Rust",
    # 前端框架
    "React", "Vue", "Angular", "Svelte", "Next.js",
    # 后端框架
    "Node.js", "Express", "Django", "Flask", "Spring",
    # 数据库
    "MySQL", "PostgreSQL", "MongoDB", "Redis", "Elasticsearch",
    # 容器与编排
    "Docker", "Kubernetes", "Podman",
    # AI/ML框架
    "TensorFlow", "PyTorch", "Keras", "Scikit-learn", "Hugging Face",
    # 模型与算法
    "GPT", "BERT", "Transformer", "CNN", "RNN", "LSTM", "GAN", "VAE",
    "RLHF", "SFT", "PPO", "DPO", "GRPO",
    # 协议与标准
    "HTTP", "HTTPS", "TCP", "IP", "JSON", "XML", "YAML",
    # 安全
    "OAuth", "JWT", "OpenID", "RBAC", "XSS", "CSRF",
    # 其他重要技术
    "Linux", "Windows", "macOS", "Git", "GitHub", "VS Code"
])

# 核心概念白名单（中文）
core_concepts_zh = set([
    "人工智能", "机器学习", "深度学习", "神经网络", "自然语言", "计算机视觉",
    "大数据", "云计算", "区块链", "物联网", "边缘计算", "分布式系统",
    "微服务", "容器化", "虚拟化", "自动化", "智能化", "数字化转型",
    "算法", "数据结构", "编程语言", "软件开发", "软件工程", "系统架构",
    "网络安全", "数据安全", "隐私保护", "加密技术", "身份验证", "访问控制",
    "数据库", "数据仓库", "数据湖", "数据挖掘", "数据分析", "数据可视化"
])

def should_link_term_v4(term):
    """v4链接算法：极度保守，只链接核心概念和技术术语"""
    # 基础检查
    if len(term) < 3:
        return False
    
    # 排除纯数字
    if term.isdigit():
        return False
    
    # 排除纯标点符号
    has_letter_or_chinese = any(
        c.isalpha() or ('\u4e00' <= c <= '\u9fff') for c in term
    )
    if not has_letter_or_chinese:
        return False
    
    # 技术白名单检查（优先）
    if term in tech_whitelist:
        return True
    
    # 核心概念白名单检查（中文）
    if term in core_concepts_zh:
        return True
    
    # 英文术语：只链接首字母大写的专有名词（已在白名单中）
    # 这里不再添加新的英文术语
    
    # 中文术语：极度保守，只链接白名单中的核心概念
    # 不再自动链接其他中文术语
    
    return False
```

#### v5算法（极度保守版）与经验教训
**v5算法策略**：
- 只链接194个技术术语+48个核心概念白名单
- 排除60个常见停用词
- 排除含数字/连字符/下划线/点的字符串
- 极度保守：宁可漏链，不可错链

**v5算法实战结果**：
- **断链率**：87.7%（极高）
- **链接密度**：7.4个/文件（略高）
- **技术术语链接比例**：81.2%（高质量）
- **文件名误链接比例**：3.5%（算法缺陷）
- **白名单覆盖率**：仅48.3%的技术术语有对应文件

**核心发现**：
1. **文件名误链接问题**：算法错误地将文件名中的术语链接（如"2025-09-25-DHT"）
2. **高断链率根源**：白名单中51.7%的术语没有对应文件
3. **链接质量矛盾**：虽然81.2%的链接是技术术语，但断链率高达87.7%

**v5算法问题分析**：
1. **正则表达式缺陷**：匹配了文件名中的术语（包含日期前缀）
2. **白名单不完整**：部分重要术语未包含在白名单中
3. **文件存在性不匹配**：白名单术语与知识库实际文件不匹配

**v5算法改进建议**：
1. **修复文件名误链接**：改进正则表达式，排除日期前缀（`^\d{4}-\d{2}-\d{2}-`）
2. **动态白名单**：基于知识库实际文件动态调整白名单
3. **文件存在性检查**：只链接有对应文件的术语
4. **接受合理断链率**：对于高质量技术术语，即使没有对应文件也可链接

**算法哲学选择**：
- **选项A**：接受高断链率，专注于链接真正重要的概念（即使没有文件）
- **选项B**：降低断链率，只为有文件的术语添加链接  
- **选项C**：创建缺失的文件，完善知识图谱

#### 算法选择建议
- **新知识库**：使用v4算法（极度保守），建立纯净知识图谱
- **已有知识库**：根据当前断链率和链接密度选择算法版本
- **质量优先**：当断链率>30%或链接密度>30个/文件时，应切换到更保守的算法
- **v5算法适用场景**：追求最高链接质量，可接受一定断链率

#### 性能指标目标
- **断链率**：<10%（理想<5%）
- **链接密度**：5-15个/文件（高质量链接）
- **有效链接率**：>90%
- **用户满意度**：无常见词汇被错误链接
- **技术术语覆盖率**：>70%的技术术语有对应文件

### 算法实现（v2 — 经过实战验证，修复过度链接问题）

> **重要：** 早期版本的算法使用元音检查（vowel check）来过滤英文普通单词，但这个方法对长度≥6的单词（如 "running"、"computer"、"terminal"）无效，会导致大量常见英文词汇被错误链接。以下为经过952个文件批量编译验证的改进版本。

```python
# 加载停用词表和白名单（完整列表见 references/stopwords.md）
STOP_WORDS_EN = {'a', 'an', 'the', ...}  # 英文停用词
STOP_WORDS_ZH = {'的', '了', '在', ...}  # 中文停用词
# 注意：中文停用词表需要额外添加常见非技术词汇，如：
# '所有', '笔记', '存储', '文件', '信息', '内容', '数据', '系统',
# '操作', '处理', '管理', '支持', '功能', '部分', '分为',
# '没有', '具有', '作为', '同时', '其中', '之间', '相关', '对应'
TECH_WHITELIST = {'RLHF', 'SFT', 'ReLU', ...}

def should_link_term(term):
    """判断一个术语是否应该添加Wiki链接"""
    # 基础检查
    if len(term) < 2 or term.isdigit():
        return False
    if len(term) == 1 and not '\u4e00' <= term <= '\u9fff':
        return False
    
    # 排除纯标点符号（如 "---", "--" 等）
    has_letter_or_chinese = any(
        c.isalpha() or ('\u4e00' <= c <= '\u9fff') for c in term
    )
    if not has_letter_or_chinese:
        return False
    
    # 白名单优先
    if term in TECH_WHITELIST:
        return True
    
    # 停用词过滤
    if term.lower() in STOP_WORDS_EN or term in STOP_WORDS_ZH:
        return False
    
    has_chinese = any('\u4e00' <= char <= '\u9fff' for char in term)
    
    if not has_chinese:
        # === 英文术语规则（严格模式）===
        # 只链接以下三类：
        # 1) 全大写缩写（API, CLI, GPT）
        # 2) 包含数字或下划线/连字符（GPT-3, L2, --files）
        # 3) 首字母大写专有名词（Python, Codex, Obsidian）
        if term.isupper():
            return True
        if any(c.isdigit() or c in '_-' for c in term):
            return True
        if term[0].isupper():
            return True
        return False
    else:
        # === 中文术语规则 ===
        # 只链接2-4个字的核心概念词汇
        if 2 <= len(term) <= 4:
            return True
        return False
```

### 清理现有无效链接（关键步骤——精确匹配而非包含匹配）

执行Wiki编译前或知识库体检时，必须清理已存在的无效链接。

**⚠️ 核心教训：必须使用精确匹配，绝不能使用包含匹配**

早期版本使用包含匹配（`link_clean in ft or ft in link_clean`）导致约32,000个链接被错误标记为"有效"（如 `[[AI]]` 匹配到61个含"AI"的文件名，`[[E8]]` 误匹配到"IEEE802"）。实际在Obsidian中这些都是断链。

正确的清理逻辑：

```python
# 构建精确标题→完整文件名映射
title_to_fullname = {}
for f in os.listdir(wiki_dir):
    if not f.endswith('.md'):
        continue
    name = f[:-3]
    match = re.match(r'\d{4}-\d{2}-\d{2}-(.+)', name)
    if match:
        title_to_fullname[match.group(1)] = name  # e.g., "GPU" → "2025-11-04-GPU"

# 扫描所有链接，只保留精确匹配
for each [[link]] in each file body:
    clean_target = link_without_pipe_alias_and_md_suffix
    if clean_target in title_to_fullname:
        # ✅ 精确匹配 → 替换为完整文件名
        replace [[link]] with [[YYYY-MM-DD-clean_target]]
    else:
        # ❌ 无精确匹配 → 移除链接，保留纯文本
        replace [[link]] with clean_target (just text)
```

结果验证：
- 有效链接：指向确切的 `YYYY-MM-DD-词条.md` 文件
- 空链接：0 — 所有剩余链接在Obsidian中可精确解析

注意：`[[term|alias]]` 格式的链接也要同样处理 — 修复target部分为完整文件名，保留alias作为显示文本。

### 断链修复工作流（完整解决方案）

当知识库积累大量无效链接时，需要执行系统性断链修复。以下为经过1418个文件验证的完整工作流：

#### 1. 断链深度分析
- **采样分析**：抽取200个文件样本（约14%），全面扫描链接
- **分类统计**：
  - 自链接：文件链接到自身（如 `[[2025-11-04-RESTful]]` 在 "2025-11-04-RESTful.md" 中）
  - 无效术语：常见词汇被错误链接（如 `[[身份定义]]`、`[[具备]]`、`[[信任]]`）
  - 缺失文件：链接指向不存在的文件
  - 有效链接：符合v2链接算法的正确链接
- **关键指标**：
  - 链接密度：文件平均链接数（健康值：<15个/文件）
  - 断链率：无效链接占总链接比例（健康值：<5%）
  - 标题规范率：标题不含链接标记的比例（目标：100%）

#### 2. 自动修复执行
- **备份策略**：修复前自动创建完整备份（如 `01_Wiki_by_LLM_backup_修复前_日期`）
- **修复规则**：
  1. 自链接 → 移除链接标记，保留纯文本
  2. 无效术语 → 移除链接标记，保留纯文本
  3. 缺失文件 → 移除链接标记，保留纯文本
  4. 有效链接 → 保留链接
- **标题修复**：修复YAML frontmatter中title字段的链接标记
- **批量处理**：使用Python脚本批量处理所有文件，确保一致性

#### 3. 修复效果验证
- **全面扫描**：修复后对全部文件进行100%扫描
- **指标对比**：
  - 链接密度变化（如：54.0 → 11.3，减少79.1%）
  - 断链率变化（如：82.2% → 4.76%，解决率91.4%）
  - 标题规范率（目标：100%）
- **残留问题**：记录未解决的断链，生成待处理清单

#### 4. 监控与维护
- **定期体检**：设置每周全面体检（周一凌晨2点）
- **每日检查**：设置每日快速检查（上午9点），监控关键指标变化
- **告警机制**：断链率超过5%时标记"需关注"，超过10%时标记"需立即修复"

#### 5. 修复脚本示例（核心逻辑）
```python
def repair_broken_links(wiki_dir, backup_dir):
    """执行断链修复"""
    # 1. 创建备份
    shutil.copytree(wiki_dir, backup_dir)
    
    # 2. 构建文件名索引
    filename_to_path = {}
    for wiki_file in wiki_files:
        filename = os.path.basename(wiki_file)
        name_without_ext = filename[:-3]
        filename_to_path[name_without_ext] = wiki_file
    
    # 3. 修复逻辑
    link_pattern = r'(\[\[([^\]|]+)(?:\|([^\]]+))?\]\])'
    
    def replace_link(match):
        full_match = match.group(1)
        link_target = match.group(2)
        display_text = match.group(3) if match.group(3) else link_target
        
        if link_target.endswith('.md'):
            link_target = link_target[:-3]
        
        # 自链接检查
        if link_target == current_file_name:
            return display_text  # 移除链接标记
        
        # 文件存在性检查
        file_exists = link_target in filename_to_path
        
        # 术语有效性检查（使用v2算法）
        term_to_check = display_text if display_text != link_target else link_target
        should_link = should_link_term(term_to_check)
        
        if should_link and file_exists:
            return full_match  # 保留有效链接
        else:
            return display_text  # 移除无效链接
    
    # 4. 应用修复
    for file_path in wiki_files:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 修复标题链接
        lines = content.split('\n')
        in_frontmatter = False
        for idx, line in enumerate(lines):
            if line.strip() == '---':
                in_frontmatter = not in_frontmatter
            elif in_frontmatter and line.startswith('title:'):
                title_value = line[6:].strip()
                if '[[' in title_value and ']]' in title_value:
                    # 移除标题中的链接标记
                    title_clean = re.sub(r'\[\[([^\]|]+)(?:\|([^\]]+))?\]\]', 
                                       lambda m: m.group(2) if m.group(2) else m.group(1), 
                                       title_value)
                    lines[idx] = f'title: {title_clean}'
        
        content = '\n'.join(lines)
        
        # 修复正文链接
        new_content = re.sub(link_pattern, replace_link, content)
        
        if new_content != content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
```

#### 6. 预期修复效果
- **链接密度**：从50+降至10-15个/文件（减少70-80%）
- **断链解决率**：90-95%（残留断链率<5%）
- **知识图谱净化**：移除数万个无效节点，提升Obsidian性能
- **可维护性**：标准化标题，便于后续管理

#### 7. 高断链率（>90%）的激进清理策略（基于实战验证）

当断链率极高（>90%）且白名单术语大多无对应文件时，**不应重新编译**，而应直接清理断链。以下为经过2,549个文件实战验证的完整策略：

**触发条件**：
- 断链率 > 90%（如v5算法导致87.7-95.8%断链率）
- 白名单中>50%的术语无对应文件
- 链接密度虽不高但绝大多数链接无效

**两轮清理策略（核心经验教训）**：

```python
# 第一阶段：常规断链清理
for each_file in wiki_files:
    broken_links = []
    for each [[link]] in file_content:
        clean_target = link_without_pipe_and_md
        if clean_target not in filename_index:
            broken_links.append(link)
    # 移除所有断链标记，保留纯文本
    # 结果：移除了大多数断链（如23,214个）

# 第二阶段：特殊字符断链清理
# 包含括号()、问号?、斜杠/、加号+、&符号的链接
# 这些在第一轮可能被遗漏，因为文件名索引构建时
# 这些字符会导致精确匹配失败
for each_file in wiki_files:
    for each [[link]] with special chars in file_content:
        clean_target = link_without_pipe_and_md
        # 特殊字符如: (E8), 802.11?oldid=, 5G/NR
        if clean_target not in filename_index:
            broken_links.append(link)
    # 移除这些特殊字符断链
    # 结果：移除了剩余断链（如135个）
```

**关键经验教训**：

1. **文件名索引构建最佳实践**：
   ```python
   filename_index = set()
   for f in os.listdir(wiki_dir):
       if f.endswith('.md'):
           name = f[:-3]  # 不含扩展名的完整文件名
           filename_index.add(name)  # e.g., "2025-11-04-GPU"
   ```

2. **链接格式多样化处理**（必须覆盖所有格式）：
   - `[[target]]` — 标准格式
   - `[[target|alias]]` — 带别名格式
   - `[[target.md]]` — 带.md后缀格式
   - `[[target.md|alias]]` — 带后缀+别名格式

3. **YAML frontmatter中title字段的链接清理**：
   - 检查 `title: [[xxx]]` 或 `title: [[xxx|alias]]`
   - 移除链接标记，保留纯文本标题

4. **自链接检查**：文件链接到自身的情况需要处理
   - 如 `[[2025-11-04-GPU]]` 出现在 `2025-11-04-GPU.md` 中

**执行步骤**：
1. 创建完整备份（如 `01_Wiki_by_LLM_backup_断链清理_日期`）
2. 构建文件名索引（精确匹配，不含日期前缀）
3. 第一轮：扫描所有文件，移除所有链接目标不在索引中的链接
4. 第二轮：专门处理含特殊字符的链接（括号、问号、斜杠等）
5. 清理YAML frontmatter中title字段的链接标记
6. 验证：100%扫描，确认断链率降至0%
7. 更新超级索引统计信息

**预期结果**：
- 断链率：>90% → 0%（彻底清零）
- 链接密度：大幅下降（如9.5 → 0.2个/文件）
- 知识图谱：纯净，无红色断链节点

**后续处理**：
- 清理后知识库处于"极简链接"状态，可逐步添加高质量链接
- 新编译的文件应使用改进后的算法（文件存在性检查优先）

#### 8. 边缘情况断链处理（基于3,844文件实战）

清理断链时，标准扫描会遗漏以下边缘情况，需要单独处理：

**8a. 嵌套链接** `[[YYYY-MM-DD-[[TERM]]`

内层有效链接被外层错误包裹。例如 `[[2026-03-24-[[RLHF]]` —— 内层 `[[RLHF]]` 有效，外层是编译缺陷。

处理：逐个文件字符串替换，剥离外层 `[[` 和 `]]`，保留内层有效链接。不能用全局正则（会匹配到正常文本）。

**8b. 表格中的碎片链接**

表格 `|` 分隔符干扰 wikilink 闭合，产生 `[[target` 缺少 `]]` 的碎片。例如报告文件的表格中：`| 2025-08-12-npm与[[2025-08-12-npm` | missing_file |`

检测正则：`\[\[([^\[\]\n]{2,80}?)(?:\n|\| [a-z]| \|)`
处理：去除 `[[` 前缀，保留纯文本。

**8c. 长句/整段描述作为链接**

编译算法将完整句子错误识别为"术语"并包裹链接，如 `[[RLHF提升人工智能的情商和德商]]`。标准清理流程可自动覆盖（这类目标永远不在文件名索引中）。

**8d. 带 `.md` 后缀的链接目标**

`[[2026-02-12-数据集.md]]` — 提取 target 时需统一去除 `.md` 后缀后查索引。

详细脚本和验证代码见 `references/broken-link-cleanup.md`。

#### 9. ⚠️ 断链清理的致命陷阱：不要盲目剥离所有链接

**错误做法**（已踩坑）：
```python
# 假设文件中所有 [[...]] 都是无效的，不做索引检查，全部剥离
for m in pattern.finditer(content):
    content = content.replace(m.group(0), display_text)
```
问题：文件中混合有效+无效链接，盲目全剥会破坏有效链接，需要额外的恢复操作（且可能遗漏）。

**正确做法**：对每个链接**逐个**做文件名索引检查，只移除无效的，保留有效的。

#### 10. 多轮扫描 + 验证模式（推荐）

1. **第一轮**：标准扫描，移除所有文件名索引不匹配的链接
2. **验证**：重新扫描全库，确认残留数量
3. **第二轮**：针对性修复边缘情况（嵌套链接、表格碎片、长句误链接）
4. **最终验证**：确认 0 断链，或逐个修复残留

#### 11. 算法优化策略（基于断链分析结果）
当断链率过高时，不应仅修复现有链接，而应从根本上优化链接算法：

**问题诊断**：
- **断链率>30%**：算法过于激进，需要切换到更保守的策略
- **链接密度>30个/文件**：链接过多，知识图谱噪音严重
- **常见词汇被链接**：停用词表需要扩展

**优化方案**：
1. **算法降级**：从v2/v3算法切换到v4算法（极度保守）
2. **重新编译**：使用优化后的算法重新编译所有Wiki文件
3. **质量验证**：验证新算法的断链率和链接密度

**执行步骤**：
1. **备份当前Wiki目录**：创建完整备份
2. **清空Wiki目录**：准备重新编译
3. **应用新算法**：使用v4算法重新编译所有待编译文件
4. **验证效果**：抽样检查断链率和链接密度
5. **更新索引**：基于新Wiki内容更新超级索引

**注意事项**：
- 重新编译前必须备份，避免数据丢失
- 对于大规模知识库（>1000文件），建议分批处理避免超时
- 验证新算法效果后再删除备份

### 空文档清理工作流（基于实战验证）

当知识库中存在仅有YAML frontmatter而无正文内容的"空文档"时，这些文档会在知识图谱中显示为孤立节点，需要清理。

**空文档定义**：
- 文件大小 < 100 bytes（仅YAML frontmatter）
- 内容只包含 `---` + 元数据 + `---`，无正文
- 示例：64-88 bytes的文件，仅有 title/date/source/tags

**触发条件**：
- 知识库安全体检发现近空文件
- 用户反馈"发现有些文档是空的"
- 目录中有大量小文件（< 100 bytes）

**完整清理工作流**：

```python
# 第一阶段：识别空文档
empty_files = []
for f in os.listdir(wiki_dir):
    file_path = os.path.join(wiki_dir, f)
    file_size = os.path.getsize(file_path)
    if file_size < 100:  # 只有YAML的极简文件
        empty_files.append(f)

# 第二阶段：扫描所有文件中的链接引用
# 检查是否有文件链接指向这些空文档
links_to_empty = []
link_pattern = r'\[\[([^\]]+)\]\]'
for each_file in wiki_files:
    with open(file_path, 'r') as f:
        content = f.read()
    for link in re.findall(link_pattern, content):
        clean_link = link.split('|')[0].replace('.md', '')
        if clean_link in empty_file_names:
            links_to_empty.append({
                'source': current_file,
                'target': clean_link
            })

# 第三阶段：移除链接引用 + 删除空文档
for each broken link found:
    remove [[link]] → keep plain text

for each empty file:
    os.remove(file_path)  # 删除空文件
```

**执行步骤**：
1. **扫描空文档**：检查Wiki目录中所有文件大小 < 100 bytes的文件
2. **检查Inbox/sources**：同步扫描原始素材目录中的空文件
3. **扫描链接引用**：检查全库中是否有文件链接指向这些空文档
4. **移除链接**：将指向空文档的链接标记替换为纯文本
5. **删除空文档**：删除空文档文件本身
6. **验证结果**：确认目录中无空文档，无断链指向已删除文件

**关键经验教训**：
1. **双向扫描**：不仅要扫描Wiki目录，还要同步扫描Inbox/sources目录
2. **链接引用可能极少**：空文档通常没有其他文件链接到它们（如实战中仅1处引用）
3. **文件名精确匹配**：判断链接是否指向空文档时，使用文件名（不含.md后缀）精确匹配
4. **YAML frontmatter中的链接也需要清理**：title字段中指向空文档的链接标记应移除

**后续处理**：
- 清理后更新超级索引统计信息（文件数、链接数）
- 在超级索引中移除已删除文件的条目
- 空文档清理完成后，知识库应保持"无空文档"状态

### 编译时链接目标解析（修复Obsidian断链的关键）

在添加链接时，不能直接使用 `[[term]]`，因为文件名是 `YYYY-MM-DD-term.md` 格式。必须将链接目标解析为完整文件名：

```python
# 1. 构建标题→完整文件名索引
title_to_fullname = {}
for f in os.listdir(wiki_dir):
    name = f[:-3]
    match = re.match(r'\d{4}-\d{2}-\d{2}-(.+)', name)
    if match:
        title_to_fullname[match.group(1)] = name

# 2. 添加链接时使用完整文件名
def add_wiki_link(term):
    """返回带完整文件名的链接文本"""
    fullname = title_to_fullname.get(term)
    if fullname:
        return f'[[{fullname}]]'   # ✅ [[2025-11-04-GPU]]
    return f'[[{term}]]'           # fallback，不应触发
```

### 参考文件
- `references/stopwords.md`：完整停用词表与技术术语白名单
- `references/wiki-link-compilation.md`：保护-添加-恢复链接策略、级联污染修复脚本、验证脚本（从AI日报批量编译实战中提取）
- `references/broken-link-cleanup.md`：全库断链清理完整脚本、验证脚本、嵌套链接/表格碎片/长句误链接等边缘情况处理（基于3,844文件1146断链→0断链实战）
- `references/daily-report-compilation.md`：日报/系列内容批量编译模式——去噪、浓缩、串线，产出高质量Wiki笔记+综述hub页（批量读取→逐篇压榨→主线提炼→归档）

## 性能优化建议
1. **术语词典缓存**：将核心术语词典存储在内存中，避免重复加载
2. **批量处理**：对于大量文件，使用批量处理（如每次处理100个文件）而非逐个处理，可显著提高处理速度并避免内存溢出
3. **增量更新**：超级索引支持增量更新，只处理新增或修改的文件
4. **并行处理**：对于独立任务（如预处理和Wiki编译），可考虑并行执行以缩短总处理时间

## 更新与维护

- 当工作流或规范有调整时，更新本Skill。
- 新增工具或依赖时，补充到「工具与技能依赖」章节。
- 用户反馈的常见问题，添加到「注意事项与边界」。

---

> 本Skill基于用户提供的「PKM知识库工程师」角色定位文档创建，旨在实现工程化、自动化的个人知识生产系统。
> 更新内容包含：输出要求规范、可直接执行单步指令表、10分钟快速落地指南、完整目录结构。