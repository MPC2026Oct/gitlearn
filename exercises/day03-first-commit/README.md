# 3日目の演習：はじめてのコミット

説明ページ：[3日目：はじめてのコミット](../../docs/day03-first-commit.md)

## 目的

`git init` でリポジトリを作り、自己紹介ファイルを3回以上コミットして、変更を記録する流れ（`status` → `add` → `commit` → `log`）を身につけます。

## 所要時間の目安

30〜40分

## 手順

> [!WARNING]
> `~/git-practice/gitlearn` の **中では** `git init` をしません。かならず `~/git-practice` の直下に新しいフォルダを作ります（リポジトリの入れ子になるためです）。

1. 練習用リポジトリ `my-profile` を作ります。

   ```bash
   mkdir ~/git-practice/my-profile
   cd ~/git-practice/my-profile
   git init
   ```

2. 素材 `profile.md` をコピーします。

   ```bash
   cp ~/git-practice/gitlearn/exercises/day03-first-commit/profile.md ~/git-practice/my-profile/
   ```

3. `git status` で、`profile.md` が「追跡されていないファイル（Untracked files）」と出ることを確認します。
4. VS Code で `my-profile` フォルダを開き、`profile.md` の中身を確認します（このあと書き換えます。まずはひな形のままコミットします）。
5. ひな形のまま、1回目のコミットをします。

   ```bash
   git add profile.md
   git commit -m "自己紹介のひな形を追加"
   ```

6. 「ニックネーム」の下の「（ここを自分の内容に書き換える）」を自分のニックネームに書き換えて保存し、コミットします。

   ```bash
   git status
   git add profile.md
   git commit -m "ニックネームを記入"
   ```

   ほかの項目も同じように、書き換えて保存 → `git add` → `git commit -m "..."` を繰り返します。コミットメッセージは「何をしたか」を日本語で短く書きます（例：「好きなことを追記」）。
7. `git log --oneline` で履歴を確認します（`q` で抜けます）。
8. もう1回、VS Code のソース管理ビューを使ってコミットします（変更の横の「+」でステージ → メッセージを入力 → ✓コミット）。

## 完了条件

- [ ] `~/git-practice/my-profile` に `.git` フォルダがある（`ls -a` で見える）
- [ ] `git log --oneline` で3つ以上のコミットが表示される
- [ ] 少なくとも1回は、VS Code のソース管理ビューからコミットした
- [ ] `git status` が `nothing to commit, working tree clean` になっている
- [ ] `profile.md` に個人情報（本名のフルネーム、電話番号、住所、学籍番号など）を書いていない

## ヒント

- `git commit` に `-m` を付け忘れて、VS Code にメッセージ入力の画面が開いたときは、1行目にメッセージを書いて保存し、そのタブを閉じればコミットされます。
- `git add` を忘れると、`git commit` で `nothing added to commit` と言われます。落ち着いて `git status` を見ましょう。
- `fatal: not a git repository` と出たら、`cd` で `my-profile` に移動できているか `pwd` で確認します。
