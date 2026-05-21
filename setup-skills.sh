#!/bin/bash
# ============================================
# WorkBuddy/Hermes Skills 一键同步脚本
# 用法: bash setup-skills.sh
# ============================================
set -e

REPO_URL="https://github.com/KUN8964/workbuddy-skills.git"
REPO_DIR="$HOME/workbuddy-skills"
AGENTS_DIR="$HOME/.agents/skills"

echo "=== Skills 一键同步 ==="
echo ""

# 1. 克隆/更新仓库
if [ -d "$REPO_DIR/.git" ]; then
  echo "[1/4] 更新仓库..."
  cd "$REPO_DIR" && git pull
else
  echo "[1/4] 克隆仓库..."
  git clone "$REPO_URL" "$REPO_DIR"
fi

# 2. WorkBuddy skills
if [ -d "$HOME/.workbuddy" ]; then
  echo "[2/4] 设置 WorkBuddy skills..."
  if [ -d "$HOME/.workbuddy/skills" ] && [ ! -L "$HOME/.workbuddy/skills" ]; then
    mv "$HOME/.workbuddy/skills" "$HOME/.workbuddy/skills.bak.$(date +%Y%m%d)"
    echo "  → 旧目录已备份"
  fi
  rm -f "$HOME/.workbuddy/skills"
  ln -s "$REPO_DIR" "$HOME/.workbuddy/skills"
  echo "  ✓ WorkBuddy skills → $REPO_DIR"
else
  echo "[2/4] WorkBuddy 未安装，跳过"
fi

# 3. Hermes skills
if [ -d "$HOME/.hermes" ]; then
  echo "[3/4] 设置 Hermes skills..."
  if [ -d "$HOME/.hermes/skills" ] && [ ! -L "$HOME/.hermes/skills" ]; then
    mv "$HOME/.hermes/skills" "$HOME/.hermes/skills.bak.$(date +%Y%m%d)"
    echo "  → 旧目录已备份"
  fi
  rm -f "$HOME/.hermes/skills"
  ln -s "$REPO_DIR" "$HOME/.hermes/skills"
  echo "  ✓ Hermes skills → $REPO_DIR"
else
  echo "[3/4] Hermes 未安装，跳过"
fi

# 4. .agents/skills (共享 skills)
echo "[4/4] 检查共享 skills..."
if [ -d "$AGENTS_DIR" ]; then
  echo "  ✓ ~/.agents/skills/ 已存在"
else
  echo "  ⚠ ~/.agents/skills/ 不存在"
  echo "    以下 12 个 symlink 会断开:"
  echo "    agent-skill-creator brandkit design-taste-frontend"
  echo "    full-output-enforcement high-end-visual-design image-to-code"
  echo "    imagegen-frontend-mobile imagegen-frontend-web"
  echo "    industrial-brutalist-ui minimalist-ui"
  echo "    redesign-existing-projects stitch-design-taste"
  echo ""
  echo "    如需修复: 将 .agents/skills/ 也做版本控制"
fi

echo ""
echo "=== 完成! ==="
echo "WorkBuddy: ls ~/.workbuddy/skills/"
echo "Hermes:    ls ~/.hermes/skills/"
echo "更新:      cd ~/workbuddy-skills && git pull"
