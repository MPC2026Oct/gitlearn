# 5日目の演習：取り消しとやり直し

説明ページ：[5日目：取り消しとやり直し](../../docs/day05-undo.md)

## 目的

「どこにある変更を戻したいか」に応じて、`restore` / `restore --staged` / `commit --amend` / `revert` / `reset --soft` を使い分けられるようになります。

## 所要時間の目安

40〜50分

## 準備

3〜4日目で作った `~/git-practice/my-profile` で行います。まず、作業が片付いている（`git status` が `working tree clean`）ことを確認します。

```bash
cd ~/git-practice/my-profile
git status
```

> [!TIP]
> どの操作も、実行前に `git status` と `git log --oneline` で現在の状態を確認する習慣をつけましょう。

## シナリオ1：間違えて行を消してしまった（restore）

1. `hobbies.md` を開き、好きな行を1行消して保存します（まだ `git add` しない）。
2. `git status` と `git diff` で、消えたことを確認します。
3. 変更を取り消します。

   ```bash
   git restore hobbies.md
   ```

**完了条件**：消した行が戻り、`git status` が `working tree clean` になっている。

> [!WARNING]
> `git restore` で捨てた編集（まだコミットしていない変更）は、元に戻せません。実行前に `git diff` で本当に捨ててよいか確認します。

## シナリオ2：関係ないファイルをステージしてしまった（restore --staged）

1. `scratch.txt` という新しいファイルを作ります（中身は何でも構いません）。

   ```bash
   echo "テスト" > scratch.txt
   ```

2. `profile.md` にも1行追記して保存します。
3. 間違えて両方をステージします。

   ```bash
   git add scratch.txt profile.md
   ```

   `warning: in the working copy of 'scratch.txt', LF will be replaced by CRLF the next time Git touches it` と表示されることがあります。改行コードについての警告なので、無視してかまいません（[レシピ trouble-11](../../recipes/troubleshooting.md#trouble-11)）。

4. `scratch.txt` だけステージから外します。

   ```bash
   git restore --staged scratch.txt
   ```

5. `git status` で、`profile.md` がステージ済み、`scratch.txt` が未追跡になっていることを確認します。
6. `profile.md` をコミットします（例：`git commit -m "自己紹介に1行追記"`）。
7. 練習用の `scratch.txt` は不要なので、削除しておきます（`rm scratch.txt`）。

**完了条件**：コミットに `profile.md` だけが含まれ、`git show --stat` に `scratch.txt` が出ない。

## シナリオ3：コミットメッセージを誤字った（commit --amend）

1. `profile.md` を少し書き換え、わざと誤字のあるメッセージでコミットします。

   ```bash
   git commit -am "自己紹会を更新"
   ```

2. 直前のコミットのメッセージを直します。

   ```bash
   git commit --amend -m "自己紹介を更新"
   ```

3. `git log --oneline` で、メッセージが直り、コミットが増えていないことを確認します。

**完了条件**：最新のコミットのメッセージが「自己紹介を更新」になっていて、同じ内容のコミットが2つ並んでいない。

> [!CAUTION]
> `--amend` は履歴を書き換えます。**push 済みのコミットには使いません。**

## シナリオ4：コミットを打ち消す（revert）

1. 最新のコミットを打ち消します（エディタが開いたら、そのまま保存して閉じます）。

   ```bash
   git revert HEAD
   ```

2. `git log --oneline` を見ます。元のコミットが残ったまま、「Revert ...」というコミットが新しく増えています。
3. `profile.md` の中身が、そのコミットの前の状態に戻っていることを確認します。

**完了条件**：履歴に「Revert」で始まるコミットがあり、ファイルの内容が戻っている（コミットは消えていない）。

> [!NOTE]
> `revert` は履歴を書き換えず、「打ち消すコミット」を追加します。そのため、push 済みのコミットにも使えます。

## シナリオ5：直前のコミットをやり直す（reset --soft）

1. `hobbies.md` に1行追記して、コミットします（例：`git commit -am "趣味を追記"`）。
2. 「やっぱり、もう少し書き足してからコミットしたい」と思ったとします。コミットだけを取り消します（変更はステージに残ります）。

   ```bash
   git reset --soft HEAD~1
   ```

3. `git status` を見ると、変更がステージ済み（`Changes to be committed`）で残っています。`git log --oneline` で、コミットが1つ減ったことも確認します。
4. 1行書き足して、あらためてコミットします。

**完了条件**：`git log --oneline` に「趣味を追記」のコミットが1つだけあり、書き足した内容を含んでいる。

> [!CAUTION]
> `git reset` は履歴を巻き戻します。**push 済みのコミットには使いません。** `--hard` は編集中の変更も消えるので、この演習では使いません。

## まとめ：選び方の表

| 戻したいもの | 使うコマンド | push 済みでも使える？ |
|---|---|---|
| 保存した編集（まだ add していない） | `git restore ファイル名` | （push とは無関係） |
| ステージした内容 | `git restore --staged ファイル名` | （push とは無関係） |
| 直前のコミットのメッセージ・中身 | `git commit --amend` | 使えない |
| 過去のコミットの内容 | `git revert コミット` | 使える |
| 直前のコミットそのもの | `git reset --soft HEAD~1` | 使えない |

## ヒント

- 迷ったら `git status` を見てください。次に使えるコマンドのヒントが表示されています。
- 失敗したと思っても、`git reflog` で過去の状態を探せることがあります（紹介のみ。説明ページを参照）。
- 詳しい手順は [レシピ集（取り消し）](../../recipes/undo.md) にもあります。
