# 6日目の演習：ブランチ

説明ページ：[6日目：ブランチ](../../docs/day06-branch.md)

## 目的

ブランチを作って作業し、`main` に fast-forward マージで取り込み、使い終わったブランチを削除する流れを体験します。

## 所要時間の目安

30〜40分

## 手順

`~/git-practice/my-profile` で行います。`git status` が `working tree clean` であることを先に確認してください。

1. 現在のブランチを確認します。`main` に `*` が付いているはずです。

   ```bash
   cd ~/git-practice/my-profile
   git branch
   ```

2. ブランチ `add-favorites` を作って切り替えます。

   ```bash
   git switch -c add-favorites
   ```

3. 素材 `favorites.md` をコピーします。

   ```bash
   cp ~/git-practice/gitlearn/exercises/day06-branch/favorites.md .
   ```

4. `favorites.md` の「（ここを自分の内容に書き換える）」の部分を書き換えます。
5. コミットします。

   ```bash
   git add favorites.md
   git commit -m "好きなものページを追加"
   ```

6. もう少し書き足して、2回目のコミットをします（例：「好きな食べ物を追記」）。
7. `main` に戻り、`favorites.md` が見えなくなることを確認します（消えたのではなく、`main` にはまだ存在しないだけです）。

   ```bash
   git switch main
   ls
   ```

8. `add-favorites` を `main` に取り込みます。

   ```bash
   git merge add-favorites
   ```

   `Fast-forward` と表示されます。`ls` で `favorites.md` が現れます。
9. 履歴を確認します。

   ```bash
   git log --oneline --graph --all
   ```

10. 使い終わったブランチを削除します。

    ```bash
    git branch -d add-favorites
    git branch
    ```

11. VS Code でも、ステータスバー左下のブランチ名をクリックして、ブランチの一覧が出ることを確認します。

## 完了条件

- [ ] `git log --oneline --graph --all` に、「好きなものページを追加」を含む2つ以上のコミットが、1本の線で並んでいる
- [ ] `main` にいて、`favorites.md` が存在する
- [ ] `git branch` の結果に `add-favorites` が出ない（削除済み）
- [ ] `git status` が `working tree clean`

## ヒント

- ブランチを切り替える前は、作業中の変更をコミットしておくと安全です。
- `git branch -d` が `not fully merged` と言ってくる場合は、マージが済んでいません。`git switch main` で `main` にいるか確認し、マージをやり直してください。
- いまどのブランチにいるか分からなくなったら、`git branch` か `git status` の1行目を見ます。
- `git checkout` という古い書き方は、この教材では使いません。
