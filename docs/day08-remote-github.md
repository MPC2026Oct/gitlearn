# 8日目：GitHub とつなぐ

[← 7日目](day07-merge-conflict.md) ｜ [README（全体の地図）](../README.md) ｜ [9日目 →](day09-team-kickoff.md)

## この日のゴール

- リモートリポジトリ（remote）・`origin`・`clone`／`push`／`pull`／`fetch` の関係を説明できる
- 手元の `my-profile` を GitHub に push できる
- 別の場所にクローンしたリポジトリと、GitHub を通して変更を送ったり受け取ったりできる
- push が拒否されたときに、pull してから push し直せる

## 所要時間の目安

合計 **90分**

| セクション | 目安 |
|---|---|
| 1. リモートリポジトリとは | 10分 |
| 2. my-profile を GitHub に上げる | 20分 |
| 3. 別の場所にクローンする | 10分 |
| 4. 変更を送る・受け取る | 20分 |
| 5. push が拒否される体験 | 15分 |
| 6. VS Code の「変更の同期」ボタン | 5分 |
| 7. 2日目のクローンをふりかえる | 5分 |
| 8. ひとりで練習編のまとめ | 5分 |

## 前提

- 3〜7日目を終えていること（`~/git-practice/my-profile` に `main` ブランチがあり、コミットが複数ある）
- 2日目の認証（Git Credential Manager でのブラウザサインイン）が済んでいること
- `my-profile` にコミットしていない変更がないこと（`git status` で確認）
- 演習：[exercises/day08-remote/README.md](../exercises/day08-remote/README.md)

---

## 1. リモートリポジトリとは

これまでのリポジトリは、すべて **自分のパソコンの中だけ** にありました。これを **ローカルリポジトリ**（local：手元）と呼びます。

これに対して、GitHub のようにネットワークの向こう側にあるリポジトリを **リモートリポジトリ**（remote：遠隔）と呼びます。リモートに置いておくと、

- パソコンが壊れても履歴が残る（バックアップ）
- 別のパソコンや、ほかの人と同じリポジトリを共有できる

ようになります。

```text
     自分のパソコン（ローカル）                        GitHub（リモート）
  ┌──────────────────────────┐                ┌────────────────────┐
  │ my-profile               │   git push →   │ my-profile         │
  │   main                   │ ─────────────→ │   main             │
  │   origin/main（控え）     │ ←───────────── │                    │
  └──────────────────────────┘   ← git fetch  └────────────────────┘
                                  ← git pull
```

| 用語 | 意味 |
|---|---|
| `origin` | リモートリポジトリにつけた **あだ名**。URL を毎回書く代わりに使う。`origin`（起源）という名前が慣習 |
| `clone` | リモートのリポジトリを、履歴ごと手元にコピーする |
| `push` | 手元のコミットをリモートに **送る** |
| `fetch` | リモートの新しいコミットを手元に **取ってくるだけ**（自分の `main` は変えない） |
| `pull` | `fetch` ＋ マージ。取ってきて、自分のブランチに **取り込む** |
| `origin/main` | 「最後に確認したときの、GitHub の `main` の位置」を手元に記録した **控え**（リモート追跡ブランチ） |

> [!NOTE]
> `origin/main` は自分で動かすブランチではありません。`fetch`・`pull`・`push` をしたときに Git が自動で更新します。GitHub の最新の状態を **毎回自動で見に行っているわけではない** ことに注意してください。詳しくは [Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md) を見てください。

---

## 2. my-profile を GitHub に上げる

### GitHub で空のリポジトリを作る

1. ブラウザで <https://github.com> を開き、サインインします。
2. 画面右上の **+** ボタンをクリックし、**New repository** を選びます（執筆時点の表示です）。
3. 次のように入力・選択します。

   | 項目 | 設定 |
   |---|---|
   | **Owner** | 自分のアカウント |
   | **Repository name** | `my-profile` |
   | **Description** | 空欄でよい |
   | 公開範囲 | **Public** でも **Private** でも構いません（Public は世界中から見えます。個人情報が入っていないか確認してから選びましょう） |
   | README・`.gitignore`・license の追加 | **すべて追加しない**（オフ／None のまま） |

   > [!WARNING]
   > README などを追加すると、GitHub 側に「手元にないコミット」ができてしまい、最初の push が拒否されます。必ず **空のリポジトリ** で作ってください。GitHub 公式ドキュメントでも、既存のリポジトリを上げるときは README・license・gitignore を付けずに作るよう案内されています。

