# Wiki链接算法停用词表与技术术语白名单

## 概述
本文件包含优化Wiki链接算法所需的停用词表和技术术语白名单，用于在Wiki结构化编译阶段智能识别核心专业名词，避免为常见单词添加无效链接。

## 英文停用词表
以下英文单词不应被添加为Wiki链接（常见停用词、普通单词）：

### 冠词、连词、介词
a, an, the, and, or, but, if, then, else, when, at, by, for, from, in, into, of, on, to, with, as

### 助动词、系动词
is, was, are, were, be, been, being, have, has, had, having, do, does, did, doing

### 情态动词
can, could, may, might, must, shall, should, will, would

### 代词
i, me, my, myself, we, us, our, ours, ourselves, you, your, yours, yourself, yourselves, he, him, his, himself, she, her, hers, herself, it, its, it's, they, them, their, theirs, themselves

### 指示词、疑问词
this, that, these, those, what, which, who, whom, whose, how, why, where, when, there, here

### 数量词、限定词
all, any, both, each, few, more, most, other, some, such, no, nor, not, only, own, same, so, than, too, very

### 缩写形式
don, don't, doesn, doesn't, didn, didn't, couldn, couldn't, shouldn, shouldn't, won, won't, wouldn, wouldn't

### 常见普通单词（技术语境中非术语）
use, using, used, uses, user, data, file, files, system, systems, model, models, function, functions, method, methods, class, classes, object, objects, value, values, type, types, key, keys, code, codes, time, times, way, ways, part, parts, number, numbers, work, works, word, words, case, cases, point, points, example, examples, state, states, thing, things

### 单个字母（常被误识别）
re, ce, se, de, le, ne, te, ve, we, xe, ye, ze

## 中文停用词表
以下中文词语不应被添加为Wiki链接（常见虚词、普通名词）：

### 结构助词、语气助词
的, 了, 在, 是, 有, 和, 与, 或, 但, 而, 且

### 连词
如果, 那么, 因为, 所以, 虽然, 但是, 然而, 因此

### 举例词
例如, 比如, 譬如, 诸如, 等等, 即, 也就是, 换句话说

### 量词、指示词
一个, 一种, 一些, 这个, 那个, 这些, 那些, 什么, 怎么, 为什么, 如何

### 能愿动词
可以, 可能, 需要, 应该, 必须, 不能

### 程度副词
非常, 很, 太, 更, 最, 比较, 相对, 绝对, 一般

### 时间副词
通常, 经常, 偶尔, 总是, 从不, 已经, 正在, 将要

### 常见普通名词（非专业术语）
结构, 方式, 方法, 过程, 结果, 原因, 问题, 解决, 应用, 使用, 实现, 进行, 通过, 基于, 对于, 关于, 这种, 那种, 某种, 每个, 各种, 不同, 相同, 重要, 主要, 必要, 可能, 可以, 能够, 需要, 应该

### 实战补充停用词（经952个文件编译验证）
以下词汇在真实知识库中频繁出现但非技术术语，链接后产生大量噪音，应加入停用词表：
所有, 笔记, 存储, 文件, 信息, 内容, 数据, 系统, 操作, 处理, 管理, 支持, 功能, 部分, 分为, 没有, 具有, 作为, 同时, 其中, 之间, 之后, 之前, 以上, 以下, 相关, 对应, 第一, 第二, 最后, 来说

## 技术术语白名单
以下技术术语即使可能被停用词规则过滤，也应强制保留为Wiki链接：

### AI/ML领域
RLHF, SFT, PPO, GPT, CNN, RNN, LSTM, GRU, GAN, VAE, MSE, ReLU, Sigmoid, Tanh, Dropout, L1, L2, Lasso, Ridge, Transformer, BERT, GPT-3, GPT-4, Claude, Gemini, Llama, Mistral

### 编程/开发
API, JSON, HTML, CSS, JS, SQL, NoSQL, HTTP, HTTPS, TCP, IP, DNS, CDN, JWT, OAuth, RBAC, XSS, CSRF, AWS, GPU, CPU, RAM, ROM, IO, UI, UX, CI, CD

