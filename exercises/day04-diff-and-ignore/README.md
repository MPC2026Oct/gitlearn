# 4日目の演習：差分・履歴・.gitignore

説明ページ：[4日目：差分・履歴・.gitignore](../../docs/day04-diff-log-ignore.md)

## 目的

`git diff` / `git diff --staged` / `git log` / `git show` で変更と履歴を読めるようになり、`.gitignore` で管理したくないファイルを無視できるようになります。

## 所要時間の目安

30〜40分

## 準備

3日目で作った `~/git-practice/my-profile` を使います。素材を3つコピーします。

```bash
cd ~/git-practice/my-profile
cp ~/git-practice/gitlearn/exercises/day04-diff-and-ignore/hobbies.md .
cp ~/git-practice/gitlearn/exercises/day04-diff-and-ignore/debug.log .
cp ~/git-practice/gitlearn/exercises/day04-diff-and-ignore/private-memo.txt .
```

## 手順

### パート1：差分と履歴

1. `git status` を実行し、3つのファイルが「追跡されていないファイル」と出ることを確認します。
2. **`.gitignore` を作る前に**、まず `hobbies.md` だけをコミットします。

   ```bash
   git add hobbies.md
   git commit -m "趣味ページを追加"
   ```

3. `hobbies.md` の「（ここを自分の内容に書き換える）」の部分を1行書き換えて保存します。
4. `git diff` で、ステージ前の差分を見ます。
5. `git add hobbies.md` のあとに `git diff` を実行し、何も出ないことを確認します。続けて `git diff --staged` で、ステージ済みの差分を見ます。
6. コミットします（例：`git commit -m "趣味を1つ書き換え"`）。
7. `git log --oneline` で履歴を見ます。
8. 最新のコミットのハッシュ（先頭の7文字ほど）を指定して `git show` を実行します。例：`git show 7f8a9b0`。`7f8a9b0` の部分を、`git log --oneline` で表示された自分のハッシュに置き換えて実行します。
9. `git log -- hobbies.md` で、このファイルに関する履歴だけを見ます。
10. VS Code のソース管理ビューでも、変更したファイルをクリックして差分を見てみます。

### パート2：.gitignore

1. `debug.log` と `private-memo.txt` は、人に見せたくない・記録しなくてよいファイルという想定です。`my-profile` の直下に `.gitignore` を作り、次の2行を書きます。

   ```text
   *.log
   private-memo.txt
   ```

2. `git status` を実行し、`debug.log` と `private-memo.txt` が表示されなくなり、`.gitignore` だけが出ることを確認します。
3. 無視されている理由を確かめます。

   ```bash
   git check-ignore -v debug.log private-memo.txt
   ```

4. `.gitignore` 自体はコミットします。

   ```bash
   git add .gitignore
   git commit -m ".gitignore を追加"
   ```

## 完了条件

- [ ] `git diff` と `git diff --staged` の違い（どの段階の変更を見ているか）を、自分の言葉で説明できる
- [ ] `git log --oneline` に `hobbies.md` を追加したコミットと、書き換えたコミットがある
- [ ] `git check-ignore -v debug.log private-memo.txt` で、両方とも `.gitignore` のどの行が効いているか表示される
- [ ] `git status` が `nothing to commit, working tree clean` で、`debug.log` と `private-memo.txt` は一覧に出ない
- [ ] `git log --stat` を見ても、`debug.log` と `private-memo.txt` がコミットに含まれていない

## ヒント

- `git diff` で何も出ないときは、すでにステージ済みか、保存し忘れている可能性があります。`git status` と `git diff --staged` を見てください。
- `git diff` の画面は `q` で抜けます。
- `.gitignore` に書いても、**すでにコミットしてしまったファイル** は無視されません。このため、パート2の前に `debug.log` などを `git add` しないでください。うっかり `add` した場合は、まだコミット前なら `git restore --staged debug.log` のようにしてステージを取り消せます（5日目で詳しく学びます）。
- 行頭の `*` は「何文字でも」の意味です。`*.log` は「`.log` で終わるすべてのファイル」を表します。
