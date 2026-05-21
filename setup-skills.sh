#!/bin/bash
# ============================================
# WorkBuddy/Hermes Skills 一键同步脚本
# 用法: bash setup-skills.sh [--mode merge|replace]
#
# merge  (默认): 叠加模式，git skills 合并到现有目录，内置 skills 保留
# replace:       完全替换（旧模式，内置 skills 会失效）
# ============================================
set -e

MODE="${1:---mode merge}"
MODE="${MODE#--mode }"
[[ "$MODE" != "replace" ]] && MODE="merge"

REPO_URL="https://github.com/KUN8964/workbuddy-skills.git"
REPO_DIR="$HOME/workbuddy-skills"
AGENTS_DIR="$HOME/.agents/skills"

HERMES_SKILLS="$HOME/.hermes/skills"
WB_SKILLS="$HOME/.workbuddy/skills"

echo "=== Skills 同步脚本 [模式: $MODE] ==="
echo ""

# ============================================
# 1. 克隆/更新仓库
# ============================================
if [ -d "$REPO_DIR/.git" ]; then
  echo "[1/5] 更新仓库..."
  cd "$REPO_DIR" && git pull
else
  echo "[1/5] 克隆仓库..."
  git clone "$REPO_URL" "$REPO_DIR"
fi

# ============================================
# 2. WorkBuddy skills → symlink（WorkBuddy 无内置 skills，直接链）
# ============================================
if [ -d "$HOME/.workbuddy" ]; then
  echo "[2/5] 设置 WorkBuddy skills..."
  if [ -d "$WB_SKILLS" ] && [ ! -L "$WB_SKILLS" ]; then
    mv "$WB_SKILLS" "$WB_SKILLS.bak.$(date +%Y%m%d)"
    echo "  → 旧目录已备份到 $WB_SKILLS.bak.$(date +%Y%m%d)"
  fi
  rm -f "$WB_SKILLS"
  ln -s "$REPO_DIR" "$WB_SKILLS"
  echo "  ✓ WorkBuddy skills → $REPO_DIR"
else
  echo "[2/5] WorkBuddy 未安装，跳过"
fi

