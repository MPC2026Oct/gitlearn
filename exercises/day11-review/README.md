# 11日目の演習：コードレビュー

説明ページ：[11日目：コードレビュー](../../docs/day11-code-review.md)

## 目的

担当ページを書いて PR を出し、組の相手の PR をレビューし、指摘に対応してマージします。

## 所要時間の目安

60分

## 担当ページ

チームリポジトリの `exercises/team-project/pages/`（以下 `pages/`）の中の、自分の役割のファイルを書きます。

| 役割 | 担当ページ | 内容 |
|---|---|---|
| A | `pages/activities.md` | 活動紹介 |
| B | `pages/events.md` | 年間行事 |
| C | `pages/faq.md` | よくある質問 |
| D | `pages/newcomers.md` | 新入生へのメッセージ・入会方法（3人チームは13日目に全員で作るので、今日はなし） |

3人チームの役割 D はありません。13日目の Issue で `newcomers.md` を作ります。

## 手順

> [!NOTE]
> `<...>` の部分は、かっこごと置き換えてから実行します。サークルは架空の設定でも構いません。個人情報は書きません。

### パート1：担当ページを書いて PR を出す

1. 今日の進行役（C）が作った、自分の担当ページの Issue の番号を確認します（例：`#12`）。自分では作りません（二重にならないように）。
2. `main` を最新にして、ブランチを作ります。

   ```bash
   cd ~/git-practice/gitlearn-team-<チーム記号>
   git switch main
   git pull
   git switch -c <GitHubユーザー名>/write-page
   ```

3. 担当ページの「TODO」の部分を書き、プレビュー（`Ctrl+Shift+V`）で表示を確認します。
4. コミット → `push` → PR 作成（`Closes #<Issue番号>` を入れ、レビュアーに組の相手を指定）をします。

### パート2：レビューする

1. 組の相手の PR を開き、**Files changed** を読みます。
2. [review-checklist.md](review-checklist.md) を見ながら、**最低1つ**、行コメントか修正提案（Suggested changes）を付けます。
3. レビューの結果として、**Comment**・**Request changes**・**Approve** から選んで送信します。まず1コメント付けて **Request changes** か **Comment**、直ったら **Approve** がおすすめです。

### パート3：指摘に対応する

1. 自分の PR についたコメントを読みます。
2. 手元のブランチで修正し、コミットして `push` します（同じブランチなので PR が自動で更新されます）。
3. 修正提案（Suggested changes）がついた場合は、**Commit suggestion** で取り込めます。取り込んだあとは、手元で `git pull` が必要です。
4. 対応したら返信して、**Re-request review**（再レビューを依頼）を押します。
5. Approve されたら、作成者が **Merge pull request** でマージし、ブランチを削除します。
6. 手元を最新にします。

   ```bash
   git switch main
   git pull
   git branch -d <GitHubユーザー名>/write-page
   ```

## 完了条件

- [ ] 自分の担当ページに、TODO が残らない程度の内容が書かれている
- [ ] 自分の PR が **Merged** になった
- [ ] 組の相手の PR に、行コメントか修正提案を最低1つ付けた
- [ ] 自分の PR についた指摘に、修正または返信で対応した
- [ ] 手元で `git switch main` → `git pull` を行い、作業ブランチを削除した

## ヒント

- コメントは「人」ではなく「変更」に向けて書きます。「ここを〜にすると読みやすいです」のように具体的に。
- 良いところも1つ書きましょう。
- 他のメンバーの PR が先にマージされても、別のファイルなのでコンフリクトは起きません。
- 他の人のブランチを手元で確かめたいとき（任意）は、`git fetch` → `git switch <ブランチ名>` を使います。