4. **Create repository** をクリックします。
5. 「Quick setup」の画面が表示されます。**HTTPS** が選ばれていることを確かめ、表示された URL（`https://github.com/<GitHubユーザー名>/my-profile.git`）を確認します。

出典：[Creating a new repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)、[Adding locally hosted code to GitHub](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)（GitHub Docs、執筆時点で確認）

### リモートを登録する

**Git Bash で**

1. `my-profile` に移動します。

   ```bash
   cd ~/git-practice/my-profile
   ```

2. `main` にいることを確かめます。

   ```bash
   git switch main
   ```

3. GitHub のリポジトリを `origin` というあだ名で登録します。`<...>` の部分は、かっこごと置き換えてから実行します。

   ```bash
   git remote add origin https://github.com/<GitHubユーザー名>/my-profile.git
   ```

   何も表示されなければ成功です。

4. 登録されたかを確認します。

   ```bash
   git remote -v
   ```

   ```text
   origin	https://github.com/<GitHubユーザー名>/my-profile.git (fetch)
   origin	https://github.com/<GitHubユーザー名>/my-profile.git (push)
   ```

   `fetch`（取ってくる先）と `push`（送る先）の2行が表示されます。

> [!TIP]
> URL を間違えて登録したときは、`git remote set-url origin https://github.com/<GitHubユーザー名>/my-profile.git` のように、正しい URL を指定し直せば直せます（`<GitHubユーザー名>` は、かっこごと自分のユーザー名に置き換えます）。→ [レシピ remote-03](../recipes/remote.md#remote-03)

### push する

1. `main` ブランチを `origin` に push します。

   ```bash
   git push -u origin main
   ```

   ```text
   Enumerating objects: 15, done.
   Counting objects: 100% (15/15), done.
   ...
   To https://github.com/<GitHubユーザー名>/my-profile.git
    * [new branch]      main -> main
   branch 'main' set up to track 'origin/main'.
   ```

   （数字は人によって違います。）

2. ブラウザのサインイン画面が出た場合は、2日目と同じように Git Credential Manager の画面で **ブラウザでサインイン** し、GitHub で承認します。2日目に認証を済ませていれば、資格情報が Windows に保存されているので、通常は何も聞かれません。

`-u` の意味：`-u`（`--set-upstream`）は、「手元の `main` の **上流（upstream）** は `origin` の `main` です」と覚えさせるオプションです。最後の行 `branch 'main' set up to track 'origin/main'.` がその意味です。**最初の1回だけ** 付ければ、次からは `git push` や `git pull` だけで、どこと同期するかを Git が判断してくれます。

3. 状態を確認します。

   ```bash
   git status
   ```

   ```text
   On branch main
   Your branch is up to date with 'origin/main'.

   nothing to commit, working tree clean
   ```

   「`origin/main` と同じ状態です」と表示されるようになりました。

出典：[Caching your GitHub credentials in Git](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git)（GitHub Docs、執筆時点で確認。Windows では Git Credential Manager がブラウザでのサインインを行い、資格情報を保存します）

### GitHub で確認する

1. ブラウザで `https://github.com/<GitHubユーザー名>/my-profile` を開きます（作成直後の画面なら再読み込みします）。
2. `profile.md`・`favorites.md` などのファイルが表示されていることを確かめます。
3. ファイル一覧の上にある **コミット数（〇 Commits）** をクリックし、手元の `git log --oneline` と同じコミットが並んでいることを確かめます。

> [!NOTE]
> `.gitignore` で無視した `debug.log` や `private-memo.txt` は GitHub に上がっていないはずです。4日目の `.gitignore` がきちんと働いていることも確かめましょう。

---

## 3. 別の場所にクローンする

チームで使うときは、ほかの人のパソコンにも同じリポジトリがあります。ここでは、同じパソコンの別フォルダを **「もう1台のパソコン」役** にして、その状況を再現します。

1. 練習用フォルダの親に移動します。

   ```bash
   cd ~/git-practice
   ```

2. GitHub の `my-profile` を、`my-profile-clone` という名前のフォルダにクローンします。`<...>` の部分は、かっこごと置き換えてから実行します。

   ```bash
   git clone https://github.com/<GitHubユーザー名>/my-profile.git my-profile-clone
   ```

   ```text
   Cloning into 'my-profile-clone'...
   remote: Enumerating objects: 15, done.
   ...
   ```

   URL の後ろにフォルダ名を書くと、その名前でクローンされます（書かないと `my-profile` という名前になり、元のフォルダとぶつかってしまいます）。

3. クローンしたフォルダを VS Code の **新しいウィンドウ** で開きます。

   ```bash
   code ~/git-practice/my-profile-clone
   ```

   **VS Code で** 開く場合は、メニューの「ファイル（File）」→「新しいウィンドウ（New Window）」→「フォルダーを開く（Open Folder）」で `C:\Users\<Windowsのユーザー名>\git-practice\my-profile-clone` を選びます。

4. 新しいウィンドウでターミナル（`` Ctrl+` ``）を開き、場所と状態を確認します。

   ```bash
   cd ~/git-practice/my-profile-clone
   git log --oneline
   ```

   元の `my-profile` と同じ履歴が入っています。`git remote -v` を実行すると、クローン元の URL が自動で `origin` として登録されていることもわかります。

> [!TIP]
> ここからは、**元の `my-profile` のウィンドウ** と **`my-profile-clone` のウィンドウ** を行き来します。どちらのウィンドウで作業しているか、ターミナルのプロンプトに表示されるフォルダ名（`~/git-practice/my-profile` か `~/git-practice/my-profile-clone` か）で必ず確かめてください。

---

## 4. 変更を送る・受け取る

### クローン側でコミットして push する

ここは **`my-profile-clone`** のウィンドウで作業します。

1. `favorites.md` のいちばん最後に、好きなものを1行追加して保存します。
2. ステージしてコミットします。

   ```bash
   git add favorites.md
   git commit -m "クローン側で好きなものを追加"
   ```

3. push します。クローンしたリポジトリは最初から上流が設定されているので、`-u` は不要です。

   ```bash
   git push
   ```

   ```text
   To https://github.com/<GitHubユーザー名>/my-profile.git
      8221bae..cdcfe4b  main -> main
   ```

4. ブラウザで GitHub の `my-profile` を再読み込みし、`favorites.md` に追加した行が表示されていることを確かめます。

### 元のフォルダで pull する

ここは **元の `my-profile`** のウィンドウで作業します。

1. まだ `favorites.md` に追加した行がないことを確かめます。

   ```bash
   cd ~/git-practice/my-profile
   cat favorites.md
   ```

2. GitHub の変更を取り込みます。

   ```bash
   git pull
   ```

   ```text
   From https://github.com/<GitHubユーザー名>/my-profile
      8221bae..cdcfe4b  main       -> origin/main
   Updating 8221bae..cdcfe4b
   Fast-forward
    favorites.md | 1 +
    1 file changed, 1 insertion(+)
   ```

3. もう一度 `cat favorites.md` を実行し、クローン側で追加した行が入っていることを確かめます。

これで「別のパソコンで作業 → GitHub → このパソコン」という流れができました。チーム開発では、この「別のパソコン」がチームの仲間になります。

### fetch と pull の違い

`pull` は、実は **`fetch`（取ってくる）と `merge`（取り込む）の2つを続けて実行** しています。2つを分けて実行すると、取り込む前に「何が来たのか」を確かめられます。

1. **`my-profile-clone`** のウィンドウで、もう1つ変更を作って push します。`favorites.md` の最後にさらに1行追加して保存し、次を実行します。

   ```bash
   git add favorites.md
   git commit -m "クローン側でもう1つ追加"
   git push
   ```

2. **元の `my-profile`** のウィンドウで、取ってくるだけの `fetch` を実行します。

   ```bash
   git fetch
   ```

   ```text
   From https://github.com/<GitHubユーザー名>/my-profile
      cdcfe4b..929ad90  main       -> origin/main
   ```

3. 状態を確認します。

   ```bash
   git status
   ```

   ```text
   On branch main
   Your branch is behind 'origin/main' by 1 commit, and can be fast-forwarded.
     (use "git pull" to update your local branch)

   nothing to commit, working tree clean
   ```

   「手元の `main` は `origin/main` より1コミット遅れている」と教えてくれます。

4. 履歴をグラフで見ます。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   * 929ad90 (origin/main) クローン側でもう1つ追加
   * cdcfe4b (HEAD -> main) クローン側で好きなものを追加
   ...
   ```

   `origin/main` だけが先に進み、手元の `main` はまだ前のままです。`fetch` は **手元の `main` もファイルも変えない** ので、安心して実行できます。

5. 中身を確かめたら、`origin/main` を `main` に取り込みます。

   ```bash
   git merge origin/main
   ```

   ```text
   Updating cdcfe4b..929ad90
   Fast-forward
    favorites.md | 1 +
    1 file changed, 1 insertion(+)
   ```

   6日目と同じ fast-forward マージです。「`fetch` ＋ `merge origin/main`」が、`pull` 1回と同じ結果になりました。

#### 1日目の `pull.rebase false` の意味

1日目に `git config --global pull.rebase false` を設定しました。これは「**pull で取り込むときは、merge を使う**」という指定です。

- `pull` の「取り込む」部分には、**merge** を使う方法と、**rebase**（コミットを付け替える方法。13日目に任意で紹介）を使う方法があります。
- この設定がないと、手元と GitHub の両方が進んでいるときに `pull` すると、Git が「どちらで取り込むか決めてください」（`Need to specify how to reconcile divergent branches`）と止まってしまいます。
- この勉強会では、7日目で学んだ **merge** に統一するために `false` にしています。

詳しくは [Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md) を見てください。

---

## 5. push が拒否される体験

### 両方で変更して push してみる

チーム開発でよく起きる、「GitHub のほうが先に進んでいて push できない」状況を体験します。

> [!NOTE]
> ここではコンフリクトを起こさないように、**クローン側と元のフォルダで別のファイルを編集** します。

1. **`my-profile-clone`** のウィンドウで、`favorites.md` の最後に1行追加して保存し、コミットして push します。

   ```bash
   git add favorites.md
   git commit -m "クローン側で3つ目を追加"
   git push
   ```

   こちらは成功します。

2. **元の `my-profile`** のウィンドウで、**`git pull` をせずに**、`profile.md` の「目標」の行を書き換えて保存し、コミットします。

   ```bash
   git add profile.md
   git commit -m "目標を更新"
   ```

3. push します。

   ```bash
   git push
   ```

   ```text
   To https://github.com/<GitHubユーザー名>/my-profile.git
    ! [rejected]        main -> main (fetch first)
   error: failed to push some refs to 'https://github.com/<GitHubユーザー名>/my-profile.git'
   hint: Updates were rejected because the remote contains work that you do not
   hint: have locally. This is usually caused by another repository pushing to
   hint: the same ref. If you want to integrate the remote changes, use
   hint: 'git pull' before pushing again.
   ...
   ```

   **拒否されました（`! [rejected]`）**。「GitHub には、あなたの手元にない作業（クローン側のコミット）があります。先に `git pull` で取り込んでください」という意味です。

   Git は、GitHub 側のコミットを消してしまわないように、**fast-forward できない push を拒否** します。これは事故を防ぐための安全装置です。

### pull してから push し直す

1. GitHub の変更を取り込みます。

   ```bash
   git pull
   ```

2. 手元と GitHub の **両方が進んでいる** ので、fast-forward ではなくマージコミットが作られます。7日目と同じように、**VS Code に `MERGE_MSG` のタブが開く** ので、内容（`Merge branch 'main' of https://github.com/...`）を確認してタブを閉じます。

   ```text
   From https://github.com/<GitHubユーザー名>/my-profile
      929ad90..3e9afe7  main       -> origin/main
   Merge made by the 'ort' strategy.
    favorites.md | 1 +
    1 file changed, 1 insertion(+)
   ```

   > [!TIP]
   > タブを開かずに済ませたいときは `git pull --no-edit` とします。

3. 履歴をグラフで見ます。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   *   c4705b2 (HEAD -> main) Merge branch 'main' of https://github.com/<GitHubユーザー名>/my-profile
   |\
   | * 3e9afe7 (origin/main) クローン側で3つ目を追加
   * | c65fe6a 目標を更新
   |/
   * 929ad90 クローン側でもう1つ追加
   ...
   ```

4. もう一度 push します。今度は成功します。

   ```bash
   git push
   ```

   ```text
   To https://github.com/<GitHubユーザー名>/my-profile.git
      3e9afe7..c4705b2  main -> main
   ```

5. **`my-profile-clone`** のウィンドウでも `git pull` を実行し、両方のフォルダを最新にそろえておきます。

> [!WARNING]
> 拒否されたときに、インターネットで見つけた `git push --force`（強制 push）を使うのは **絶対にやめましょう**。GitHub 側にあるほかの人のコミットを消してしまいます。正しい対処は「pull してから push」です。→ [レシピ trouble-04](../recipes/troubleshooting.md#trouble-04)

> [!NOTE]
> 両方が **同じファイルの同じ行** を変えていた場合は、`git pull` でコンフリクトが起きます。そのときは7日目と同じ手順（VS Code で解決 → `git add` → `git commit`）で解決してから push します。

---

## 6. VS Code の「変更の同期」ボタン

VS Code では、`pull` と `push` をボタン1つで行えます。

1. **`my-profile-clone`** のウィンドウで、`favorites.md` に1行追加して保存し、ソース管理ビューでステージしてコミットします（まだ push しません）。
2. 画面左下のステータスバーを見ます。ブランチ名の横に **`0↓ 1↑`** のような表示があります（執筆時点の表示です）。

   | 表示 | 意味 |
   |---|---|
   | `↓` の数字 | GitHub にあって、手元にまだないコミットの数（pull すると入ってくる） |
   | `↑` の数字 | 手元にあって、GitHub にまだないコミットの数（push すると送られる） |

   > [!NOTE]
   > `↓` の数字は、最後に `fetch` したときの情報です。VS Code は定期的に `fetch` することもできます（「定期的に git fetch を実行しますか?」と聞かれたら、どちらを選んでも構いません）。

3. ソース管理ビューの「**変更の同期**（Sync Changes）」ボタン、またはステータスバーの同期アイコン（↓↑ の部分）をクリックします。
4. 初回は「このアクションは、"origin/main" との間でコミットをプルおよびプッシュします。」という確認が出ます。**OK** をクリックします。
5. `↑` の数字が0になり、GitHub に送られたことを確かめます。
6. **元の `my-profile`** のウィンドウでも「変更の同期」を実行し、`favorites.md` に行が追加されたことを確かめます。

「変更の同期」は、**`git pull` を実行してから `git push` を実行する** のと同じ動きです。

> [!TIP]
> ソース管理ビューの「…」（その他の操作）メニューの中にある「プル（Pull）」「プッシュ（Push）」「フェッチ（Fetch）」を使って、1つずつ実行することもできます。

---

## 7. 2日目のクローンをふりかえる

2日目に、VS Code で教材を「クローン」しました。あのとき何が起きていたのか、今ならわかるはずです。

1. 教材のフォルダに移動します。

   ```bash
   cd ~/git-practice/gitlearn
   ```

2. リモートを確認します。

   ```bash
   git remote -v
   ```

   ```text
   origin	https://github.com/<GitHubユーザー名>/gitlearn.git (fetch)
   origin	https://github.com/<GitHubユーザー名>/gitlearn.git (push)
   ```

2日目のクローンで、自分の GitHubアカウントにある `gitlearn`（テンプレートから作ったコピー）が `origin` として登録され、`main` が `origin/main` を追跡する設定になっていたのです。Private のリポジトリをクローンしたので、そのときにブラウザでの認証（Git Credential Manager）が必要でした。

> [!TIP]
> 教材にメモを書き込んでコミットし、`git push` すれば、自分の GitHub の `gitlearn` にバックアップできます。

---

## 8. ひとりで練習編のまとめ

3〜8日目に使ったコマンドの早見表です。迷ったときに見返してください。

| やりたいこと | Git Bash | VS Code | 学んだ日 |
|---|---|---|---|
| リポジトリを作る | `git init` | — | 3日目 |
| 状態を見る | `git status` | ソース管理ビュー | 3日目 |
| ステージする | `git add profile.md` | 「+」（変更をステージ） | 3日目 |
| コミットする | `git commit -m "メッセージ"` | メッセージ欄 →「✓ コミット」 | 3日目 |
| 履歴を見る | `git log --oneline --graph --all` | — | 3〜4日目 |
| 差分を見る | `git diff`、`git diff --staged` | ソース管理ビューでファイルをクリック | 4日目 |
| 1つのコミットの中身を見る | `git show a1b2c3d` | — | 4日目 |
| 編集を取り消す | `git restore profile.md` | 「変更を破棄」 | 5日目 |
| ステージを取り消す | `git restore --staged profile.md` | 「変更のステージング解除」 | 5日目 |
| 直前のコミットを直す | `git commit --amend` | — | 5日目 |
| コミットを打ち消す | `git revert a1b2c3d` | — | 5日目 |
| ブランチの一覧 | `git branch` | ステータスバーのブランチ名 | 6日目 |
| ブランチを作って切り替える | `git switch -c add-favorites` | 「Git: ブランチの作成...」 | 6日目 |
| ブランチを切り替える | `git switch add-favorites` | ステータスバーのブランチ名 | 6日目 |
| マージする | `git merge add-favorites` | 「Git: マージ...」 | 6〜7日目 |
| マージをやめる | `git merge --abort` | 「Git: マージの中止」 | 7日目 |
| ブランチを削除する | `git branch -d add-favorites` | 「Git: ブランチの削除...」 | 6日目 |
| リモートを登録する | `git remote add origin https://github.com/<GitHubユーザー名>/my-profile.git` | — | 8日目 |
| リモートを確認する | `git remote -v` | — | 8日目 |
| クローンする | `git clone https://github.com/<GitHubユーザー名>/my-profile.git my-profile-clone` | 「Git: クローン」 | 2・8日目 |
| 初めて push する | `git push -u origin main` | 「Branch の発行（Publish Branch）」（10日目） | 8日目 |
| push する | `git push` | 「変更の同期」 | 8日目 |
| 取ってくるだけ | `git fetch` | 「…」→「フェッチ」 | 8日目 |
| 取り込む | `git pull` | 「変更の同期」 | 8日目 |

> [!NOTE]
> 上の表の `profile.md`（ファイル名）、`a1b2c3d`（コミットのハッシュ値）、`add-favorites`・`main`（ブランチ名）は例です。実際に使うときは、自分の値に置き換えてください。`<GitHubユーザー名>` は、かっこごと自分のユーザー名に置き換えます。

明日からはいよいよ **チーム開発編** です。チームで集まる時間を確認しておきましょう。

---

## 確認チェックリスト

- [ ] `origin`・`origin/main`・`fetch`・`pull` の違いを説明できる
- [ ] GitHub に README などを付けずに `my-profile` を作った
- [ ] `git remote -v` で `origin` に `https://github.com/<GitHubユーザー名>/my-profile.git` が表示される
- [ ] `git push -u origin main` で push し、GitHub の画面でファイルとコミットを確かめた
- [ ] `~/git-practice/my-profile-clone` にクローンし、そこから push した変更を元のフォルダで `git pull` できた
- [ ] `git fetch` のあと `git status` に `behind 'origin/main'` と表示されるのを確かめ、`git merge origin/main` で取り込んだ
- [ ] push が `! [rejected]` で拒否されるのを体験し、`git pull` → `git push` で解決した
- [ ] VS Code の「変更の同期（Sync Changes）」で送受信できた
- [ ] 両方のフォルダで `git status` が `Your branch is up to date with 'origin/main'.` になっている
- [ ] 演習 [exercises/day08-remote/README.md](../exercises/day08-remote/README.md) の完了条件を満たした

## よくあるつまずき

**症状：push すると `! [rejected] main -> main (fetch first)` や `(non-fast-forward)` と出る**
- 原因：GitHub 側に、手元にないコミットがあります（もう1つのフォルダから先に push した、など）。
- 対処：`git pull` してから `git push` します。`--force` は使いません。→ [レシピ trouble-04](../recipes/troubleshooting.md#trouble-04)

**症状：最初の `git push -u origin main` が `! [rejected] main -> main (fetch first)` で拒否される**
- 原因：GitHub でリポジトリを作るときに、README・.gitignore・license のどれかを追加しました。GitHub 側にだけ別のコミットができています。この状態では、`git pull` は `There is no tracking information for the current branch.`、`git pull origin main` は `fatal: refusing to merge unrelated histories` で止まります。
- 対処：GitHub のリポジトリを削除して、空で作り直すのがいちばん簡単です。リポジトリの画面で **Settings** → いちばん下の **Danger Zone** → **Delete this repository** を押し、表示に従って削除します。そのあと「2. my-profile を GitHub に上げる」の手順で、何も追加せずに作り直し、`git push -u origin main` します（`origin` の登録はそのままで構いません）。
- 発展：作り直さずに `git pull origin main --allow-unrelated-histories` で2つの履歴をつなぐ方法もありますが、コンフリクトが起きることがあるので、慣れるまではおすすめしません。

**症状：`error: src refspec main does not match any` と出る**
- 原因：手元に `main` ブランチがない（ブランチ名が `master` になっている、またはまだ1つもコミットしていない）。
- 対処：`git branch` でブランチ名を確認します。→ [レシピ trouble-07](../recipes/troubleshooting.md#trouble-07)

**症状：`fatal: Need to specify how to reconcile divergent branches.` と出て pull できない**
- 原因：1日目の `pull.rebase` の設定が入っていません。
- 対処：`git config --global pull.rebase false` を実行してから、もう一度 `git pull` します。→ [レシピ trouble-08](../recipes/troubleshooting.md#trouble-08)

**症状：`error: remote origin already exists.` と出る**
- 原因：`origin` はすでに登録されています。
- 対処：`git remote -v` で URL を確認し、間違っていれば `git remote set-url origin https://github.com/<GitHubユーザー名>/my-profile.git` で直します。→ [レシピ remote-03](../recipes/remote.md#remote-03)

**症状：`remote: Repository not found.` と出る**
- 原因：URL のユーザー名・リポジトリ名の打ち間違い、または別の GitHubアカウントでサインインしている。
- 対処：GitHub のリポジトリ画面の URL と `git remote -v` の表示を見比べます。アカウントが違う場合は → [レシピ setup-05](../recipes/setup.md#setup-05)

**症状：`Authentication failed` や `403` と出る**
- 原因：保存されている認証情報が古い、または別のアカウントのものです。
- 対処：→ [レシピ trouble-06](../recipes/troubleshooting.md#trouble-06)

**症状：`GH007: Your push would publish a private email address.` と出る**
- 原因：コミットに、非公開設定にしたメールアドレスが使われています（2日目より前の設定でコミットした場合など）。
- 対処：→ [レシピ trouble-12](../recipes/troubleshooting.md#trouble-12)

**症状：`git pull` のあと、ターミナルが止まったまま動かない**
- 原因：VS Code に `MERGE_MSG` のタブが開いて、閉じられるのを待っています。
- 対処：VS Code のタブを閉じます。

**症状：どちらのフォルダで作業しているかわからなくなった**
- 対処：`pwd` で今いる場所を確認します。VS Code のウィンドウのタイトルにもフォルダ名が表示されています。

## もっと知りたい人へ

- [Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md)：`origin/main`、上流ブランチ（`-u`）、`fetch` と `pull`、`pull.rebase` の選択肢、push が拒否される理由、`--force` の危険性
- [Appendix：認証のしくみ](../appendix/authentication.md)：HTTPS と Git Credential Manager、資格情報の保存と削除
- レシピ
  - [remote-01 GitHub のリポジトリを手元にコピーしたい（clone）](../recipes/remote.md#remote-01)
  - [remote-02 手元で作ったリポジトリを GitHub に上げたい](../recipes/remote.md#remote-02)
  - [remote-03 登録されているリモートを確認・変更したい](../recipes/remote.md#remote-03)
  - [remote-04 変更を GitHub に送りたい（push）／新しいブランチを初めて送りたい](../recipes/remote.md#remote-04)
  - [remote-05 GitHub の最新を取り込みたい（pull）](../recipes/remote.md#remote-05)
  - [remote-06 取り込む前に、何が変わったかを確認したい（fetch）](../recipes/remote.md#remote-06)
  - [trouble-04 push すると `! [rejected]` と出る](../recipes/troubleshooting.md#trouble-04)
  - [trouble-07 `error: src refspec main does not match any` と出る](../recipes/troubleshooting.md#trouble-07)
  - [trouble-08 `Need to specify how to reconcile divergent branches` と出る](../recipes/troubleshooting.md#trouble-08)

---
[← 7日目](day07-merge-conflict.md) ｜ [README](../README.md) ｜ [9日目 →](day09-team-kickoff.md)