# ============================================
# 3. Hermes skills → 根据模式处理
# ============================================
if [ -d "$HOME/.hermes" ]; then
  echo "[3/5] 设置 Hermes skills [模式: $MODE]..."

  if [ "$MODE" = "replace" ]; then
    # ---- replace 模式（旧行为，会丢失内置 skills）----
    if [ -d "$HERMES_SKILLS" ] && [ ! -L "$HERMES_SKILLS" ]; then
      mv "$HERMES_SKILLS" "$HERMES_SKILLS.bak.$(date +%Y%m%d)"
      echo "  → 旧目录已备份"
    fi
    rm -f "$HERMES_SKILLS"
    ln -s "$REPO_DIR" "$HERMES_SKILLS"
    echo "  ✓ Hermes skills → $REPO_DIR"
    echo "  ⚠️ 警告: 内置 skills 已失效，仅加载仓库内容"

  else
    # ---- merge 模式（默认，叠加）----
    # 确保 Hermes skills 是真实目录，不是 symlink
    if [ -L "$HERMES_SKILLS" ]; then
      echo "  ⚠️ 检测到 ~/.hermes/skills 是 symlink，先恢复..."
      # 如果有备份，恢复备份
      LATEST_BACKUP=$(ls -dt "$HERMES_SKILLS.bak."* 2>/dev/null | head -1)
      if [ -n "$LATEST_BACKUP" ]; then
        rm -f "$HERMES_SKILLS"
        cp -a "$LATEST_BACKUP" "$HERMES_SKILLS"
        echo "  ✓ 已从备份恢复内置 skills: $LATEST_BACKUP"
      else
        echo "  ❌ 无备份可恢复！请先手动恢复 ~/.hermes/skills/"
        echo "     或运行: rm -f ~/.hermes/skills && mkdir -p ~/.hermes/skills"
        exit 1
      fi
    fi

    # 确保目录存在
    mkdir -p "$HERMES_SKILLS"

    # 叠加合并：把仓库里的 skills 复制/链接到 Hermes 目录
    MERGED=0
    SKIPPED=0
    for skill_path in "$REPO_DIR"/*; do
      [ -e "$skill_path" ] || continue
      skill_name=$(basename "$skill_path")

      # 跳过特殊文件
      [[ "$skill_name" == .* ]] && continue
      [[ "$skill_name" == "scripts" ]] && continue
      [[ "$skill_name" == "README.md" ]] && continue
      [[ "$skill_name" == "setup-skills.sh" ]] && continue
      [[ "$skill_name" == ".gitignore" ]] && continue

      target="$HERMES_SKILLS/$skill_name"

      if [ -e "$target" ]; then
        # 已存在，跳过（保护内置 skills 和已安装的）
        SKIPPED=$((SKIPPED + 1))
      else
        if [ -L "$skill_path" ]; then
          # symlink skill → 复制 symlink（相对路径）
          cp -a "$skill_path" "$target"
        else
          # 普通目录 → 建 symlink 节省空间，或复制
          ln -s "$skill_path" "$target"
        fi
        MERGED=$((MERGED + 1))
      fi
    done

    echo "  ✓ 叠加完成: 新增 $MERGED 个 skill, 跳过 $SKIPPED 个（已存在）"
    echo "  📦 内置 skills 保留，git skills 已合并"
  fi
else
  echo "[3/5] Hermes 未安装，跳过"
fi

# ============================================
# 4. .agents/skills (共享 skills)
# ============================================
echo "[4/5] 检查共享 skills..."
if [ -d "$AGENTS_DIR" ]; then
  echo "  ✓ ~/.agents/skills/ 已存在"
else
  echo "  ⚠ ~/.agents/skills/ 不存在"
  echo "    以下 symlink skills 需要它:"
  echo "    agent-skill-creator brandkit design-taste-frontend"
  echo "    full-output-enforcement high-end-visual-design image-to-code"
  echo "    imagegen-frontend-mobile imagegen-frontend-web"
  echo "    industrial-brutalist-ui minimalist-ui"
  echo "    redesign-existing-projects stitch-design-taste"
  echo ""
  echo "    修复命令: git clone https://github.com/KUN8964/agents-skills.git ~/.agents/skills"
fi

# ============================================
# 5. 安装 pre-commit hook（自动更新分类表格）
# ============================================
echo "[5/5] 安装 pre-commit hook..."
HOOK_SRC="$REPO_DIR/scripts/pre-commit-hook.sh"
HOOK_DST="$REPO_DIR/.git/hooks/pre-commit"
if [ -f "$HOOK_SRC" ]; then
  cp "$HOOK_SRC" "$HOOK_DST"
  chmod +x "$HOOK_DST"
  echo "  ✓ pre-commit hook 已安装"
else
  echo "  ⚠ hook 脚本未找到，跳过"
fi

# ============================================
# 6. 安装自动更新服务（可选）
# ============================================
echo ""
echo "=== 自动更新 ==="
AUTO_UPDATE_SCRIPT="$REPO_DIR/scripts/skills-auto-update.sh"
LAUNCHD_PLIST="$HOME/Library/LaunchAgents/com.kun.workbuddy-skills-auto-update.plist"

if [ -f "$AUTO_UPDATE_SCRIPT" ]; then
  if [ -f "$LAUNCHD_PLIST" ]; then
    echo "  ✓ 自动更新服务已配置（开机启动）"
  else
    echo "  💡 提示: 运行以下命令启用开机自动更新:"
    echo "     bash $AUTO_UPDATE_SCRIPT --install-launchd"
  fi
else
  echo "  ⚠ 自动更新脚本未找到"
fi

echo ""
echo "=== 完成! ==="
echo "模式:      $MODE"
echo "WorkBuddy: ls ~/.workbuddy/skills/"
echo "Hermes:    ls ~/.hermes/skills/"
echo "更新:      cd ~/workbuddy-skills && git pull"
echo ""
echo "📊 每次 commit 自动更新 README 分类表格"
