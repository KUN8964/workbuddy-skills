#!/usr/bin/env bash
# ============================================
# pre-commit hook: 自动更新 skills 分类表格
# ============================================
set -e

SKILLS_DIR="$(git rev-parse --show-toplevel)"
SCRIPT="$SKILLS_DIR/scripts/generate-table.py"

# 检查是否有 SKILL.md 变更
CHANGED=$(git diff --cached --name-only --diff-filter=ACM | grep -E "(SKILL\.md|\.gitignore|setup-skills\.sh|scripts/generate-table)" || true)

if [ -z "$CHANGED" ]; then
    exit 0  # 没有 skill 变更，跳过
fi

echo "🔍 检测到 skill 变更，自动更新分类表格..."

if python3 "$SCRIPT"; then
    # 将更新的 README.md 加入本次提交
    git add "$SKILLS_DIR/README.md"
    echo "✅ 表格已更新并加入提交"
else
    echo "⚠️  表格生成失败，提交继续"
fi
