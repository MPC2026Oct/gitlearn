# レシピ集：エラーメッセージ別のトラブル対応

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

画面に出たメッセージから引けるレシピです。**メッセージの英語の一部**（例：`rejected`、`not a git repository`）で、このページを `Ctrl+F` で検索してください。

> [!NOTE]
> 表示されるメッセージは、Git のバージョンや環境によって少し違うことがあります。また、設定によってはメッセージが日本語で表示されることもあります。そのときは、英語のキーワード（`fatal`、`rejected` など）や、レシピのタイトルの日本語で探してください。メッセージ例の中のハッシュ値・ユーザー名・URL は人によって違います。

> [!TIP]
> エラーが出たら、まず **落ち着いて `git status` を実行** しましょう。今どのブランチにいて、何が起きている途中なのか（マージ中など）がわかり、次にやるべきことのヒント（`(use "git ..." to ...)`）も表示されます。

| ID                        | メッセージ・症状                                                        |
| ------------------------- | ----------------------------------------------------------------------- |
| [trouble-01](#trouble-01) | `git: command not found`（または「'git' は…認識されていません」）と出る |
| [trouble-02](#trouble-02) | `Author identity unknown` と出てコミットできない                        |
| [trouble-03](#trouble-03) | `fatal: not a git repository` と出る                                    |
| [trouble-04](#trouble-04) | push すると `! [rejected]`（`fetch first` / `non-fast-forward`）と出る  |
| [trouble-05](#trouble-05) | `Your local changes to the following files would be overwritten` と出る |
| [trouble-06](#trouble-06) | `Authentication failed` や `403` で clone・push できない                |
| [trouble-07](#trouble-07) | `error: src refspec main does not match any` と出る                     |
| [trouble-08](#trouble-08) | `Need to specify how to reconcile divergent branches` と出る            |
| [trouble-09](#trouble-09) | `git log` などの画面から抜けられない（`:` や `(END)` が出ている）       |
| [trouble-10](#trouble-10) | コミットや pull の途中で見慣れないエディタ（Vim）が開いた               |
| [trouble-11](#trouble-11) | `LF will be replaced by CRLF` という警告が出る                          |
| [trouble-12](#trouble-12) | `GH007: Your push would publish a private email address` と出る         |

---

<a id="trouble-01"></a>
## trouble-01 `git: command not found`（または「'git' は…認識されていません」）と出る

**こんなとき**：`git --version` などを実行すると、次のどれかが表示される。

```text
bash: git: command not found
```

```text
git : 用語 'git' は、コマンドレット、関数、スクリプト ファイル、または操作可能なプログラムの名前として認識されません。
```

```text
'git' は、内部コマンドまたは外部コマンド、
操作可能なプログラムまたはバッチ ファイルとして認識されていません。
```

2つ目は PowerShell、3つ目はコマンドプロンプトで実行したときのメッセージです。

**原因**：Git for Windows がインストールされていないか、インストール前から開いていた VS Code が、新しく追加された Git の場所（PATH）をまだ知らないことが多いです。また、ターミナルが Git Bash ではなく PowerShell になっていることもあります。

**Git Bash**：対処の順番は次のとおりです。

1. VS Code を **すべてのウィンドウを閉じて** 起動し直し、ターミナルを開き直します（いちばん多い原因です）。
2. ターミナルの右上の「＋」の横の「∨」を押し、「Git Bash」を選んで開きます。開けたら次を実行します。

   ```bash
   git --version
   ```

   ```text
   git version 2.xx.x.windows.1
   ```

3. 「Git Bash」が一覧にない、またはまだ同じエラーになる場合は、Git for Windows がインストールされていません。1日目の手順でインストールし、パソコンを再起動してから VS Code を開きます。

**VS Code**：既定のターミナルを Git Bash にする方法は [setup-04](setup.md#setup-04) を見てください。

**注意点**：

- Windows の「スタート」メニューに「Git Bash」があれば、Git はインストールされています。その場合は VS Code の再起動か、既定のターミナルの設定を確認してください。
- この教材のコマンドは Git Bash 用です。PowerShell では動かないコマンドもあります。

**関連**：[1日目](../docs/day01-install-git.md)、[setup-01](setup.md#setup-01)、[setup-04](setup.md#setup-04)、[Appendix：Git Bash の基本](../appendix/git-bash-basics.md)

---

<a id="trouble-02"></a>
## trouble-02 `Author identity unknown` と出てコミットできない

**こんなとき**：`git commit` を実行すると、次のように表示されてコミットできない。

```text
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'xxxx@DESKTOP-XXXX.(none)')
```

VS Code では「Git でコミットを実行する前に、ユーザー名とメールアドレスを構成してください」のような通知が出ます。

**原因**：コミットに記録する名前とメールアドレスが設定されていません（1日目の設定がされていない、または別のパソコンやユーザーで作業している）。

**Git Bash**：名前とメールアドレスを設定してから、もう一度コミットします。メールアドレスは、2日目で確認した GitHub の noreply アドレス（`ID+ユーザー名@users.noreply.github.com` の形）を使います。

```bash
git config --global user.name "表示したい名前"
git config --global user.email "GitHubのnoreplyアドレス"
git config --global --list
```

`"..."` の中を自分の内容に書き換えてから実行します。最後のコマンドで `user.name=...` と `user.email=...` が表示されれば設定できています。そのあと、もう一度 `git commit` を実行します（`git add` はやり直さなくて大丈夫です）。

**VS Code**：GUI での設定はありません。ターミナルで上のコマンドを実行してから、ソース管理ビューでもう一度コミットします。

**注意点**：

- 設定した名前とメールアドレスはコミットに記録され、GitHub に push すると公開されます。本名や個人のメールアドレスを出したくない場合は、ニックネームと noreply アドレスを使ってください。
- 設定の確認・変更の詳細は [setup-02](setup.md#setup-02) を見てください。

**関連**：[1日目](../docs/day01-install-git.md)、[2日目](../docs/day02-github-account.md)、[3日目](../docs/day03-first-commit.md)、[Appendix：Git の設定](../appendix/git-config.md)

---

<a id="trouble-03"></a>
## trouble-03 `fatal: not a git repository` と出る

**こんなとき**：`git status` などを実行すると、次のように表示される。

```text
fatal: not a git repository (or any of the parent directories): .git
```

**原因**：今いるフォルダが Git のリポジトリではありません。ほとんどの場合、`cd` でリポジトリのフォルダに移動し忘れています。

**Git Bash**：

1. 今いる場所を確かめます。

   ```bash
   pwd
   ```

   ```text
   /c/Users/<Windowsのユーザー名>
   ```

2. 作業したいリポジトリのフォルダへ移動します（例：`my-profile`）。

   ```bash
   cd ~/git-practice/my-profile
   git status
   ```

3. それでも同じエラーなら、そのフォルダはまだリポジトリになっていません。新しく管理を始めるフォルダなら `git init` します（[basics-01](basics.md#basics-01)）。

**VS Code**：VS Code で開いているフォルダが違うと、ソース管理ビューに「フォルダーにGitリポジトリが含まれていません」のような表示が出ます。「ファイル（File）」→「フォルダーを開く（Open Folder）」で、`~/git-practice/my-profile` などのリポジトリのフォルダを開き直します。

**注意点**：

- `~/git-practice` そのものはリポジトリではありません。その中の `my-profile` や `gitlearn` がリポジトリです。
- `gitlearn` の中で `git init` しないでください（リポジトリの入れ子になります）。
- `ls -a` で `.git` フォルダがあるかを見ると、リポジトリかどうか確かめられます。

**関連**：[3日目](../docs/day03-first-commit.md)、[Appendix：Git Bash の基本](../appendix/git-bash-basics.md)

---

<a id="trouble-04"></a>
## trouble-04 push すると `! [rejected]`（`fetch first` / `non-fast-forward`）と出る

**こんなとき**：`git push` すると、次のどちらかが表示されて push できない。

```text
To https://github.com/<GitHubユーザー名>/my-profile.git
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'https://github.com/<GitHubユーザー名>/my-profile.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. This is usually caused by another repository pushing to
hint: the same ref. If you want to integrate the remote changes, use
hint: 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

```text
To https://github.com/<GitHubユーザー名>/my-profile.git
 ! [rejected]        main -> main (non-fast-forward)
error: failed to push some refs to 'https://github.com/<GitHubユーザー名>/my-profile.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. If you want to integrate the remote changes,
hint: use 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

**原因**：GitHub 側に、手元にないコミットがあります（他の人や、別の場所のクローン、GitHub 上での編集・修正提案の取り込みによるもの）。そのまま push すると GitHub 側のコミットが消えてしまうので、Git が止めてくれています。`fetch first` は「GitHub 側の新しいコミットをまだ取得していない」、`non-fast-forward` は「取得はしたが、まだ取り込んでいない」という違いで、対処は同じです。

**Git Bash**：GitHub の変更を取り込んでから、もう一度 push します。

```bash
git pull
git push
```

- `git pull` のときにエディタ（VS Code のタブ）が開いたら、マージコミットのメッセージです。そのままタブを閉じれば続きます。
- `CONFLICT` と出たらコンフリクトです。解決して `git add` → `git commit` してから `git push` します（[branch-06](branch.md#branch-06)）。
- `Need to specify how to reconcile divergent branches` と出たら [trouble-08](#trouble-08) を見てください。

**VS Code**：「変更の同期（Sync Changes）」ボタンを押すと、pull してから push します。

**注意点**：

- `git push --force`（強制 push）で押し切らないでください。GitHub 上の他の人のコミットが消えます。
- 自分の作業ブランチで、GitHub 上の **Commit suggestion** や **Resolve conflicts** を使ったあとにも起きます。そのブランチで `git pull` してから作業を続けましょう。
- チームで `main` に push しようとして拒否された場合は、そもそも `main` に直接 push しないルールです。作業内容をブランチに移す方法は [branch-07](branch.md#branch-07) を見てください。

**関連**：[8日目（push が拒否される体験）](../docs/day08-remote-github.md)、[remote-05](remote.md#remote-05)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="trouble-05"></a>
## trouble-05 `Your local changes to the following files would be overwritten` と出る

**こんなとき**：`git pull`、`git merge`、`git switch` を実行すると、次のように表示されて止まる。

```text
error: Your local changes to the following files would be overwritten by merge:
	schedule.md
Please commit your changes or stash them before you merge.
Aborting
```

`git switch` のときは次のように表示されます。

```text
error: Your local changes to the following files would be overwritten by checkout:
	profile.md
Please commit your changes or stash them before you switch branches.
Aborting
```

**原因**：まだコミットしていない編集があり、そのファイルが取り込み（または切り替え）によって書き換えられてしまうため、Git が止めています。何も壊れていません。

**Git Bash**：まず `git status` で、どのファイルが変更中かを確かめます。そのうえで、次のどれかを選びます。

1. **変更を残したい → コミットしてから実行する**（いちばん安全）

   ```bash
   git add schedule.md
   git commit -m "日程の案を追加"
   git pull
   ```

2. **変更を一時的によけておきたい → stash（退避）してから実行し、戻す**

   ```bash
   git stash
   git pull
   git stash pop
   ```

   `git stash pop` でコンフリクトした場合は、解決してから `git add` します（詳しくは [undo-07](undo.md#undo-07)）。

3. **変更はいらない → 取り消してから実行する**（変更は消えます）

   ```bash
   git restore schedule.md
   git pull
   ```

ファイル名（`schedule.md` など）は、メッセージに表示されたものに置き換えてください。

**VS Code**：ソース管理ビューで、変更をコミットするか、「…」→「スタッシュ（Stash）」→「スタッシュ（Stash）」で退避してから、もう一度「変更の同期（Sync Changes）」などを実行します。いらない変更は、ファイルにマウスを乗せて「変更を破棄（Discard Changes）」を押します。

**注意点**：

- 3の `git restore` で取り消した変更は元に戻せません。迷ったら1か2を選んでください。
- チームで作業するときは、作業を始める前に `git switch main` → `git pull` で最新にしておくと、このエラーを防げます。
- ブランチを切り替えられないときの詳細は [branch-03](branch.md#branch-03) を見てください。

**関連**：[12日目](../docs/day12-team-conflict.md)、[branch-03](branch.md#branch-03)、[undo-01](undo.md#undo-01)、[undo-07](undo.md#undo-07)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="trouble-06"></a>
## trouble-06 `Authentication failed` や `403` で clone・push できない

**こんなとき**：clone・push・pull で、次のようなメッセージが表示される。

**A. パスワードで認証しようとした**

```text
remote: Support for password authentication was removed on August 13, 2021.
remote: Please see https://docs.github.com/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls for information on currently recommended modes of authentication.
fatal: Authentication failed for 'https://github.com/<GitHubユーザー名>/gitlearn.git/'
```

**B. 権限がない（別のアカウントで認証している、招待を承認していない）**

```text
remote: Permission to <運営者のアカウント>/gitlearn-team-a.git denied to someone-else.
fatal: unable to access 'https://github.com/<運営者のアカウント>/gitlearn-team-a.git/': The requested URL returned error: 403
```

**C. リポジトリが見つからない**

```text
remote: Repository not found.
fatal: repository 'https://github.com/<GitHubユーザー名>/gitlearn.git/' not found
```

**原因**：

- **A**：GitHub は、Git の操作でのパスワード認証を廃止しています。ターミナルで「Password:」と聞かれて GitHub のパスワードを入れると、このエラーになります。Git Credential Manager（GCM）のブラウザ認証を使う必要があります。
- **B**：認証には成功していますが、そのアカウントにはそのリポジトリへの書き込み権限がありません。`denied to` の後ろのユーザー名を見てください。自分のユーザー名でなければ **別のアカウントの認証情報が保存されています**。自分のユーザー名なら、**招待をまだ承認していない** ことが多いです。
- **C**：URL の打ち間違い、または Private リポジトリに権限のないアカウントでアクセスしています（GitHub は、権限のない人には Private リポジトリが「存在しない」ように見せます）。

**Git Bash**：

1. URL が正しいかを確かめます（ユーザー名・リポジトリ名のつづり）。

   ```bash
   git remote -v
   ```

   間違っていたら [remote-03](remote.md#remote-03) で直します。

2. チームリポジトリなら、招待を承認したかを確かめます（[github-02](github.md#github-02)）。
3. 保存されているアカウントが違う場合は、認証情報を削除して入れ直します（詳しい手順は [setup-05](setup.md#setup-05)）。GCM のコマンドで、保存されているアカウントの確認とサインアウトができます。`<...>` の部分は、かっこごと置き換えてから実行します。

   ```bash
   git credential-manager github list
   git credential-manager github logout <GitHubユーザー名>
   ```

   使えるコマンドは `git credential-manager github --help` で確認できます。コマンドが使えないときは、Windows の「資格情報マネージャー」→「Windows 資格情報」で `git:https://github.com` を削除します。

4. もう一度 clone・push すると、GCM の **Connect to GitHub** 画面が出ます。**Sign in with your browser** を選び、ブラウザで **正しいアカウント** にサインインしていることを確かめてから承認します。

**VS Code**：同期やクローンでエラーになったときは、通知の「出力を表示（Show Command Output）」で上のメッセージを確認できます。対処はターミナルで行います。

**注意点**：

- ブラウザで別の GitHub アカウントにサインインしたまま承認すると、そのアカウントが保存されてしまいます。承認の前に、ブラウザ右上のアイコンでアカウントを確かめましょう。
- GCM の画面が出ずに「Username for 'https://github.com':」と聞かれる場合は、Git for Windows が古いか、資格情報ヘルパーの設定が外れています。次のコマンドで、資格情報ヘルパーの設定を確認します（Git for Windows のインストーラーは、この設定を `--global` ではなく system 設定に書くため、`--global` だけを見ると何も表示されません）。

  ```bash
  git config --show-origin --get-all credential.helper
  ```

  `file:C:/Program Files/Git/etc/gitconfig    manager` のように `manager` が表示されれば OK です。何も表示されないときは、Git for Windows を最新版に更新してください（[setup-01](setup.md#setup-01)）。
- 個人アクセストークン（PAT）を使う方法もありますが、この教材では GCM のブラウザ認証を使います。詳しくは Appendix を見てください。
- パスワード、トークン、リカバリーコードは、質問するときにも貼り付けないでください。

**関連**：[2日目](../docs/day02-github-account.md)、[9日目](../docs/day09-team-kickoff.md)、[setup-05](setup.md#setup-05)、[Appendix：認証のしくみ](../appendix/authentication.md)、[GitHub Docs：Git に GitHub の認証情報をキャッシュする](https://docs.github.com/ja/get-started/git-basics/caching-your-github-credentials-in-git)

---

<a id="trouble-07"></a>
## trouble-07 `error: src refspec main does not match any` と出る

**こんなとき**：`git push -u origin main` を実行すると、次のように表示される。

```text
error: src refspec main does not match any
error: failed to push some refs to 'https://github.com/<GitHubユーザー名>/my-profile.git'
```

**原因**：手元に `main` という名前のブランチがありません。よくある原因は次の3つです。

1. まだ **コミットを1つもしていない**（コミットがないとブランチはできません）。
2. ブランチ名が `master` になっている（1日目の `init.defaultBranch main` を設定する前に `git init` した）。
3. ブランチ名を打ち間違えた（`mian` など）。

**Git Bash**：まず状態を確かめます。

```bash
git status
git branch
```

- `git status` に `No commits yet` と表示される → 原因1です。ファイルを `git add` して `git commit` してから、もう一度 push します。
- `git branch` に `* master` と表示される → 原因2です。ブランチ名を `main` に変えてから push します。

  ```bash
  git branch -M main
  git push -u origin main
  ```

- `git branch` に `* main` と表示される → 原因3です。コマンドのつづりを確かめてください。

**VS Code**：ステータスバー左下に今のブランチ名が表示されます。`master` になっていたら、コマンドパレット「Git: ブランチの名前変更（Git: Rename Branch）」で `main` に変更できます。

**注意点**：

- GitHub の空のリポジトリのページに表示されるコマンド例にも `git branch -M main` が含まれています。これは「ブランチ名を `main` にする」という意味です。
- 今後 `git init` で作るリポジトリが `main` になるように、`git config --global init.defaultBranch main` が設定されているか確かめておきましょう（[setup-02](setup.md#setup-02)）。

**関連**：[8日目](../docs/day08-remote-github.md)、[remote-02](remote.md#remote-02)、[Appendix：Git の設定](../appendix/git-config.md)

---

<a id="trouble-08"></a>
## trouble-08 `Need to specify how to reconcile divergent branches` と出る

**こんなとき**：`git pull` を実行すると、次のように表示されて止まる。

```text
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
hint:
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint:
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
fatal: Need to specify how to reconcile divergent branches.
```

**原因**：手元と GitHub の両方に、相手にないコミットがあります（divergent：分岐している）。このとき pull で「マージで合わせるか、rebase で合わせるか」を決める設定（`pull.rebase`）がないため、Git が止まっています。1日目の `git config --global pull.rebase false` が設定されていないときに起きます。

**Git Bash**：この教材ではマージで合わせる設定にそろえます。設定してから、もう一度 pull します。

```bash
git config --global pull.rebase false
git pull
```

```text
Merge made by the 'ort' strategy.
 profile.md | 1 +
 1 file changed, 1 insertion(+)
```

マージコミットのメッセージを書くエディタ（VS Code のタブ）が開いたら、そのまま閉じれば完了です。続けて `git push` します。

**VS Code**：GUI での設定はありません。ターミナルで設定してから、「変更の同期（Sync Changes）」をもう一度押します。

**注意点**：

- この設定は一度入れれば、以後すべてのリポジトリで有効です。
- 設定を変えずに、その1回だけ `git pull --no-rebase` で実行することもできます。
- `pull.rebase true`（rebase で合わせる）を選ぶ人もいますが、この勉強会では合わせて `false` にしてください。違いは [Appendix：rebase](../appendix/rebase.md) で説明しています。

**関連**：[1日目](../docs/day01-install-git.md)、[8日目（fetch と pull の違い）](../docs/day08-remote-github.md)、[Appendix：リモートと追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="trouble-09"></a>
## trouble-09 `git log` などの画面から抜けられない（`:` や `(END)` が出ている）

**こんなとき**：`git log`、`git diff`、`git branch` などを実行したら、画面の一番下に `:` や `(END)` が表示され、コマンドが入力できなくなった。

```text
commit a1b2c3d4e5f6...
Author: hydr4 <12345678+hydr4@users.noreply.github.com>
Date:   Mon Oct 12 21:00:00 2026 +0900

    自己紹介に趣味を追加
:
```

**原因**：出力が長いので、Git がページャー（pager：長い出力を1画面ずつ見せるプログラム。`less`）で表示しています。壊れたわけではありません。

**Git Bash**：キーボードの **`q`** を押すと抜けられます。

ページャーの中では次のキーが使えます。

| キー                          | 動き                             |
| ----------------------------- | -------------------------------- |
| `q`                           | 終了する                         |
| `Space` / `b`                 | 1画面進む／戻る                  |
| `↓` / `↑`（または `j` / `k`） | 1行進む／戻る                    |
| `/文字` → `Enter`             | 文字を検索する（`n` で次を検索） |

短く表示したいときは、件数を指定します。

```bash
git log --oneline -5
```

**VS Code**：GUI での操作はありません。ターミナルをクリックしてから `q` を押してください。

**注意点**：

- `q` が効かないときは、ターミナルにカーソルがあるか確かめます（ターミナルの中をクリック）。日本語入力（IME）がオンだと `q` が入力されないので、オフにしてください。
- `Ctrl+C` を押してもよいですが、ページャーは `q` で終わるのが基本です。

**関連**：[3日目（git log で履歴を見る）](../docs/day03-first-commit.md)、[Appendix：Git Bash の基本](../appendix/git-bash-basics.md)

---

<a id="trouble-10"></a>
## trouble-10 コミットや pull の途中で見慣れないエディタ（Vim）が開いた

**こんなとき**：`git commit`（`-m` なし）、`git merge`、`git pull` の途中で、ターミナルが次のような画面に変わり、文字を入力しても思うように動かない。

```text
Merge branch 'main' of https://github.com/<GitHubユーザー名>/my-profile
# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
~
~
".git/MERGE_MSG" 7L, 293B
```

**原因**：コミットメッセージを書くエディタが、VS Code ではなく Vim（ターミナルで動くエディタ）になっています。1日目の `core.editor` の設定がされていない場合に起きます。

**Git Bash（Vim の中での操作）**：

1. **`Esc`** キーを押します（入力モードを抜けます）。
2. 半角で **`:wq`** と入力して **`Enter`** を押します（保存して終了）。表示されているメッセージでコミット（マージ）が完了します。

自分でメッセージを書きたいとき（`git commit` で開いた場合）は、次のようにします。

1. **`i`** を押します（左下に `-- INSERT --` と表示され、入力できるようになります）。
2. 1行目にメッセージを入力します。
3. **`Esc`** を押し、**`:wq`** → **`Enter`** で保存して終了します。

`git commit` で開いたコミットをやめたいときは、`Esc` → **`:cq`** → `Enter` で、エラー扱いで終了します（コミットは中止されます）。pull やマージで開いた場合は、`:wq` で完了させるのが簡単です。

再発を防ぐため、エディタを VS Code に設定します。

```bash
git config --global core.editor "code --wait"
```

**VS Code**：`core.editor` を設定すると、以後は VS Code に `COMMIT_EDITMSG` や `MERGE_MSG` というタブが開きます。ターミナルには次のように表示され、待っている状態になります。

```text
hint: Waiting for your editor to close the file...
```

メッセージを確かめて（必要なら書き換えて）`Ctrl+S` で保存し、**タブを閉じる** とコミットが完了します。詳しくは [setup-03](setup.md#setup-03) を見てください。

**注意点**：

- 日本語入力（IME）がオンだと `:wq` が入力できません。半角英数に切り替えてください。
- `#` で始まる行は説明なので、メッセージには含まれません。
- `-m "メッセージ"` を付けてコミットすれば、エディタは開きません。

**関連**：[1日目（ブランチ名とエディタ）](../docs/day01-install-git.md)、[7日目](../docs/day07-merge-conflict.md)、[setup-03](setup.md#setup-03)、[Appendix：Git の設定](../appendix/git-config.md)

---

<a id="trouble-11"></a>
## trouble-11 `LF will be replaced by CRLF` という警告が出る

**こんなとき**：`git add` を実行すると、次のような警告（warning）が表示される。

```text
warning: in the working copy of 'hobbies.md', LF will be replaced by CRLF the next time Git touches it
```

古い Git では、次のように表示されます。

```text
warning: LF will be replaced by CRLF in hobbies.md.
The file will have its original line endings in your working directory
```

**原因**：改行コード（行の終わりを表す見えない文字）は、Windows では CRLF、macOS や Linux では LF が一般的です。1日目のインストールで「Checkout Windows-style, commit Unix-style」（`core.autocrlf=true`）を選んだので、Git は「リポジトリには LF で保存し、取り出すときは CRLF にする」と自動で変換します。この警告は「次に Git がこのファイルを書き出すとき、改行を CRLF にします」というお知らせです。

**Git Bash**：**対処は不要です。** `warning` なので、`git add` は成功しています。`git status` で確かめましょう。

```bash
git status
```

ファイルが「Changes to be committed」に入っていれば、そのままコミットして大丈夫です。

**VS Code**：VS Code の右下のステータスバーに、そのファイルの改行コード（`LF` または `CRLF`）が表示されます。クリックすると切り替えられますが、この教材では変更しなくてかまいません。

**注意点**：

- この教材のリポジトリには、改行の扱いを決める `.gitattributes` が入っています。チームのメンバーが Windows と Mac で混ざっていても、リポジトリの中は LF にそろいます。
- 警告は `error` や `fatal` ではありません。`warning` で始まるメッセージは、多くの場合そのまま進めて大丈夫です。
- 改行コードと文字コードのしくみは [Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md) で詳しく説明しています。

**関連**：[1日目（インストーラーの選択肢）](../docs/day01-install-git.md)、[4日目](../docs/day04-diff-log-ignore.md)、[Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md)

---

<a id="trouble-12"></a>
## trouble-12 `GH007: Your push would publish a private email address` と出る

**こんなとき**：`git push` すると、次のように表示されて push できない。

```text
remote: error: GH007: Your push would publish a private email address.
remote: You can make your email public or disable this protection by visiting:
remote: https://github.com/settings/emails
To https://github.com/<GitHubユーザー名>/my-profile.git
 ! [remote rejected] main -> main (push declined due to email privacy restrictions)
error: failed to push some refs to 'https://github.com/<GitHubユーザー名>/my-profile.git'
```

**原因**：GitHub の設定で「メールアドレスを公開しない」（**Keep my email addresses private** と **Block command line pushes that expose my email**）にしているのに、push しようとしたコミットに **個人のメールアドレス** が記録されています。2日目に `user.email` を noreply アドレスに変更する前にコミットした場合に起きます。GitHub はあなたのメールアドレスが公開されるのを防いでくれています。

**Git Bash**：

1. GitHub の **Settings** → **Emails** で、`ID+ユーザー名@users.noreply.github.com` の形の noreply アドレスを確認します。
2. Git のメールアドレスを noreply アドレスに変更します（`"..."` の中を自分の noreply アドレスに書き換えてから実行します）。

   ```bash
   git config --global user.email "GitHubのnoreplyアドレス"
   git config --global user.email
   ```

3. 直前のコミットの作者情報を、新しいメールアドレスで付け直します。

   ```bash
   git commit --amend --reset-author --no-edit
   ```

4. もう一度 push します。

   ```bash
   git push
   ```

GitHub は、push するときに **一番新しいコミット** の作者のメールアドレスを確認します。そのため、多くの場合は直前のコミットを付け直すだけで push できます。それでも同じエラーになる場合や、古いコミットのメールアドレスもすべて直したい場合は、運営者に相談してください。

**VS Code**：GUI での操作はありません。ターミナルで上のコマンドを実行してから、「変更の同期（Sync Changes）」を押します。

**注意点**：

- 設定の **Block command line pushes that expose my email** をオフにすれば push はできますが、メールアドレスが公開されてしまいます。オフにしないでください。
- `git commit --amend` はコミットを作り直す操作です。**まだ push していないコミット** にだけ使ってください（[undo-03](undo.md#undo-03)）。このエラーのときは push できていないので使って大丈夫です。
- `git log -1 --format="%an <%ae>"` で、直前のコミットに記録された名前とメールアドレスを確かめられます。

**関連**：[2日目（メールアドレスを公開しない設定にする）](../docs/day02-github-account.md)、[setup-02](setup.md#setup-02)、[undo-03](undo.md#undo-03)、[GitHub Docs：個人のメールアドレスを公開するコマンドラインのプッシュをブロックする](https://docs.github.com/ja/account-and-profile/how-tos/email-preferences/blocking-command-line-pushes-that-expose-your-personal-email-address)

---

## このページにないメッセージ

レシピの見出しにはありませんが、よく見かけるメッセージと、参考になるレシピです。

| メッセージ（一部）                                                            | 意味と参考になるレシピ                                                                                                                                                                                                         |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `You are in 'detached HEAD' state.`                                           | ブランチではなくコミットを直接見ている状態です。見るだけなら害はありません。`git switch -` か `git switch main` で戻ります → [remote-07](remote.md#remote-07)、[Appendix：ブランチとマージ](../appendix/branches-and-merge.md) |
| `fatal: a branch is expected, got remote branch 'origin/...'`                 | `git switch` に `origin/` を付けています。外して実行します → [remote-07](remote.md#remote-07)                                                                                                                                  |
| `CONFLICT (content): Merge conflict in ...`                                   | コンフリクトです → [branch-06](branch.md#branch-06)                                                                                                                                                                            |
| `fatal: The current branch ... has no upstream branch.`                       | そのブランチはまだ GitHub にありません。メッセージに表示された `git push --set-upstream origin ...` で送ります → [remote-04](remote.md#remote-04)                                                                              |
| `error: remote origin already exists.`                                        | `origin` はすでに登録済みです → [remote-03](remote.md#remote-03)                                                                                                                                                               |
| `fatal: refusing to merge unrelated histories`                                | GitHub 側で README などを追加してリポジトリを作ったときなどに出ます → [remote-02](remote.md#remote-02)                                                                                                                         |
| `fatal: destination path '...' already exists and is not an empty directory.` | クローン先に同じ名前のフォルダがあります → [remote-01](remote.md#remote-01)                                                                                                                                                    |
| `error: the branch '...' is not fully merged`                                 | マージしていないブランチを `-d` で消そうとしています → [branch-04](branch.md#branch-04)                                                                                                                                        |
