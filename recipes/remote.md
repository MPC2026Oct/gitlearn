# レシピ集：GitHub とのやりとり

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

手元のリポジトリと GitHub 上のリモートリポジトリ（remote：GitHub などに置いた、もう1つのリポジトリ）のあいだで、変更を送ったり受け取ったりするときのレシピです。仕組みを詳しく知りたい人は [Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md) を読んでください。

| ID                      | やりたいこと                                                     |
| ----------------------- | ---------------------------------------------------------------- |
| [remote-01](#remote-01) | GitHub のリポジトリを手元にコピーしたい（clone）                 |
| [remote-02](#remote-02) | 手元で作ったリポジトリを GitHub に上げたい                       |
| [remote-03](#remote-03) | 登録されているリモートを確認・変更したい                         |
| [remote-04](#remote-04) | 変更を GitHub に送りたい（push）／新しいブランチを初めて送りたい |
| [remote-05](#remote-05) | GitHub の最新を取り込みたい（pull）                              |
| [remote-06](#remote-06) | 取り込む前に、何が変わったかを確認したい（fetch）                |
| [remote-07](#remote-07) | 他の人のブランチ（PR）を手元で確かめたい                         |

> [!NOTE]
> コマンドは VS Code のターミナル（Git Bash）で実行します。VS Code の画面のラベルは日本語化パック導入時の表示で、（ ）内は英語表示です（執筆時点の表示です）。

---

<a id="remote-01"></a>
## remote-01 GitHub のリポジトリを手元にコピーしたい（clone）

**こんなとき**：GitHub 上にあるリポジトリを、自分のパソコンで編集できるようにしたいとき。2日目の教材コピー（`gitlearn`）、8日目の `my-profile-clone`、9日目のチームリポジトリで使います。クローン（clone）すると、ファイルだけでなく **履歴ごと** コピーされ、GitHub の URL が `origin` という名前で自動的に登録されます。

**Git Bash**：`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
cd ~/git-practice
git clone https://github.com/<GitHubユーザー名>/gitlearn.git
cd gitlearn
```

```text
Cloning into 'gitlearn'...
remote: Enumerating objects: 120, done.
...
Receiving objects: 100% (120/120), done.
```

（数字は人によって違います。）

フォルダ名を変えてクローンしたいときは、URL のあとにフォルダ名を書きます（8日目の「もう1台のパソコン」役）。

```bash
cd ~/git-practice
git clone https://github.com/<GitHubユーザー名>/my-profile.git my-profile-clone
```

チームリポジトリの場合は次のとおりです。

```bash
cd ~/git-practice
git clone https://github.com/<運営者のアカウント>/gitlearn-team-<チーム記号>.git
```

**VS Code**：

1. コマンドパレット（`Ctrl+Shift+P`）を開き、「Git: クローン（Git: Clone）」を選びます。
2. リポジトリの URL（`https://github.com/.../○○.git`）を貼り付けて `Enter` を押します。「GitHub から複製（Clone from GitHub）」を選ぶと、一覧から選ぶこともできます。
3. 保存先を聞かれたら `C:\Users\<Windowsのユーザー名>\git-practice` を選び、ダイアログ右下のボタン（英語表示では「Select as Repository Destination」）を押します。
4. 右下に「開きますか？」と出たら「開く（Open）」を押します。

URL は、GitHub のリポジトリのページで緑色の **Code** ボタン → **HTTPS** タブに表示されているものをコピーします。

**注意点**：

- 初めて Private リポジトリをクローンするときは、Git Credential Manager（GCM）のサインイン画面が出ます。**Sign in with your browser** を選び、ブラウザで承認してください（2日目）。
- `git clone` は **リポジトリの外**（`~/git-practice` など）で実行します。すでにあるリポジトリの中でクローンすると、リポジトリの入れ子になります。
- 同じ名前のフォルダがすでにあると `fatal: destination path 'gitlearn' already exists and is not an empty directory.` と出ます。別のフォルダ名を指定するか、場所を変えてください。
- `Repository not found` や `403` と出るときは [trouble-06](troubleshooting.md#trouble-06) を見てください。

**関連**：[2日目](../docs/day02-github-account.md)、[8日目](../docs/day08-remote-github.md)、[9日目](../docs/day09-team-kickoff.md)、[Appendix：認証のしくみ](../appendix/authentication.md)

---

<a id="remote-02"></a>
## remote-02 手元で作ったリポジトリを GitHub に上げたい

**こんなとき**：`git init` で作ったリポジトリ（例：`~/git-practice/my-profile`）を GitHub に置いて、バックアップや共有をしたいとき。

**Git Bash**：

1. GitHub で空のリポジトリを作ります（右上の **+** → **New repository**）。**Repository name** に `my-profile` と入れ、**Add README**・**.gitignore**・**license** は **追加しない** で **Create repository** を押します。
2. 手元のリポジトリにリモートを登録し、push します。`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
cd ~/git-practice/my-profile
git remote add origin https://github.com/<GitHubユーザー名>/my-profile.git
git remote -v
git push -u origin main
```

```text
origin  https://github.com/<GitHubユーザー名>/my-profile.git (fetch)
origin  https://github.com/<GitHubユーザー名>/my-profile.git (push)
...
To https://github.com/<GitHubユーザー名>/my-profile.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

3. GitHub のリポジトリのページを再読み込みして、ファイルとコミットが表示されれば完了です。

**VS Code**：

- **GitHub にまだリポジトリがない場合**：ソース管理ビュー（`Ctrl+Shift+G`）の「GitHub に公開（Publish to GitHub）」ボタン（または「Branch の発行（Publish Branch）」）を押し、Public／Private を選ぶと、GitHub 上のリポジトリ作成から push までまとめて行われます。初回は VS Code が GitHub へのサインインを求めます。
- **GitHub に空のリポジトリを作った場合**：ソース管理ビューの「…」（その他の操作）→「リモート（Remote）」→「リモートの追加（Add Remote）」で URL を貼り付け、名前に `origin` と入れます。そのあと「Branch の発行（Publish Branch）」を押します。

**注意点**：

- GitHub 側で README などを追加して作ると、GitHub 側にだけコミットがある状態になり、最初の push が `! [rejected]` で拒否されます。このとき `git pull` は `There is no tracking information for the current branch.`、`git pull origin main` は `fatal: refusing to merge unrelated histories` で止まります。README などを付けて作ってしまったときは、GitHub でリポジトリを削除して空で作り直すのがいちばん簡単です（リポジトリの **Settings** → **Danger Zone** → **Delete this repository**）。作り直したら、もう一度 `git push -u origin main` します。
- コミットが1つもないと `error: src refspec main does not match any` と出ます → [trouble-07](troubleshooting.md#trouble-07)。
- `-u` は「この手元の `main` は `origin/main` と対応している」と覚えさせる（上流ブランチを設定する）オプションです。最初の1回だけ付ければ、次からは `git push` だけで送れます。
- `error: remote origin already exists.` と出たら、すでに登録済みです。[remote-03](#remote-03) で確認してください。

**関連**：[8日目](../docs/day08-remote-github.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="remote-03"></a>
## remote-03 登録されているリモートを確認・変更したい

**こんなとき**：このリポジトリがどの GitHub のリポジトリとつながっているかを確かめたいとき。URL を打ち間違えた、GitHub でリポジトリ名を変えた、などで登録先を直したいとき。

**Git Bash**：

確認する：

```bash
git remote -v
```

```text
origin  https://github.com/<GitHubユーザー名>/my-profile.git (fetch)
origin  https://github.com/<GitHubユーザー名>/my-profile.git (push)
```

何も表示されなければ、リモートはまだ登録されていません（[remote-02](#remote-02)）。

URL を変更する（`<...>` の部分は、かっこごと置き換えてから実行します）：

```bash
git remote set-url origin https://github.com/<GitHubユーザー名>/my-profile.git
git remote -v
```

登録を削除して登録し直す：

```bash
git remote remove origin
git remote add origin https://github.com/<GitHubユーザー名>/my-profile.git
```

**VS Code**：ソース管理ビューの「…」（その他の操作）→「リモート（Remote）」から「リモートの追加（Add Remote）」「リモートの削除（Remove Remote）」ができます。URL の確認と変更（`set-url`）は GUI にないので、ターミナルで実行します。

**注意点**：

- `origin` は「最初に登録したリモート」に付ける慣例の名前です。この教材では常に `origin` を使います。
- GitHub でリポジトリ名を変更しても、古い URL はしばらく転送されます。ただし混乱を防ぐため、`set-url` で新しい URL に直しておきましょう。
- URL の末尾の `.git` はあってもなくても動きますが、この教材では付けて書きます。

**関連**：[8日目（2日目のクローンをふりかえる）](../docs/day08-remote-github.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="remote-04"></a>
## remote-04 変更を GitHub に送りたい（push）／新しいブランチを初めて送りたい

**こんなとき**：手元でコミットした内容を GitHub に反映したいとき。チーム開発で作業用ブランチを作り、PR を出すために GitHub に送りたいとき。

**Git Bash**：

すでに GitHub にあるブランチ（`-u` 設定済み）に送る：

```bash
git push
```

```text
To https://github.com/<GitHubユーザー名>/my-profile.git
   a1b2c3d..e4f5a6b  main -> main
```

（ハッシュ値は人によって違います。）

新しいブランチを初めて送る（`<...>` の部分は、かっこごと置き換えてから実行します）：

```bash
git switch -c <GitHubユーザー名>/add-member-page
```

ファイルを編集して `git add` → `git commit` したら、次を実行します。

```bash
git push -u origin <GitHubユーザー名>/add-member-page
```

```text
remote: Create a pull request for 'hydr4/add-member-page' on GitHub by visiting:
remote:      https://github.com/<運営者のアカウント>/gitlearn-team-a/pull/new/hydr4/add-member-page
To https://github.com/<運営者のアカウント>/gitlearn-team-a.git
 * [new branch]      hydr4/add-member-page -> hydr4/add-member-page
branch 'hydr4/add-member-page' set up to track 'origin/hydr4/add-member-page'.
```

**VS Code**：

- ソース管理ビューの「変更の同期（Sync Changes）」ボタン、またはステータスバー左下のブランチ名の横にある ↑↓ の数字をクリックすると、pull と push をまとめて行います。↑の数字が「まだ送っていないコミットの数」です。
- push だけしたいときは、ソース管理ビューの「…」→「プッシュ（Push）」を選びます。
- 新しいブランチでは、ソース管理ビューに「Branch の発行（Publish Branch）」ボタンが出ます。押すと、上の `git push -u origin ...` と同じことが行われます。

**注意点**：

- `git push` で `fatal: The current branch ... has no upstream branch.` と出たら、そのブランチはまだ GitHub にありません。メッセージに表示された `git push --set-upstream origin ...` のコマンド（`--set-upstream` は `-u` と同じ意味）をそのままコピーして実行してください。
- push が `! [rejected]` で拒否されたら、GitHub 側に自分の手元にないコミットがあります → [trouble-04](troubleshooting.md#trouble-04)。
- チーム開発では **`main` に直接 push しません**（9日目のチームのルール）。push する前に `git status` の1行目で今いるブランチを確かめましょう。
- `git push --force`（強制 push）は、GitHub 上の他の人のコミットを消してしまうことがあります。この勉強会では使いません。
- push のときに `GH007: Your push would publish a private email address.` と出たら [trouble-12](troubleshooting.md#trouble-12) を見てください（コミットのときに出る `Author identity unknown` は [trouble-02](troubleshooting.md#trouble-02)）。

**関連**：[8日目](../docs/day08-remote-github.md)、[10日目](../docs/day10-pull-request.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="remote-05"></a>
## remote-05 GitHub の最新を取り込みたい（pull）

**こんなとき**：他の人（または「もう1台のパソコン」役のクローン）が GitHub に push した変更を、手元に取り込みたいとき。チーム開発では、作業を始める前に必ず行います。

**Git Bash**：

```bash
git switch main
git pull
```

取り込むものがあった場合：

```text
Updating a1b2c3d..e4f5a6b
Fast-forward
 schedule.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

何もなかった場合：

```text
Already up to date.
```

手元にも新しいコミットがあった場合は、マージコミットが作られます。このときコミットメッセージを書くエディタ（VS Code のタブ）が開くことがあります。内容はそのままでよいので、タブを閉じると pull が完了します。

**VS Code**：ソース管理ビューの「変更の同期（Sync Changes）」ボタン、またはステータスバーの ↑↓ の数字をクリックします（pull と push をまとめて行います）。pull だけしたいときは「…」→「プル（Pull）」を選びます。

**注意点**：

- `git pull` は「`git fetch`（取得）＋ `git merge`（取り込み）」です。違いは [remote-06](#remote-06) を見てください。
- 編集中（コミットしていない）のファイルと同じファイルが GitHub 側で変わっていると、`Your local changes to the following files would be overwritten by merge` と出て止まります → [trouble-05](troubleshooting.md#trouble-05)。
- `fatal: Need to specify how to reconcile divergent branches.` と出たら、1日目の `pull.rebase` の設定が入っていません → [trouble-08](troubleshooting.md#trouble-08)。
- 手元と GitHub の両方で同じ行を変えていると、コンフリクトになります → [branch-06](branch.md#branch-06)。
- 作業用ブランチに `main` の最新を取り込みたいときは [branch-08](branch.md#branch-08) を見てください。

**関連**：[8日目](../docs/day08-remote-github.md)、[10日目（手元の main を最新にする）](../docs/day10-pull-request.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="remote-06"></a>
## remote-06 取り込む前に、何が変わったかを確認したい（fetch）

**こんなとき**：GitHub の変更をいきなり取り込むのが不安なので、まず何が増えたかを見てから取り込みたいとき。他の人がどんなブランチを push したかを知りたいとき。

**Git Bash**：

```bash
git fetch
git log --oneline --graph --all
```

```text
* e4f5a6b (origin/main) クローン側で趣味を追加
* a1b2c3d (HEAD -> main) 自己紹介に目標を追加
* 9f8e7d6 最初のコミット
```

（ハッシュ値とメッセージは人によって違います。）

`origin/main`（手元に記録された「GitHub の `main` の位置」）が、手元の `main` より先に進んでいるのがわかります。変更内容を確かめるには次のようにします。

```bash
git diff main origin/main
git status
```

`git status` では `Your branch is behind 'origin/main' by 1 commit, and can be fast-forwarded.` のように、何コミット遅れているかが表示されます。内容に問題がなければ取り込みます。

```bash
git merge origin/main
```

（`git fetch` → `git merge origin/main` は、`git pull` とほぼ同じ結果になります。）

**VS Code**：ソース管理ビューの「…」→「フェッチ（Fetch）」を選びます。フェッチのあと、ステータスバーの ↓ の数字が「取り込んでいないコミットの数」です。履歴は、ソース管理ビューの「グラフ（Graph）」欄で `origin/main` の位置を確認できます（執筆時点の VS Code）。

**注意点**：

- `git fetch` は **取得するだけ** で、手元のファイルやブランチは変わりません。何度実行しても安全です。
- GitHub で削除されたブランチが `git branch -r` に残り続けるときは、`git fetch --prune` で手元の記録も消せます（[branch-04](branch.md#branch-04)）。

**関連**：[8日目（fetch と pull の違い）](../docs/day08-remote-github.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="remote-07"></a>
## remote-07 他の人のブランチ（PR）を手元で確かめたい

**こんなとき**：レビューする PR の内容を、自分のパソコンの VS Code で開いてプレビュー表示したいとき（11日目の任意課題）。

**Git Bash**：PR のページの上部に「`… wants to merge 1 commit into main from hydr4/write-page`」のように、PR のブランチ名が表示されています。そのブランチ名を使います。

```bash
git fetch
git switch hydr4/write-page
```

```text
branch 'hydr4/write-page' set up to track 'origin/hydr4/write-page'.
Switched to a new branch 'hydr4/write-page'
```

（`hydr4/write-page` は例です。実際の PR のブランチ名に置き換えてください。）

GitHub 上のブランチ `origin/hydr4/write-page` をもとに、同じ名前の手元のブランチが自動で作られ、切り替わります。確認が終わったら自分のブランチや `main` に戻り、不要になった手元のブランチは削除します。

```bash
git switch main
git branch -d hydr4/write-page
```

PR がまだマージされていないと、次のような warning が出ます。最後の行に `Deleted branch` と出ていれば、削除できています。

```text
warning: deleting branch 'hydr4/write-page' that has been merged to
         'refs/remotes/origin/hydr4/write-page', but not yet merged to HEAD
Deleted branch hydr4/write-page (was 1a2b3c4).
```

PR に新しいコミットが追加されたあとで見直すときは、そのブランチで `git pull` します。

**VS Code**：ステータスバー左下のブランチ名をクリック（またはコマンドパレット「Git: チェックアウト先...（Git: Checkout to...）」）→ 一覧から `origin/hydr4/write-page` を選びます。同じ名前の手元のブランチが作られて切り替わります。一覧に出ないときは、先に「…」→「フェッチ（Fetch）」を実行します。

**注意点**：

- `git switch origin/hydr4/write-page` のように `origin/` を付けると、次のエラーになります。`origin/` を外して実行してください。

  ```text
  fatal: a branch is expected, got remote branch 'origin/hydr4/write-page'
  ```

- 古い書き方の `git checkout origin/hydr4/write-page` を実行すると、`You are in 'detached HEAD' state.`（HEAD がブランチではなくコミットを直接指している状態）と表示されます。見るだけなら害はありませんが、この状態でコミットすると、どのブランチにも属さないコミットになります。`git switch -` で元のブランチに戻り、上の手順でやり直してください。くわしくは [Appendix：ブランチとマージ](../appendix/branches-and-merge.md) を見てください。
- 他の人のブランチは **見るだけ** にし、勝手にコミットして push しないでください。直してほしい点はレビューのコメントや修正提案（[github-07](github.md#github-07)）で伝えます。
- 未コミットの変更があると切り替えられないことがあります → [branch-03](branch.md#branch-03)。

**関連**：[11日目（他の人のブランチを手元で確かめる）](../docs/day11-code-review.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)
