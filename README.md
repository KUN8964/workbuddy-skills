# WorkBuddy Skills

> `~/.workbuddy/skills/` 和 `~/.hermes/skills/` 的统一版本控制仓库。
> 多设备同步只需 `git pull`。

## 新设备一键初始化

```bash
# 方式一：一键脚本（推荐）
bash <(curl -s https://raw.githubusercontent.com/KUN8964/workbuddy-skills/main/setup-skills.sh)

# 方式二：手动克隆
git clone https://github.com/KUN8964/workbuddy-skills.git ~/workbuddy-skills
ln -s ~/workbuddy-skills ~/.workbuddy/skills   # WorkBuddy
ln -s ~/workbuddy-skills ~/.hermes/skills      # Hermes
```

> 脚本自动检测 WorkBuddy 和 Hermes 是否已安装，分别设软链接。
> 旧 skills 目录会自动备份（加时间戳后缀），放心跑。

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
cd ~/workbuddy-skills

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
