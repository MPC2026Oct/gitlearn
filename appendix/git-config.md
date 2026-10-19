# Git の設定（git config）のしくみ

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[1日目](../docs/day01-install-git.md)を読んだ人（2日目・8日目の内容にも少し触れます）
>
> **読む時間の目安**：25分

1日目では、`git config --global ...` で6つの設定を入れ、`git config --global --list` で確認しました。このページでは、その設定が **どこに保存され、どういう順番で効くのか**、そして1つ1つの設定が何をしているのかを説明します。

## このページでわかること

- 設定の3つの階層（system / global / local）と優先順位
- 「この設定はどこから来ているのか」を調べる方法（`--show-origin`）
- 設定ファイルの場所と中身
- 1日目に入れた6つの設定の意味
- よく使う追加の設定と、設定の消し方

---

<a id="three-levels"></a>
## 1. 設定の3つの階層

Git の設定は、1つのファイルにまとめて保存されているわけではありません。**適用される範囲が違う3つのファイル** に分かれています。

| 階層（スコープ） | 指定するオプション        | 対象                                     | Windows（Git for Windows）でのファイルの場所                                |
| ---------------- | ------------------------- | ---------------------------------------- | --------------------------------------------------------------------------- |
| system           | `--system`                | このパソコンの全ユーザー・全リポジトリ   | `C:\Program Files\Git\etc\gitconfig`                                        |
| global           | `--global`                | 自分（Windows のユーザー）の全リポジトリ | `C:\Users\<Windowsのユーザー名>\.gitconfig`（Git Bash では `~/.gitconfig`） |
| local            | `--local`（省略時の既定） | そのリポジトリだけ                       | リポジトリの中の `.git/config`                                              |

### 優先順位：近いものが勝つ

