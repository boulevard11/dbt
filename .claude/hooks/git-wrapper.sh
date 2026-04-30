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

 # 現在のブランチがfeature+任意の文字列であることを確認
  if ! echo "$CURRENT" | grep -qE "^feature.+"; then
    echo "ERROR: 現在のブランチが feature で始まっていません。"
    echo "       現在のブランチ: $CURRENT"
    echo "       featureブランチに切り替えてから作業してください。"
    exit 1
  fi

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