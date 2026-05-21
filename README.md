# WorkBuddy Skills

> `~/.workbuddy/skills/` 的版本控制仓库，多设备同步只需 pull 最新。

## 新设备初始化

```bash
# 1. 克隆到 skills 目录（如果已有旧目录先备份）
mv ~/.workbuddy/skills ~/.workbuddy/skills.bak
git clone https://github.com/KUN8964/workbuddy-skills.git ~/.workbuddy/skills

# 2. 修复 symlink（如果 ~/.agents/skills/ 尚未设置）
#    以下 12 个 skills 是 symlink → ~/.agents/skills/
#    如果没有 ~/.agents/skills/，这些链接会断开
ls -la ~/.workbuddy/skills/ | grep "^l"
```

## 日常使用

```bash
cd ~/.workbuddy/skills

# 拉取最新
git pull

# 新增/修改 skill 后提交
git add .
git commit -m "描述做了什么"
git push
```

## 目录结构

- 独立目录：28 个 skills，完全自包含
- symlink：12 个 skills，指向 `~/.agents/skills/`（共享 skill）
- `.gitignore`：排除 .zip、临时文件