Git は **system → global → local の順に読み込み、同じ項目があれば後から読んだ値で上書き** します（出典：[git-config の FILES](https://git-scm.com/docs/git-config#FILES)）。つまり、範囲が狭い（リポジトリに近い）設定ほど優先されます。

```text
  弱い ─────────────────────────────────────────────▶ 強い

  system              global              local              コマンドの -c
  (Program Files)     (~/.gitconfig)      (.git/config)      (その1回だけ)
  ┌───────────┐       ┌───────────┐       ┌───────────┐      ┌───────────┐
  │ editor=A  │  ──▶  │ editor=B  │  ──▶  │           │ ──▶  │           │
  │ autocrlf  │       │ name=たいち│       │ name=hydr4│      │           │
  └───────────┘       └───────────┘       └───────────┘      └───────────┘

  結果：editor=B（global が system を上書き）
        name=hydr4（このリポジトリでは local が勝つ）
```

さらに、コマンドに `git -c 項目=値 コマンド` と書くと、**そのコマンド1回だけ** 最優先の設定を与えられます。

> [!NOTE]
> 1日目の `git config --global ...` は global に書き込みます。オプションを付けずに `git config user.name "..."` と書くと、**今いるリポジトリの local** に書き込まれます（リポジトリの外で実行するとエラーになります）。「設定したのに、ほかのリポジトリでは反映されない」というときは、local に書いてしまっていないか確かめてください。

### 補足：global のファイルはもう1か所ある

Git は、global の設定として `~/.gitconfig` のほかに `~/.config/git/config` も読みます。両方あれば両方を読みます。Git for Windows では、`~/.config/git/config` がない場合に `AppData` の下の `Git\config` を探すようになっています（出典：[Git for Windows リリースノート](https://github.com/git-for-windows/build-extra/blob/main/ReleaseNotes.md)）。この教材では `~/.gitconfig` だけを使います。

### 補足：昔の情報に注意

古い解説記事には「system の設定は `C:\ProgramData\Git\config` にもある」と書かれていることがあります。Git for Windows 2.24 からは system の設定は `C:\Program Files\Git\etc\gitconfig` の1か所にまとめられました（出典：同リリースノートの「Changes since Git for Windows v2.23.0」）。

---

<a id="show-origin"></a>
## 2. 「この設定はどこから？」を調べる

### すべての設定を、出どころと一緒に表示する

```bash
git config --list --show-origin --show-scope
```

- `--show-origin`：その値が書かれている **ファイル** を表示します。
- `--show-scope`：その値の **階層**（system / global / local / command）を表示します。

Windows で1日目・2日目を終えた人が、リポジトリの外（例：`~/git-practice`）で実行すると、次のような出力になります。

```text
system  file:C:/Program Files/Git/etc/gitconfig  core.autocrlf=true
system  file:C:/Program Files/Git/etc/gitconfig  core.fscache=true
system  file:C:/Program Files/Git/etc/gitconfig  core.symlinks=false
system  file:C:/Program Files/Git/etc/gitconfig  pull.rebase=false
system  file:C:/Program Files/Git/etc/gitconfig  credential.helper=manager
system  file:C:/Program Files/Git/etc/gitconfig  credential.https://dev.azure.com.usehttppath=true
system  file:C:/Program Files/Git/etc/gitconfig  init.defaultbranch=main
system  file:C:/Program Files/Git/etc/gitconfig  core.editor="C:\Users\hydr4\AppData\Local\Programs\Microsoft VS Code\Code.exe" --wait
global  file:C:/Users/hydr4/.gitconfig          user.name=たいち
global  file:C:/Users/hydr4/.gitconfig          user.email=12345678+hydr4@users.noreply.github.com
global  file:C:/Users/hydr4/.gitconfig          init.defaultbranch=main
global  file:C:/Users/hydr4/.gitconfig          core.editor=code --wait
global  file:C:/Users/hydr4/.gitconfig          core.quotepath=false
global  file:C:/Users/hydr4/.gitconfig          pull.rebase=false
```

（実際には区切りがタブで、system の行はほかにもあります。内容は Git のバージョンやインストール時の選択によって違います）

ここから次のことが読み取れます。

- **system の行は、Git for Windows のインストーラーが書いたもの** です。インストーラーの画面で選んだ内容が、ここに保存されています（例：改行コードの選択 → `core.autocrlf`、資格情報ヘルパーの選択 → `credential.helper`。出典：[インストーラーのソース install.iss](https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss)）。
- `core.editor` は system と global の両方にあります。**後から読まれる global の `code --wait` が使われます**。
- 項目名は小文字で表示されます（`init.defaultBranch` → `init.defaultbranch`）。Git の項目名は大文字・小文字を区別しないので、どちらで書いても同じです。

### 1つの項目だけ調べる

```bash
git config --show-origin --show-scope --get-all core.editor
```

```text
system  file:C:/Program Files/Git/etc/gitconfig  "C:\Users\hydr4\AppData\Local\Programs\Microsoft VS Code\Code.exe" --wait
global  file:C:/Users/hydr4/.gitconfig          code --wait
```

`--get-all` を付けると、すべての階層の値が出ます。付けなければ、**実際に使われる値（最後に読まれた値）だけ** が出ます。

```bash
git config --show-origin core.editor
```

```text
file:C:/Users/hydr4/.gitconfig  code --wait
```

> [!TIP]
> 「名前やメールアドレスが思ったものと違う」「改行コードの警告が出る」など、設定が原因かもしれないと思ったら、まず `--show-origin` で出どころを確かめるのが近道です。[レシピ setup-02](../recipes/setup.md#setup-02) も参照してください。

---

<a id="config-files"></a>
## 3. 設定ファイルの中身

### global の設定ファイルを見る

```bash
cat ~/.gitconfig
```

```text
[user]
	name = たいち
	email = 12345678+hydr4@users.noreply.github.com
[init]
	defaultBranch = main
[core]
	editor = code --wait
	quotepath = false
[pull]
	rebase = false
```

設定ファイルは、`[セクション]` の下に `項目 = 値` を並べたテキストファイルです。`git config --global core.editor "code --wait"` は「`[core]` セクションの `editor` を `code --wait` にする」という意味です。

### VS Code で設定ファイルを開く

```bash
git config --global --edit
```

`core.editor` が VS Code になっているので、VS Code のタブで `~/.gitconfig` が開きます。編集して保存し、**タブを閉じると** Git Bash に戻ります。

> [!WARNING]
> 直接編集するとき、`[` `]` や `=` を消してしまうと、Git がファイルを読めなくなり、すべての Git コマンドが `fatal: bad config line ...` で止まります。慣れないうちは `git config` コマンドで設定するほうが安全です。もし壊してしまったら、エラーメッセージに出ている行番号の行を VS Code で直してください。

### local の設定ファイル（.git/config）

リポジトリごとの設定は `.git/config` にあります。Git 自身も、いろいろな操作のときにここへ書き込みます。たとえば8日目まで進めた `my-profile` では次のようになっています。

```bash
cd ~/git-practice/my-profile
cat .git/config
```

```text
[core]
	repositoryformatversion = 0
	filemode = false
	bare = false
	logallrefupdates = true
	symlinks = false
	ignorecase = true
[remote "origin"]
	url = https://github.com/<GitHubユーザー名>/my-profile.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
	remote = origin
	merge = refs/heads/main
```

（`<GitHubユーザー名>` の部分には自分のユーザー名が入っています）

- `[core]` の部分は `git init` のときに Git が書いたものです。`filemode = false` と `ignorecase = true` は「Windows のファイルシステムでは、実行権限や大文字・小文字の区別を当てにしない」という意味で、Windows では自動でこうなります。
- `[remote "origin"]` は8日目の `git remote add origin ...` で書かれました。
- `[branch "main"]` は `git push -u origin main` の `-u` で書かれました（上流ブランチの設定。[リモート追跡ブランチ](remote-tracking.md)で詳しく説明します）。

つまり **`git remote add` も `push -u` も、実は「設定を書き込む」操作でもある** のです。

---

<a id="day1-settings"></a>
## 4. 1日目に入れた設定の意味

```bash
git config --global user.name "表示したい名前"
git config --global user.email "GitHubに登録する予定のメールアドレス"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
git config --global core.quotepath false
git config --global pull.rebase false
```

### user.name と user.email：コミットに書き込まれる「署名」

この2つは、**コミットを作るたびに、作者（author）とコミッター（committer）としてコミットの中に書き込まれます**。

```bash
cd ~/git-practice/my-profile
git log -1 --format="%an <%ae>"
```

```text
たいち <12345678+hydr4@users.noreply.github.com>
```

大事なポイントは次のとおりです。

- **ログインのための情報ではありません**。GitHub へのログイン（認証）は、これとはまったく別のしくみで行われます（[認証のしくみ](authentication.md)）。`user.name` に GitHub のユーザー名と違う名前を書いても、push はできます。
- GitHub は、コミットに書かれた **メールアドレス** を見て「どのアカウントのコミットか」を判断し、アイコンやプロフィールへのリンクを表示します。2日目に noreply アドレス（`ID+ユーザー名@users.noreply.github.com`）に変えたのは、本物のメールアドレスを公開しないためです（出典：[GitHub Docs - Setting your commit email address](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address)）。
- 設定を変えても、**すでに作ったコミットの名前やメールアドレスは変わりません**。コミットの中身として記録済みだからです（[Git の内部構造](git-internals.md#commit-object)）。
- GitHub で「メールアドレスを公開しない」設定にしていると、本物のアドレスが入ったコミットを push したときに拒否されることがあります（[レシピ trouble-12](../recipes/troubleshooting.md#trouble-12)）。

### init.defaultBranch main：最初のブランチの名前

`git init` で新しいリポジトリを作ったときの、最初のブランチの名前です。Git 本体は長いあいだ `master` を既定にしてきましたが、GitHub など多くのサービスは `main` を既定にしています。Git 3.0 では新しいリポジトリの既定が `main` になる予定です（出典：[Git の BreakingChanges](https://git-scm.com/docs/BreakingChanges)）。

- すでにあるリポジトリのブランチ名は変わりません。
- `git clone` したリポジトリのブランチ名は、この設定ではなく GitHub 側のリポジトリで決まります。

### core.editor "code --wait"：メッセージを書くエディタ

`git commit` を `-m` なしで実行したときや、マージコミットのメッセージを確認するときに開くエディタです。

`--wait` が大切です。

```text
--wait あり：  Git ──「code で開いて」──▶ VS Code（タブが開く）
               Git は待つ ……………………………… タブを閉じる
               Git ◀─────────「閉じた」────── 書いた内容でコミット

--wait なし：  Git ──「code で開いて」──▶ VS Code（タブが開く）
               Git はすぐに続きを実行 → メッセージが空なので中止
               「Aborting commit due to empty commit message.」
```

`code` コマンドは VS Code を開くとすぐに終わってしまうため、`--wait` を付けて「タブが閉じられるまで待つ」ようにしています。

Git がエディタを決める順番は、環境変数 `GIT_EDITOR` → `core.editor` → 環境変数 `VISUAL` → 環境変数 `EDITOR` → 何もなければ `vi`（Vim）です（出典：[git-var](https://git-scm.com/docs/git-var)）。見慣れない画面（Vim）が開いてしまったときは [レシピ trouble-10](../recipes/troubleshooting.md#trouble-10) を見てください。

### core.quotepath false：日本語のファイル名をそのまま表示する

これを設定しないと、`git status` で日本語のファイル名が `"\343\203\241\343\203\242.md"` のように表示されます。詳しくは [改行コードと文字コード](line-endings-and-encoding.md#quotepath) で説明します。

### pull.rebase false：pull で「マージ」を使う

`git pull` は「`git fetch`（取得）＋取り込み」の2段階で動きます。手元と GitHub の両方に新しいコミットがあるとき、取り込み方には「マージ（merge）」と「リベース（rebase）」の2通りがあり、`pull.rebase false` は **マージを使う** という指定です。

この設定がないと、Git のバージョンによっては `Need to specify how to reconcile divergent branches` というメッセージが出て pull が止まります（[レシピ trouble-08](../recipes/troubleshooting.md#trouble-08)）。意味は8日目で学びます。詳しくは [リモート追跡ブランチ](remote-tracking.md) と [rebase](rebase.md) を見てください。

---

<a id="useful-settings"></a>
## 5. よく使う追加の設定

本編では使いませんが、慣れてきたら便利な設定です。**本編の説明や出力例は、これらを設定していない前提で書かれている** ので、試すのは該当する日を終えてからにしてください。

| 設定                         | 何が変わるか                                                                | おすすめの時期 |
| ---------------------------- | --------------------------------------------------------------------------- | -------------- |
| `alias.<名前>`               | 長いコマンドに短い別名を付ける                                              | 4日目以降      |
| `merge.conflictStyle zdiff3` | コンフリクトのときに「元の内容」も表示する                                  | 7日目以降      |
| `fetch.prune true`           | `fetch` のときに、GitHub で消されたブランチの追跡ブランチを自動で消す       | 10日目以降     |
| `push.autoSetupRemote true`  | 新しいブランチを初めて push するとき、`-u origin <ブランチ名>` を省略できる | 10日目以降     |

### alias：別名を付ける

```bash
git config --global alias.lg "log --oneline --graph --all"
git config --global alias.st "status -sb"
```

これで `git lg` と打つと `git log --oneline --graph --all` が、`git st` と打つと短い形式の `git status` が実行されます。値にスペースが入るので、`"..."` で囲みます。

### merge.conflictStyle zdiff3：コンフリクトに「元の内容」を表示する

```bash
git config --global merge.conflictStyle zdiff3
```

コンフリクトマーカーの間に、`|||||||` で区切られた **分かれる前の元の内容** が入るようになります。「どちらが何を変えたのか」が判断しやすくなります（Git 2.35 以降。出典：[git-config の merge.conflictStyle](https://git-scm.com/docs/git-config#Documentation/git-config.txt-mergeconflictStyle)）。

```text
<<<<<<< HEAD
- 場所: 部室
||||||| 2a3b4c5
- 場所: 未定
=======
- 場所: 図書館
>>>>>>> change-place
```

7日目の本文は、この設定がない（標準の `merge` スタイル）前提で書かれています。詳しくは [ブランチとマージ](branches-and-merge.md) を見てください。

### fetch.prune true：消えたブランチの追跡ブランチを片付ける

```bash
git config --global fetch.prune true
```

GitHub でプルリクエスト（Pull Request、略して PR）をマージしてブランチを削除しても、手元の `origin/<ブランチ名>`（リモート追跡ブランチ）は残り続けます。この設定を入れると、`git fetch` や `git pull` のたびに自動で片付けられます（`git fetch --prune` と同じ）。詳しくは [リモート追跡ブランチ](remote-tracking.md) を見てください。

### push.autoSetupRemote true：-u を省略する

```bash
git config --global push.autoSetupRemote true
```

新しいブランチで初めて `git push` だけを実行したとき、自動で `git push -u origin <今のブランチ名>` と同じ動きをします。10日目の本文は `-u` を書く前提なので、**10日目を終えてから** 入れてください。

### 発展：フォルダによってメールアドレスを切り替える

学校用・個人用などでコミットのメールアドレスを分けたいときは、`includeIf` を使うと、特定のフォルダの下のリポジトリだけ別の設定ファイルを読み込ませられます。

```text
[includeIf "gitdir:~/school/"]
	path = ~/.gitconfig-school
```

このように `~/.gitconfig` に書き、`~/.gitconfig-school` に `[user]` の `email` を書きます（出典：[git-config の Conditional includes](https://git-scm.com/docs/git-config#_conditional_includes)）。この勉強会では必要ありません。

---

<a id="unset"></a>
## 6. 設定を確認する・消す・直す

### 1つの値を確認する

```bash
git config --global user.email
```

値だけが表示されます。何も表示されなければ、その階層には設定されていません。

### 値を変える

同じコマンドで値を指定し直せば上書きされます。

```bash
git config --global user.name "新しい名前"
```

### 設定を消す

```bash
git config --global --unset alias.st
```

`--unset` は、指定した階層から項目を1つ消します。間違えて local に書いてしまった設定を消すときは、そのリポジトリの中で次のようにします（`--local` は省略可）。

```bash
git config --local --unset user.name
```

セクションごと消したいときは `--remove-section` を使います（例：`git config --global --remove-section alias`）。

### 新しい書き方（Git 2.46 以降）

Git 2.46 から、`git config` に「サブコマンド」形式の新しい書き方が加わり、`--get` や `--unset` などの古い書き方は **非推奨（deprecated）** になりました（出典：[Git 2.46 リリースノート](https://github.com/git/git/blob/master/Documentation/RelNotes/2.46.0.adoc)、[git-config](https://git-scm.com/docs/git-config)）。古い書き方も引き続き動くので、この教材では本編・Appendix とも、ネット上の情報が多い従来の書き方を使っています。

| 従来の書き方                           | 新しい書き方                               |
| -------------------------------------- | ------------------------------------------ |
| `git config --global --list`           | `git config list --global`                 |
| `git config --global user.name`        | `git config get --global user.name`        |
| `git config --global user.name "名前"` | `git config set --global user.name "名前"` |
| `git config --global --unset alias.st` | `git config unset --global alias.st`       |
| `git config --global --edit`           | `git config edit --global`                 |

---

## 7. 試してみよう：local が global に勝つことを確かめる

`~/git-practice/appendix-lab/` の下に、使い捨てのリポジトリを作って試します。

1. 練習用のフォルダを作り、リポジトリにします。

   ```bash
   mkdir -p ~/git-practice/appendix-lab/config
   cd ~/git-practice/appendix-lab/config
   git init
   ```

2. このリポジトリだけの名前を local に設定します。

   ```bash
   git config user.name "ローカルの名前"
   ```

3. すべての階層の `user.name` を、出どころと一緒に表示します。

   ```bash
   git config --show-origin --show-scope --get-all user.name
   ```

   ```text
   global  file:C:/Users/hydr4/.gitconfig  たいち
   local   file:.git/config                 ローカルの名前
   ```

4. 実際に使われる値を表示します。後から読まれた local が勝っています。

   ```bash
   git config user.name
   ```

   ```text
   ローカルの名前
   ```

5. `-c` で、1回だけさらに上書きできることも確かめます。

   ```bash
   git -c user.name="一時的な名前" config user.name
   ```

   ```text
   一時的な名前
   ```

6. local の設定を消すと、global の値に戻ります。

   ```bash
   git config --unset user.name
   git config user.name
   ```

   ```text
   たいち
   ```

7. ホームフォルダに戻ります。

   ```bash
   cd
   ```

---

## まとめ

- 設定は system（パソコン全体）・global（自分）・local（リポジトリ）の3階層。後から読まれる local が最も強い。
- `git config --list --show-origin --show-scope` で、どの値がどのファイルから来ているかがわかる。
- system の設定は Git for Windows のインストーラーが書いている（`core.autocrlf`、`credential.helper` など）。
- `user.name` / `user.email` はコミットに書き込まれる署名で、ログイン情報ではない。
- `git remote add` や `git push -u` も、`.git/config` に設定を書き込んでいる。

## 関連ページ

- [1日目：Git のインストールと初期設定](../docs/day01-install-git.md)（「4. Git の初期設定をする」）
- [2日目：GitHub アカウントと認証](../docs/day02-github-account.md)（「2. メールアドレスを公開しない設定にする」）
- [8日目：GitHub とつなぐ](../docs/day08-remote-github.md)（「fetch と pull の違い」で `pull.rebase` を説明）
- [レシピ setup-02 名前とメールアドレスの設定を確認・変更したい](../recipes/setup.md#setup-02)
- [レシピ setup-03 コミットメッセージを書くエディタを VS Code にしたい](../recipes/setup.md#setup-03)
- [レシピ trouble-02 `Author identity unknown` と出てコミットできない](../recipes/troubleshooting.md#trouble-02)

## 参考資料

- git-config（公式リファレンス）：<https://git-scm.com/docs/git-config>
- Pro Git 日本語版「1.6 使い始める - 最初のGitの構成」：<https://git-scm.com/book/ja/v2/使い始める-最初のGitの構成>（Windows の system 設定の場所の記述は古い情報です）
- Git for Windows インストーラーのソース（どの選択肢がどの設定になるか）：<https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss>
- Git for Windows リリースノート：<https://github.com/git-for-windows/build-extra/blob/main/ReleaseNotes.md>
- GitHub Docs - Setting your commit email address：<https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address>

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
