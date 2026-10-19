# 12日目の演習：チームでのコンフリクト

説明ページ：[12日目：チームでのコンフリクト](../../docs/day12-team-conflict.md)

## 目的

チーム全員が同じファイルの同じ行を変更する PR を出し、コンフリクトを2通りの方法（手元の VS Code／GitHub 上の Resolve conflicts）で解決します。

## 所要時間の目安

90分（チームで集まる日です。通話＋画面共有で構いません）

## 準備

- 使うファイルは、チームリポジトリの `exercises/team-project/schedule.md` です。初期内容は次の通りです。

  ```markdown
  # 次回の活動予定

  - 日時: 未定
  - 場所: 未定
  - 内容: 未定
  ```

- 役割記号（A〜D）の順番を確認します。進行役は **12日目は4人チームなら D、3人チームなら A** です。
- マージの順番：ラウンド1は A → B → C → D、ラウンド2は逆順（4人：D → C → B → A、3人：C → B → A）。
- `<GitHubユーザー名>` などは、かっこごと置き換えてから実行します。

## ラウンド1：手元の VS Code で解決する

1. 全員が `main` を最新にします。

   ```bash
   cd ~/git-practice/gitlearn-team-<チーム記号>
   git switch main
   git pull
   ```

2. 全員が、ブランチ `<GitHubユーザー名>/round1` を作ります。

   ```bash
   git switch -c <GitHubユーザー名>/round1
   ```

3. `exercises/team-project/schedule.md` の **`- 日時: 未定` の行** を、自分の案に書き換えます（例：`- 日時: 5月10日（土）13:00`）。他の行は変えません。
4. コミットして `push` し、PR を出します。

   ```bash
   git add exercises/team-project/schedule.md
   git commit -m "日時の案を追加"
   git push -u origin <GitHubユーザー名>/round1
   ```

5. **全員の PR がそろうまで、誰もマージしません。**
6. 進行役の声かけで、A の PR をマージします（組の相手が Approve してから、作者がマージ）。すると B の PR に **This branch has conflicts** と表示されます。
7. B は手元で、次の順に解決します。

   ```bash
   git switch <GitHubユーザー名>/round1
   git fetch origin
   git merge origin/main
   ```

   `CONFLICT` と出たら、VS Code で `schedule.md` を開き、**両方の案を残して** 解決します。main（先にマージされた人）の案を前に、自分の案を ` / ` で後ろに足します。

   ```text
   - 日時: 5月10日（土）13:00 / 5月11日（日）10:00
   ```

   ```bash
   git add exercises/team-project/schedule.md
   git commit
   git push
   ```

   `git commit` を実行すると、VS Code にコミットメッセージ（`MERGE_MSG`）のタブが開き、ターミナルは待ち状態になります。内容はそのままでよいので、タブを閉じるとコミットされます。

8. 組の相手が Approve し、B がマージします。
9. C、D も同じように、前の人のマージ後に解決・マージします。

## ラウンド2：GitHub 上の Resolve conflicts で解決する

1. 全員が `main` を最新にします（`git switch main` → `git pull`）。
2. 全員が、ブランチ `<GitHubユーザー名>/round2` を作り、`schedule.md` の **`- 場所: 未定` の行** を自分の案に書き換えて、コミット・`push`・PR を出します。
3. **全員の PR がそろうまで、誰もマージしません。**
4. **逆順**（4人：D → C → B → A、3人：C → B → A）にマージします。2番目以降の人は、PR 画面の **Resolve conflicts** ボタンを押し、ラウンド1と同じように **両方の案を残して** 解決します（main の案を前に、自分の案を後ろに）。**Mark as resolved** → **Commit merge** の順に押し、そのあとマージします。
5. 全員で最後に手元を最新にして、ブランチを片付けます（`round1` をラウンド1の後に削除済みなら、その行は `error: branch '…' not found` になりますが、問題ありません）。

   ```bash
   git switch main
   git pull
   git branch -d <GitHubユーザー名>/round1
   git branch -d <GitHubユーザー名>/round2
   ```

## 完了条件

- [ ] 自分の `round1` と `round2` の PR が、どちらも Merged になった
- [ ] 少なくとも1回、自分でコンフリクトを解決した（ラウンド1またはラウンド2。A はラウンド1ではなくラウンド2で解決する）
- [ ] 手元の VS Code で解決する方法と、GitHub 上の Resolve conflicts で解決する方法の両方を見た（自分でやった、または画面共有で見た）
- [ ] `schedule.md` の「日時」と「場所」に、全員の案が残っている
- [ ] `schedule.md` に `<<<<<<<` `=======` `>>>>>>>` が残っていない
- [ ] コンフリクトを減らす習慣を、2つ以上挙げられる

## ヒント

- 組の相手の Approve を忘れずに。マージするのは **作成者** です。
- マージの順番を間違えても大丈夫です。誰かのコンフリクトの解決が1回増えるだけです。
- `git merge origin/main` を実行する前に、`git fetch origin` を忘れないようにします。
- コンフリクトの解決後に `git push` が拒否されたときは、`git pull` してからもう一度 `push` します。
- 迷ったら、チームで画面を共有して、一緒にマーカーを読みましょう。
- 詳しくは [レシピ集（ブランチ）](../../recipes/branch.md) を見てください。
