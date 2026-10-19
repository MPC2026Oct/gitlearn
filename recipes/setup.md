# レシピ集：初期設定・環境

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

Git のインストール、設定、VS Code のターミナル、GitHub の認証、作業フォルダについてのレシピです。

- [setup-01 Git のバージョンを確かめたい・最新版に更新したい](#setup-01)
- [setup-02 名前とメールアドレスの設定を確認・変更したい（どこで設定されたかも調べる）](#setup-02)
- [setup-03 コミットメッセージを書くエディタを VS Code にしたい](#setup-03)
- [setup-04 VS Code のターミナルを Git Bash にしたい](#setup-04)
- [setup-05 保存された GitHub の認証情報を消して入れ直したい（アカウントの切り替え）](#setup-05)
- [setup-06 日本語のファイル名が `"\343\201..."` のように表示されるのを直したい](#setup-06)
- [setup-07 練習用・作業用のフォルダはどこに作ればいい？（OneDrive を避ける）](#setup-07)

> [!NOTE]
> コマンドはすべて VS Code 内の Git Bash で実行します。`<...>` の部分があるコマンドは、かっこごと自分の値に置き換えてから実行してください。画面の説明は執筆時点（2026年10月）の表示です。

---

<a id="setup-01"></a>
## setup-01 Git のバージョンを確かめたい・最新版に更新したい

**こんなとき**：Git がちゃんとインストールされているか確かめたいとき。説明ページと表示が違うので、新しい版に更新したいとき。

**Git Bash**：

バージョンを確かめます。

```bash
git --version
```

```text
git version 2.56.0.windows.2
```

（数字は人によって違います。`git version` で始まる行が出れば、インストールできています。）

Git for Windows を最新版に更新します。新しい版があれば、ダウンロードしてインストールするか聞かれるので `y` を入力して Enter を押します。

```bash
git update-git-for-windows
```

すでに最新なら、更新は行われません。

**VS Code**：GUI での操作はありません。ターミナルで実行します。
コマンドを使わずに更新したい場合は、公式サイトの Windows 版ダウンロードページ（https://git-scm.com/install/windows）から最新のインストーラーをダウンロードして実行します。上書きインストールになり、1日目に入れた `git config --global` の設定はそのまま残ります。

**注意点**：

- 更新の前に、開いている Git Bash と VS Code を閉じておくと安全です（インストーラーが「使用中のファイルがある」と言って止まることがあります）。`git update-git-for-windows` を VS Code のターミナルから実行した場合は、インストーラーの画面が出たら VS Code を閉じてから進めてください。
- インストーラーの選択肢は、前回選んだものが初期値になります。迷ったら [1日目](../docs/day01-install-git.md) の推奨設定の表と見比べてください。
- `git: command not found` と出るときは、インストールされていないか、VS Code を再起動していません → [trouble-01](troubleshooting.md#trouble-01)

**関連**：[1日目](../docs/day01-install-git.md)、[trouble-01](troubleshooting.md#trouble-01)、出典：[Git for Windows のダウンロード（git-scm.com）](https://git-scm.com/install/windows)

---

<a id="setup-02"></a>
## setup-02 名前とメールアドレスの設定を確認・変更したい（どこで設定されたかも調べる）

**こんなとき**：コミットに記録される名前やメールアドレスを確認したいとき。GitHub の noreply アドレスに変えたいとき。設定したはずなのに違う値が使われていて、どこで設定されたのか知りたいとき。

**Git Bash**：

今の設定を確認します。

```bash
git config user.name
git config user.email
```

設定を変更します（`--global` は「このパソコンのすべてのリポジトリで使う設定」という意味です）。GitHub の **Settings** → **Emails** に表示された noreply アドレスを丸ごとコピーし、`"ここにnoreplyアドレスを貼り付け"` の部分に貼り付けてから実行します（`"` は残します。[2日目](../docs/day02-github-account.md)）。`"表示したい名前"` も自分の名前に書き換えます。

```bash
git config --global user.name "表示したい名前"
git config --global user.email "ここにnoreplyアドレスを貼り付け"
```

例：`git config --global user.email "12345678+hydr4@users.noreply.github.com"`（`12345678` と `hydr4` の部分は人によって違います。GitHub の画面に表示された自分のアドレスをそのままコピーしてください。）

どのファイルで設定されたかを調べます。`--show-origin` を付けると、値の前に設定ファイルの場所が表示されます。

```bash
git config --show-origin user.email
```

```text
file:C:/Users/hydr4/.gitconfig	12345678+hydr4@users.noreply.github.com
```

すべての設定を、場所付きで一覧表示することもできます。

```bash
git config --list --show-origin
```

一覧が長くて画面が `:` で止まったら、`q` を押すと抜けられます。

**VS Code**：GUI での設定画面はありません。ターミナルで実行します。
グローバル設定のファイルを VS Code で直接開いて見ることもできます。

```bash
code ~/.gitconfig
```

**注意点**：

- 設定には3つの階層があり、**リポジトリごとの設定（`.git/config`）がグローバル設定（`~/.gitconfig`）より優先** されます。`--show-origin` の結果に `.git/config` が出てきたら、そのリポジトリだけ別の値になっています。リポジトリの設定を消すには、そのリポジトリの中で `git config --unset user.email` を実行します。
- 設定を変えても、**すでに作ったコミットの名前・メールアドレスは変わりません**。変更後のコミットから新しい値が使われます。
- noreply アドレスに変えていないと、push のときに `GH007` エラーになることがあります → [trouble-12](troubleshooting.md#trouble-12)

**関連**：[1日目](../docs/day01-install-git.md)、[2日目](../docs/day02-github-account.md)、[Appendix：Git の設定](../appendix/git-config.md)、[trouble-02](troubleshooting.md#trouble-02)、[trouble-12](troubleshooting.md#trouble-12)

---

<a id="setup-03"></a>
## setup-03 コミットメッセージを書くエディタを VS Code にしたい

**こんなとき**：`git commit` を `-m` なしで実行したり、マージしたりしたときに、黒い画面の見慣れないエディタ（Vim）が開いて困ったとき。メッセージを VS Code で書きたいとき。

**Git Bash**：

```bash
git config --global core.editor "code --wait"
```

設定できたか確認します。

```bash
git config --global core.editor
```

```text
code --wait
```

試しに、何かをステージした状態で `-m` なしでコミットしてみます。

```bash
git commit
```

VS Code に `COMMIT_EDITMSG` というタブが開くので、1行目にメッセージを書いて **保存（`Ctrl+S`）し、タブを閉じます**。タブを閉じるとターミナルに戻り、コミットが完了します。

**VS Code**：GUI での設定画面はありません。ターミナルで実行します（ソース管理ビューからのコミットは、もともと VS Code のメッセージ欄を使うので、この設定は関係ありません）。

**注意点**：

- `--wait` を付け忘れると、エディタが開いた瞬間に「メッセージが空」と判断されてコミットが中止されます。
- `code: command not found` と出る場合は、VS Code のインストール時に「PATH への追加」が選ばれていません。VS Code を入れ直して PATH への追加にチェックを入れるか、Git Bash と VS Code を再起動してから試してください。
- タブを閉じずに放置すると、ターミナルは「待ち」のまま次のコマンドを受け付けません。コミットをやめたいときは、メッセージを空にして保存してからタブを閉じます。
- すでに Vim が開いてしまったときの抜け方 → [trouble-10](troubleshooting.md#trouble-10)

**関連**：[1日目](../docs/day01-install-git.md)、[3日目](../docs/day03-first-commit.md)、[Appendix：Git の設定](../appendix/git-config.md)、[trouble-10](troubleshooting.md#trouble-10)

---

<a id="setup-04"></a>
## setup-04 VS Code のターミナルを Git Bash にしたい

**こんなとき**：VS Code でターミナルを開くと PowerShell（プロンプトが `PS C:\...>`）になってしまい、この教材のコマンドが動かないとき。

**Git Bash**：Git Bash 側で行う操作はありません。VS Code の設定で切り替えます。
切り替えたあと、ターミナルの行に `MINGW64`（Git for Windows のバージョンによっては `UCRT64`）と表示され、プロンプトが `$` で終わっていれば Git Bash です。

```text
taro@MY-PC MINGW64 ~
$
```

**VS Code**：

1. `Ctrl+Shift+P` でコマンドパレットを開きます。
2. `既定のプロファイル` と入力し、「ターミナル: 既定のプロファイルの選択（Terminal: Select Default Profile）」を選びます。
3. 一覧から **Git Bash** を選びます。
4. 今開いているターミナルを閉じます（ターミナル右上のごみ箱アイコン「ターミナルの強制終了（Kill Terminal）」）。
5. メニューの「ターミナル（Terminal）」→「新しいターミナル（New Terminal）」で開き直します（ショートカットは日本語キーボードで ``Ctrl+Shift+@``、英語キーボードで ``Ctrl+Shift+` ``）。

設定ファイル（`settings.json`）で指定する場合は、次の1行と同じ意味です。

```json
"terminal.integrated.defaultProfile.windows": "Git Bash"
```

**注意点**：

- 一覧に Git Bash が出てこないときは、Git for Windows がインストールされていないか、インストール後に VS Code を再起動していません。VS Code をすべて閉じて開き直してください。
- 既定を変えずに一度だけ Git Bash を開きたいときは、ターミナル右上の「＋」の横の「∨」から **Git Bash** を選びます。
- PowerShell のままコマンドを打つと、`~` の扱いなどが違って、この教材の説明どおりに動かないことがあります。

**関連**：[1日目](../docs/day01-install-git.md)、[Appendix：Git Bash の基本](../appendix/git-bash-basics.md)、出典：[VS Code ドキュメント Terminal Profiles](https://code.visualstudio.com/docs/terminal/profiles)

---

<a id="setup-05"></a>
## setup-05 保存された GitHub の認証情報を消して入れ直したい（アカウントの切り替え）

**こんなとき**：別の GitHub アカウント（共用パソコンの前の人のアカウントなど）でサインインしてしまい、自分のリポジトリに push すると `403` や `Permission denied` になるとき。認証をやり直したいとき。

**Git Bash**：

Git Credential Manager（GCM）が覚えている GitHub アカウントを確認します。

```bash
git credential-manager github list
```

覚えているアカウントからサインアウトします。`<GitHubユーザー名>` の部分は、かっこごと **上の一覧に出たアカウント名** に置き換えてから実行します。

```bash
git credential-manager github logout <GitHubユーザー名>
```

次に `git push` や `git clone` をすると、ブラウザでのサインイン画面がもう一度表示されます。ここで正しいアカウントでサインインし直します。

**VS Code**：GCM の情報を消す GUI は VS Code にはありません。代わりに Windows の画面から消せます。

1. Windows のスタートメニューで `資格情報マネージャー` と検索して開きます。
2. 「Windows 資格情報」を選びます。
3. 「汎用資格情報」の中の `git:https://github.com` を開きます（`git:https://<GitHubユーザー名>@github.com` のような項目があれば、それも同じように消します）。
4. 「削除」を選び、確認画面で「はい」を選びます。

あわせて、VS Code 自体の GitHub サインインも切り替える場合は、VS Code 左下の人型アイコン（アカウント）から GitHub のアカウントを選び、「サインアウト（Sign Out）」を選びます。

**注意点**：

- 消した後の最初の push・clone で、ブラウザに「Git Credential Manager」がアクセスを求めるページ（**Authorize git-ecosystem** などのボタン）が出ます。**今使いたいアカウントでサインインしているか**、ブラウザの右上を確認してから承認してください。ブラウザ側で別のアカウントにサインインしたままだと、そのアカウントが保存されます。
- GitHub のパスワードを Git Bash に直接入力する方式は使えません（GitHub は廃止済み）。ブラウザでの認証を使ってください。
- パスワードやトークン、リカバリーコードを人に見せたり、チャットに貼ったりしないでください。
- `Authentication failed` や `403` の対処全般 → [trouble-06](troubleshooting.md#trouble-06)

**関連**：[2日目](../docs/day02-github-account.md)、[Appendix：認証のしくみ](../appendix/authentication.md)、[trouble-06](troubleshooting.md#trouble-06)、出典：[Git Credential Manager：Multiple users](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/multiple-users.md)

---

<a id="setup-06"></a>
## setup-06 日本語のファイル名が `"\343\201..."` のように表示されるのを直したい

**こんなとき**：`git status` や `git log --stat` で、日本語のファイル名が次のように数字の列になってしまうとき。

```text
 M "\346\227\245\346\234\254\350\252\236.md"
```

**Git Bash**：

```bash
git config --global core.quotepath false
```

もう一度 `git status -s` を実行すると、日本語で表示されます。

```text
 M 日本語.md
```

**VS Code**：GUI での操作はありません。ターミナルで実行します（VS Code のソース管理ビューは、この設定と関係なく日本語のファイル名を正しく表示します）。

**注意点**：

- これは「表示のしかた」だけの設定です。ファイルやコミットの中身は変わりません。
- 1日目にこの設定を入れていれば起こりません。`git config --global core.quotepath` で `false` と表示されるか確認してください。
- 日本語のファイル名は、OS やツールによってトラブルの元になることがあります。チームで共有するファイルは英数字の名前にしておくと安心です。

**関連**：[1日目](../docs/day01-install-git.md)、[Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md)、[Appendix：Git の設定](../appendix/git-config.md)

---

<a id="setup-07"></a>
## setup-07 練習用・作業用のフォルダはどこに作ればいい？（OneDrive を避ける）

**こんなとき**：リポジトリをどこに置けばよいか迷ったとき。「ドキュメント」や「デスクトップ」に作ってしまい、ファイルが勝手に増えたり、ロックされたりして困ったとき。

**Git Bash**：

この教材では、ユーザーフォルダ直下の `git-practice`（`C:\Users\<Windowsのユーザー名>\git-practice`）にすべてのリポジトリを置きます。フォルダを作って移動します（すでにあっても `-p` を付けているのでエラーになりません）。

```bash
mkdir -p ~/git-practice
cd ~/git-practice
pwd
```

```text
/c/Users/hydr4/git-practice
```

（`taro` の部分は、人によって違います。）

今いる場所が OneDrive の中でないか確認するには、`pwd` の結果に `OneDrive` という文字が含まれていないかを見ます。

**VS Code**：

1. メニューの「ファイル（File）」→「フォルダーを開く（Open Folder）」を選びます。
2. `C:\Users\<Windowsのユーザー名>\git-practice` の中の、作業したいリポジトリのフォルダ（例：`my-profile`）を選んで開きます。
3. 左下やエクスプローラーのパス表示に `OneDrive` が含まれていないことを確認します。

**注意点**：

- 「ドキュメント」「デスクトップ」「ピクチャ」は、OneDrive のバックアップ（同期）の対象になっていることが多いです。同期中のファイルを Git が書き換えると、ファイルが二重になったり、`.git` フォルダが壊れたりすることがあります。
- すでに OneDrive の中にリポジトリを作ってしまった場合は、VS Code を閉じてから、エクスプローラーでフォルダごと `git-practice` に移動すれば、そのまま使えます（`.git` フォルダごと動かせば履歴も一緒に移ります）。
- リポジトリの中に別のリポジトリを作らないでください。たとえば `~/git-practice/gitlearn` の中で `git init` しないようにします。
- 置き場所の一覧は [README](../README.md) の「練習用フォルダの場所（全員共通）」を見てください。

**関連**：[1日目](../docs/day01-install-git.md)、[README](../README.md)、[Appendix：Git Bash の基本](../appendix/git-bash-basics.md)
