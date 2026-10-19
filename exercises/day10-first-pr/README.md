# 10日目の演習：はじめてのプルリクエスト

説明ページ：[10日目：はじめてのプルリクエスト](../../docs/day10-pull-request.md)

## 目的

Issue → ブランチ → コミット → push → PR → レビュー → マージ → 後片付け、という開発の1周を体験します。

## 所要時間の目安

60分

## 準備

- 9日目で作った、自分の「メンバー紹介ページを追加」Issue の番号を確認します。
- 組の相手を確認します。自分の PR は「次の記号の人」がレビューします（4人：A→B、B→C、C→D、D→A／3人：A→B、B→C、C→A）。

> [!IMPORTANT]
> 今日は **各自が別のファイル** `members/<GitHubユーザー名>.md`（`exercises/team-project/members/` の下）を追加するだけです。`members/README.md`（一覧）は、今日は編集しません。

## 手順

> [!NOTE]
> `<...>` の部分は、かっこごと置き換えてから実行します。

1. `main` を最新にして、ブランチを作ります。

   ```bash
   cd ~/git-practice/gitlearn-team-<チーム記号>
   git switch main
   git pull
   git switch -c <GitHubユーザー名>/add-member-page
   ```

2. ひな形をコピーして、自分の紹介ページを作ります。

   ```bash
   cp exercises/team-project/members/_template.md exercises/team-project/members/<GitHubユーザー名>.md
   ```

   > [!NOTE]
   > チームリポジトリは教材のテンプレートから作られているため、ガイドブックのファイルは `exercises/team-project/` の下にあります。以降、`members/` は `exercises/team-project/members/` のことです。

3. VS Code で `exercises/team-project/members/<GitHubユーザー名>.md` を開き、「（ここを自分の内容に書き換える）」を書き換えます。個人情報は書きません。
4. コミットして push します。

   ```bash
   git add exercises/team-project/members/<GitHubユーザー名>.md
   git commit -m "メンバー紹介ページを追加"
   git push -u origin <GitHubユーザー名>/add-member-page
   ```

5. GitHub で **Compare & pull request** を選び、PR を作ります。PR テンプレートを埋め、本文に `Closes #<Issue番号>` を入れます。レビュアー（Reviewers）に組の相手を指定します。
6. 組の相手が、**Files changed** を見て **Approve** します。同時に、自分も組の相手の PR をレビューして Approve します。
7. Approve をもらったら、作者が **Merge pull request**（Create a merge commit）でマージし、**Delete branch** でブランチを削除します。
8. 手元を最新にして、後片付けをします。

   ```bash
   git switch main
   git pull
   git branch -d <GitHubユーザー名>/add-member-page
   ```

9. Issue が自動で閉じたことを確認します。

## 完了条件

- [ ] 自分の PR が **Merged** になり、本文に `Closes #<Issue番号>` が入っている
- [ ] 自分の「メンバー紹介ページを追加」Issue が自動で Closed になった
- [ ] 組の相手が自分の PR を Approve した（自分も相手の PR を Approve した）
- [ ] GitHub 上の `main` の `exercises/team-project/members/` に `<GitHubユーザー名>.md` がある
- [ ] 手元で `git switch main` → `git pull` を実行し、`git branch` に作業ブランチが残っていない

## ヒント

- `main` に直接 push しない約束です（チームのルール1）。`git branch` で、いまいるブランチを確認します。
- PR に `Closes #` を付け忘れたら、PR の説明文を編集して追記できます。
- `git push` で拒否されたら、エラーを見ます。`main` にいるまま push すると、ルールで拒否されます（`GH013: Repository rule violations`）。`git branch` で作業ブランチ（`<GitHubユーザー名>/add-member-page`）にいるか確認します。`403`（`Permission to ... denied`）の場合は、招待を承認したか確認します（説明ページの「よくあるつまずき」）。
- 自分の PR を自分で Approve することはできません。組の相手に声をかけましょう。
- 他の人の PR がマージされたあとに自分がマージしても、コンフリクトは起きません（別ファイルなので）。
