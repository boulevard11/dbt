
#!/bin/bash
# git-wrapper.sh: git操作の唯一の入口
# 責務: checkout -b 時のブランチ名検証のみ

GIT=$(which git)
SUBCOMMAND="${1:-}"

# ------------------------------------------------
# checkout -b のみインターセプト
# ------------------------------------------------
if [ "$SUBCOMMAND" = "checkout" ] && [ "$2" = "-b" ]; then
  BRANCH="${3:-}"

  # 現在のブランチを取得
  CURRENT=$($GIT rev-parse --abbrev-ref HEAD)

  # ブランチ名チェック: <現在のブランチ>-claude-<任意文字列> の形式か
  VALID_PATTERN="^${CURRENT}-claude-.+"
  if ! echo "$BRANCH" | grep -qE "$VALID_PATTERN"; then
    echo "ERROR: ブランチ名が命名規則に違反しています。"
    echo "       許可パターン: ${CURRENT}-claude-<作業内容>"
    echo "       指定された名前: $BRANCH"
    exit 1
  fi

  echo "OK: '$CURRENT' -> '$BRANCH' を作成します。"
  $GIT checkout -b "$BRANCH" "$CURRENT"
  exit $?
fi

# ------------------------------------------------
# checkout -b 以外はそのまま委譲
# ------------------------------------------------
$GIT "$@"