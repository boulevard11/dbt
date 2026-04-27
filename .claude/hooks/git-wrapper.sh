#!/bin/bash
# git-wrapper.sh: git操作の唯一の入口
# 責務: checkout -b 時のブランチ名検証のみ
GIT=/usr/bin/git
SUBCOMMAND="${1:-}"
# ------------------------------------------------
# checkout -b のみインターセプト
# ------------------------------------------------
if [ "$SUBCOMMAND" = "checkout" ] && [ "$2" = "-b" ]; then
  BRANCH="${3:-}"
  # 現在のブランチを取得
  CURRENT=$($GIT rev-parse --abbrev-ref HEAD)
  # ブランチ名チェック: <現在のブランチ>/claude-<任意文字列> または claude/<現在のブランチ>-<任意文字列> の形式か
  VALID_PATTERN1="^${CURRENT}/claude-.+"
  VALID_PATTERN2="^claude/${CURRENT}-.+"
  if ! echo "$BRANCH" | grep -qE "$VALID_PATTERN1" && ! echo "$BRANCH" | grep -qE "$VALID_PATTERN2"; then
    echo "ERROR: ブランチ名が命名規則に違反しています。"
    echo "       許可パターン: ${CURRENT}/claude-<作業内容> または claude/${CURRENT}-<作業内容>"
    echo "       指定された名前: $BRANCH"
    exit 1
  fi
  echo "OK: '$CURRENT' → '$BRANCH' を作成します。"
  exec $GIT checkout -b "$BRANCH" "$CURRENT"
fi
# ------------------------------------------------
# checkout -b 以外はそのまま委譲
# ------------------------------------------------
exec $GIT "$@"