#!/bin/bash
# ============================================
# Skills 自动更新脚本
# 用法:
#   bash skills-auto-update.sh              # 检查并更新
#   bash skills-auto-update.sh --install-launchd   # 安装开机启动
#   bash skills-auto-update.sh --uninstall-launchd # 卸载开机启动
# ============================================
set -e

REPO_DIR="$HOME/skill-hub"
REPO_URL="https://github.com/KUN8964/skill-hub.git"
HERMES_SKILLS="$HOME/.hermes/skills"
WB_SKILLS="$HOME/.workbuddy/skills"
LOG_FILE="$HOME/.workbuddy/skills-update.log"
LAUNCHD_PLIST="$HOME/Library/LaunchAgents/com.kun.skill-hub-auto-update.plist"

# 确保日志目录存在
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ============================================
# 安装 launchd 开机启动（macOS）
# ============================================
install_launchd() {
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$LAUNCHD_PLIST" << 'PLIST_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.kun.skill-hub-auto-update</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>HOME/skill-hub/scripts/skills-auto-update.sh</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>86400</integer>
  <key>StandardOutPath</key>
  <string>HOME/.workbuddy/skills-update.log</string>
  <key>StandardErrorPath</key>
  <string>HOME/.workbuddy/skills-update.log</string>
</dict>
</plist>
PLIST_EOF

  # 替换 HOME 占位符为实际路径
  sed -i '' "s|HOME/|$HOME/|g" "$LAUNCHD_PLIST"

  launchctl load "$LAUNCHD_PLIST" 2>/dev/null || true
  log "✓ launchd 开机启动已安装: $LAUNCHD_PLIST"
  log "  每小时检查一次 + 开机时自动运行"
}

# ============================================
# 卸载 launchd
# ============================================
uninstall_launchd() {
  if [ -f "$LAUNCHD_PLIST" ]; then
    launchctl unload "$LAUNCHD_PLIST" 2>/dev/null || true
    rm -f "$LAUNCHD_PLIST"
    log "✓ launchd 开机启动已卸载"
  else
    log "⚠ launchd 未安装"
  fi
}

# ============================================
# 检查更新
# ============================================
check_and_update() {
  log "=== Skills 自动更新检查 ==="

  # 确保仓库存在
  if [ ! -d "$REPO_DIR/.git" ]; then
    log "仓库不存在，正在克隆..."
    git clone "$REPO_URL" "$REPO_DIR"
  fi

  cd "$REPO_DIR"

  # 获取远程最新 commit hash
  git fetch origin main --quiet
  LOCAL_HASH=$(git rev-parse HEAD)
  REMOTE_HASH=$(git rev-parse origin/main)

  if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
    log "✓ 已是最新版本 ($LOCAL_HASH)"
    return 0
  fi

  log "📦 发现更新!"
  log "   本地: $LOCAL_HASH"
  log "   远程: $REMOTE_HASH"

  # 执行更新
  git pull origin main
  log "✓ git pull 完成"

  # 重新叠加到 Hermes
  if [ -d "$HERMES_SKILLS" ] && [ ! -L "$HERMES_SKILLS" ]; then
    log "🔄 重新合并到 Hermes..."
    MERGED=0
    SKIPPED=0
    for skill_path in "$REPO_DIR"/*; do
      [ -e "$skill_path" ] || continue
      skill_name=$(basename "$skill_path")

      [[ "$skill_name" == .* ]] && continue
      [[ "$skill_name" == "scripts" ]] && continue
      [[ "$skill_name" == "README.md" ]] && continue
      [[ "$skill_name" == "setup-skills.sh" ]] && continue
      [[ "$skill_name" == ".gitignore" ]] && continue

      target="$HERMES_SKILLS/$skill_name"

      if [ -e "$target" ]; then
        # 已存在，检查是否需要更新（如果是 symlink 且指向仓库则更新）
        if [ -L "$target" ]; then
          link_target=$(readlink "$target")
          if [[ "$link_target" == "$REPO_DIR"* ]]; then
            # 已是指向仓库的 symlink，无需改动
            :
          else
            # 指向其他位置，不覆盖
            SKIPPED=$((SKIPPED + 1))
          fi
        else
          # 真实目录，不覆盖（保护内置 skills）
          SKIPPED=$((SKIPPED + 1))
        fi
      else
        if [ -L "$skill_path" ]; then
          cp -a "$skill_path" "$target"
        else
          ln -s "$skill_path" "$target"
        fi
        MERGED=$((MERGED + 1))
        log "   + $skill_name"
      fi
    done
    log "✓ Hermes 合并完成: 新增 $MERGED, 跳过 $SKIPPED"
  fi

  # WorkBuddy 是 symlink，不需要重新合并
  if [ -L "$WB_SKILLS" ]; then
    log "✓ WorkBuddy symlink 正常"
  fi

  log "=== 更新完成 ==="
}

# ============================================
# 主入口
# ============================================
case "${1:-}" in
  --install-launchd)
    install_launchd
    ;;
  --uninstall-launchd)
    uninstall_launchd
    ;;
  "")
    check_and_update
    ;;
  *)
    echo "用法: $0 [--install-launchd|--uninstall-launchd]"
    exit 1
    ;;
esac