### 工具/框架
Python, Java, React, Vue, Node, npm, pnpm, Git, Docker, Kubernetes, Linux, MySQL, Redis, MongoDB, PostgreSQL, Figma, Obsidian, Marp

### 其他专有名词
Hopfield, Boltzmann, Cross-Entropy, Scaling Law, Taalas, Palantir, LangSmith, Semantic Kernel, Clawdbot

## 术语识别规则
1. **长度过滤**：术语长度至少为2个字符（中文单字除外）
2. **数字过滤**：纯数字不添加链接
3. **字符类型**：\n   - 包含中文的术语限制为2-4个字符的核心概念词汇\n   - 不包含中文的英文术语需满足以下至少一条：\n     a) 全大写（如API、CLI、GPT）\n     b) 包含数字或下划线/连字符（如GPT-3、L2、--files）\n     c) 首字母大写专有名词（如Python、Codex、Obsidian）\n     d) **不链接小写英文普通单词**（如 running、coding、computer）\n4. **排除纯标点符号**：不含任何字母或中文字符的术语（如---、--）不添加链接
4. **停用词检查**：不在英文停用词表和中文停用词表中
5. **白名单检查**：在白名单中的术语强制保留

## 算法实现要点（v2 — 经实战验证，修复过度链接问题）

> **注意：** 早期版本的元音检查法（vowel check）对长度≥6的英文单词无效（如 "running"、"terminal"），会导致大量常见英文词汇被误链接。以下为改进版。

```python
def should_link_term(term):
    # 基础检查
    if len(term) < 2 or term.isdigit():
        return False
    if len(term) == 1 and not '\u4e00' <= term <= '\u9fff':
        return False
    
    # 排除纯标点符号（如 ---、-- 等不含字母的术语）
    has_letter_or_chinese = any(
        c.isalpha() or ('\u4e00' <= c <= '\u9fff') for c in term
    )
    if not has_letter_or_chinese:
        return False
    
    # 白名单检查
    if term in TECH_WHITELIST:
        return True
    
    # 停用词检查
    if term.lower() in STOP_WORDS_EN or term in STOP_WORDS_ZH:
        return False
    
    # 字符类型分析
    has_chinese = any('\u4e00' <= char <= '\u9fff' for char in term)
    
    if not has_chinese:
        # 英文术语：只链接全大写、含数字/连字符、或首字母大写
        if term.isupper():
            return True
        if any(c.isdigit() or c in '_-' for c in term):
            return True
        if term[0].isupper():
            return True
        return False
    else:
        # 中文术语：限制2-4个字符的核心概念
        if 2 <= len(term) <= 4:
            return True
        return False
```

### 批量编译与交叉链接工作流（实战验证）
当需要一次性补充多个相关词条（如"补齐 LLM 知识体系的 N 个核心概念"）：

**批量编译阶段**：
1. 使用 `execute_code` 中的 `for` 循环 + `write_file` 一次性编译所有词条
2. 每个词条在编译时预先写入 2-3 个最直接的交叉链接（指向同期编译的其他词条）
3. 命名统一：`YYYY-MM-DD-词条名.md`，YAML 元数据统一 `source: LLM知识补齐系列`
4. 每篇词条包含：核心定义、精华表格、关键技术对比、常见配置示例

**交叉链接扩展阶段**：
5. 编译完成后，逐个词条通过 `patch` 将参考链接从 2-3 个扩展到 6-8 个
6. 链接策略：环形引用（A→B, B→A）+ 跨主题桥接（Transformer→MoE, Agent→RAG）
7. 链接格式统一使用 `[[YYYY-MM-DD-完整文件名]]` 而非 `[[词条名]]`

**链接密度目标**：每个词条 5-8 个高质量链接，形成全连接知识网络而非孤岛

## 更新与维护
- 定期审查停用词表，根据实际误报情况调整
- 新增技术术语及时加入白名单
- 算法规则可根据知识库特点微调