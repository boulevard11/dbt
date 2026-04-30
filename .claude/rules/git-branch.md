## ブランチ作成手順

1. ファイルを変更する前に、現在のブランチが `feature` で始まっていることを確認し、
   必ず以下のコマンドでブランチを作成すること：
   ```
   bash .claude/hooks/git-wrapper.sh checkout -b <ブランチ名>
   ```

2. ファイル変更後、以下のコマンドでコミットすること：
   ```
   bash .claude/hooks/git-wrapper.sh add <ファイル>
   bash .claude/hooks/git-wrapper.sh commit -m "<メッセージ>"
   bash .claude/hooks/git-wrapper.sh push origin <ブランチ名>
   ```

3. プッシュ後、以下のコマンドでプルリクエストを作成すること：
   ```
   gh pr create --base <現在のブランチ> --head <作成したブランチ> --title "<タイトル>" --body "<説明>"
   ```

## ブランチ命名規則

以下のパターンでブランチ名を指定すること：
```
<現在のブランチ>-claude-<作業内容>
```