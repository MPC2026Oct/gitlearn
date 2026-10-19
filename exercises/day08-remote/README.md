# 8日目の演習：GitHub とつなぐ

説明ページ：[8日目：GitHub とつなぐ](../../docs/day08-remote-github.md)

## 目的

ひとりで練習してきた `my-profile` を GitHub に `push` し、別の場所にクローンして、変更を送受信します。`push` が拒否されたときの直し方も体験します。

## 所要時間の目安

60〜90分

## 手順

> [!NOTE]
> `<...>` の部分は、かっこごと置き換えてから実行します。

### パート1：GitHub に push する

1. GitHub で **New repository** を選び、名前を `my-profile` にして作ります。**README・.gitignore・ライセンスは追加せず、空のまま** 作ります（公開範囲は Public / Private どちらでも構いません）。
2. 手元の `my-profile` にリモートを登録します。

   ```bash
   cd ~/git-practice/my-profile
   git remote add origin https://github.com/<GitHubユーザー名>/my-profile.git
   git remote -v
   ```

3. `main` を push します。

   ```bash
   git push -u origin main
   ```

4. GitHub のページを再読み込みして、ファイルとコミット履歴が見えることを確認します。

### パート2：別の場所にクローンする

1. 「もう1台のパソコン」役として、別名でクローンします。

   ```bash
   cd ~/git-practice
   git clone https://github.com/<GitHubユーザー名>/my-profile.git my-profile-clone
   ```

2. `my-profile-clone` の `favorites.md` のいちばん最後に、好きなものを1行追加して保存します。コミットして `push` します。

   ```bash
   cd ~/git-practice/my-profile-clone
   git add favorites.md
   git commit -m "クローン側で好きなものを追加"
   git push
   ```

3. 元の `my-profile` に戻って `pull` します。変更が届くことを確認します。

   ```bash
   cd ~/git-practice/my-profile
   git pull
   ```

### パート3：fetch と pull の違い

1. `my-profile-clone` で `favorites.md` の最後にさらに1行追加して保存し、コミット・`push` します。

   ```bash
   cd ~/git-practice/my-profile-clone
   git add favorites.md
   git commit -m "クローン側でもう1つ追加"
   git push
   ```

2. `my-profile` で、まず `git fetch` だけを実行します。

   ```bash
   cd ~/git-practice/my-profile
   git fetch
   git log --oneline --graph --all
   ```

   `origin/main` が `main` より先に進んでいる（が、手元のファイルはまだ変わっていない）ことを確認します。
3. 取り込みます。

   ```bash
   git merge origin/main
   ```

### パート4：push が拒否される体験

> [!IMPORTANT]
> ここでは **クローン側と元のフォルダで別のファイル** を編集して、コンフリクトにならないようにします。

1. `my-profile-clone` で、`favorites.md` の最後に1行追加して保存し、コミットして `push` します。

   ```bash
   cd ~/git-practice/my-profile-clone
   git add favorites.md
   git commit -m "クローン側で3つ目を追加"
   git push
   ```

2. `my-profile`（まだ `pull` していない状態）で、`profile.md` の **「目標」の行** を書き換えて保存し、コミットして `push` を試します。

   ```bash
   cd ~/git-practice/my-profile
   git add profile.md
   git commit -m "目標を更新"
   git push
   ```

   `! [rejected]` と表示されます（正常です）。
3. 先に `pull` で取り込んでから、`push` し直します。

   ```bash
   git pull
   git push
   ```

   `pull` のときにメッセージ画面が開いたら、そのまま保存して閉じます。
4. `git log --oneline --graph --all` で、枝分かれして合流した形を確認します。
5. `my-profile-clone` でも `git pull` して、両方のフォルダを最新にそろえます。

### パート5：VS Code の「変更の同期」

説明ページの「6. VS Code の「変更の同期」ボタン」の手順で試します。

1. `my-profile-clone` のウィンドウで `favorites.md` に1行追加し、ソース管理ビューでステージしてコミットします（まだ push しません）。
2. ステータスバーのブランチ名の横に `0↓ 1↑` のような表示が出ていることを確認します。
3. 「変更の同期（Sync Changes）」ボタンを押し、確認が出たら **OK** を押します。`↑` の数字が0になれば送れています。
4. 元の `my-profile` のウィンドウでも「変更の同期」を押し、`favorites.md` に行が追加されたことを確認します。

### パート6：2日目のクローンをふりかえる

```bash
cd ~/git-practice/gitlearn
git remote -v
```

2日目にクローンした `gitlearn` にも、最初から `origin` が登録されていることを確認します。

## 完了条件

- [ ] GitHub 上の `my-profile` に、手元のコミット履歴がそのまま見える
- [ ] `~/git-practice/my-profile-clone` があり、`git log --oneline` が `my-profile` と同じ内容になっている（最後に `pull` したあと）
- [ ] `! [rejected]` を一度経験し、`pull` → `push` で解消できた
- [ ] `git remote -v` の結果に、`origin` の URL が表示される
- [ ] `fetch` と `pull` の違いを自分の言葉で説明できる

## ヒント

- 認証画面が出たら、2日目と同じようにブラウザで承認します。
- `git push` で `fatal: The current branch main has no upstream branch` と出たら、`git push -u origin main` を使います（最初の1回だけ）。
- 最初の `git push -u origin main` が `! [rejected]` で拒否されたときは、GitHub 側で README などを追加してリポジトリを作ってしまっています。GitHub のリポジトリを **Settings** → **Danger Zone** → **Delete this repository** で削除し、空で作り直してから、もう一度 `git push -u origin main` します（説明ページ「よくあるつまずき」）。
- パート4で `CONFLICT` が出たときは、同じ行を編集してしまっています。7日目と同じ方法で解決できます。
- 詳しくは [レシピ集（リモート）](../../recipes/remote.md) を見てください。
