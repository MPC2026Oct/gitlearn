# 1日目：Git のインストールと初期設定

[README（全体の地図）](../README.md) ｜ [2日目 →](day02-github-account.md)

> [!NOTE]
> 1日目は、まだ教材の「自分用のコピー」がありません。このページは **ブラウザで GitHub 上のテンプレートリポジトリを開いて** 読み進めてください。2日目からは、自分のパソコンの VS Code で教材を読めるようになります。

## この日のゴール

- Git for Windows をインストールできる
- VS Code のターミナルで Git Bash を開ける
- `git config` で初期設定ができ、`git config --global --list` で確認できる
- 練習用フォルダ `~/git-practice` を作れる

## 所要時間の目安

合計 **60〜90分**

| セクション                            | 目安     |
| ------------------------------------- | -------- |
| 1. Git とは何か                       | 10分     |
| 2. Git for Windows をインストールする | 20〜30分 |
| 3. VS Code で Git Bash を使う         | 15〜20分 |
| 4. Git の初期設定をする               | 10〜15分 |
| 5. 練習用フォルダを作る               | 5分      |
| 演習・確認                            | 5〜10分  |

## 前提

- Windows 11 のパソコンで、ソフトをインストールできること（管理者権限があると安心です）
- Visual Studio Code（以下 VS Code）がインストール済みであること
- インターネットにつながっていること
- このページをブラウザで読んでいること

---

## 1. Git とは何か

### バージョン管理とは

レポートや発表資料を作っていて、こんなファイルが増えてしまったことはありませんか？

```text
レポート.docx
レポート_修正.docx
レポート_最終版.docx
レポート_最終版_本当に最終.docx
レポート_最終版_本当に最終_先生コメント反映.docx
```

どれが最新なのか、どこを変えたのかがわからなくなり、「昨日の状態に戻したい」と思っても戻せません。

**バージョン管理** とは、ファイルの変更の歴史を記録しておき、

- いつ・誰が・何を変えたかを後から確かめる
- 好きな時点の状態に戻す
- 複数人の変更を安全にまとめる

ことができるようにするしくみです。**Git（ギット）** は、世界でいちばん使われているバージョン管理のソフトです。Git を使うと、ファイル名を変えて保存し直す必要はなくなり、フォルダの中はいつも最新の1つだけになります。過去の状態は Git がきちんと覚えてくれます。

### Git と GitHub の違い

名前が似ていますが、別のものです。

|                    | Git                                            | GitHub                                                         |
| ------------------ | ---------------------------------------------- | -------------------------------------------------------------- |
| 何か               | **ソフト**（自分のパソコンにインストールする） | **Web サービス**（ブラウザで使う）                             |
| 役割               | 手元のフォルダの変更履歴を記録する             | Git で記録した履歴をインターネット上に置き、ほかの人と共有する |
| たとえ             | 自分のノートに日記をつける道具                 | 日記を置いておく共有の本棚                                     |
| この勉強会で使う日 | 1日目から                                      | 2日目にアカウントを作り、8日目から本格的に使う                 |

Git だけでもひとりでの変更記録はできます。GitHub を組み合わせると、チームで同じファイルを安全に編集できるようになります。今日は **Git** を準備します。

---

## 2. Git for Windows をインストールする

Windows で Git を使うには **Git for Windows** をインストールします。Git 本体のほかに、**Git Bash**（ギット・バッシュ：Git を文字で操作するための画面）と、GitHub へのログイン情報を安全に保存する **Git Credential Manager（GCM）** が一緒に入ります。

### インストーラーをダウンロードする

1. ブラウザで Git の公式サイトのダウンロードページ <https://git-scm.com/install/windows> を開きます（トップページ <https://git-scm.com/> から「Install」→「Windows」と進んでも同じです）。
2. **Git for Windows/x64 Setup** のリンクをクリックして、インストーラーをダウンロードします。
   - 執筆時点の最新版は **2.56.0** で、ファイル名は `Git-2.56.0.2-64-bit.exe` のような形です。数字は時期によって変わります。
   - Surface Pro X など **ARM 版の Windows** を使っている人は **Git for Windows/ARM64 Setup** を選びます（わからなければ x64 で大丈夫です。ほとんどのパソコンは x64 です）。
3. ダウンロードしたファイル（「ダウンロード」フォルダにあります）をダブルクリックして起動します。
4. 「このアプリがデバイスに変更を加えることを許可しますか？」と表示されたら **はい** をクリックします。

> [!TIP]
> すでに Git が入っているかもしれない人は、インストール前に [インストールできたか確認する](#インストールできたか確認する) の手順で確かめてみてください。古いバージョンが入っている場合も、同じインストーラーで上書き（アップデート）できます。詳しくは [レシピ setup-01](../recipes/setup.md#setup-01) を見てください。

### インストーラーの選択肢

インストーラーでは、たくさんの画面で選択肢が出てきます。**ほとんどは既定（最初から選ばれている状態）のまま「Next」で進めて大丈夫** です。この勉強会で変えるのは、下の表で **太字** にした3か所だけです。

（画面の順番と文言は執筆時点の Git for Windows 2.56 のものです。出典は表の下に書いています。）

| 順番 | 画面のタイトル（英語）                                       | 選ぶもの                                                                                                 | 説明                                                                                                                                      |
| ---- | ------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | Information                                                  | **Next**                                                                                                 | ライセンス（利用条件）の表示です                                                                                                          |
| 2    | Select Destination Location                                  | 既定のまま                                                                                               | インストール先（`C:\Program Files\Git`）。表示されないこともあります                                                                      |
| 3    | Select Components                                            | 既定のまま                                                                                               | 追加機能の選択。既定で「Open Git Bash here」などにチェックが入っています                                                                  |
| 4    | Select Start Menu Folder                                     | 既定のまま                                                                                               | スタートメニューのフォルダ名。表示されないこともあります                                                                                  |
| 5    | Choosing the default editor used by Git                      | **Use Visual Studio Code as Git's default editor**                                                       | Git が文章の入力を求めるときに開くエディタ（文書を書くソフト）。既定は Vim（初心者には難しいエディタ）なので、**必ず VS Code に変えます** |
| 6    | Adjusting the name of the initial branch in new repositories | **Override the default branch name for new repositories** を選び、入力欄が `main` になっていることを確認 | 新しく作るリポジトリの最初のブランチ名。ブランチは6日目に学びます                                                                         |
| 7    | Adjusting your PATH environment                              | 既定のまま（Git from the command line and also from 3rd-party software）                                 | どこから Git を使えるようにするか                                                                                                         |
| 8    | Choosing the SSH executable                                  | 既定のまま（Use bundled OpenSSH）                                                                        | パソコンの状態によっては表示されません                                                                                                    |
| 9    | Choosing HTTPS transport backend                             | 既定のまま                                                                                               | 通信の暗号化に使うしくみ                                                                                                                  |
| 10   | Configuring the line ending conversions                      | **Checkout Windows-style, commit Unix-style line endings** が選ばれていることを確認                      | 改行コードの扱い。既定でこれが選ばれています。詳しくは [Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md)       |
| 11   | Configuring the terminal emulator to use with Git Bash       | 既定のまま（Use MinTTY）                                                                                 | 単独で開く Git Bash の画面の種類。この勉強会では VS Code の中で使うので、どちらでも影響しません                                           |
| 12   | Choose the default behavior of `git pull`                    | 既定のまま（Merge）                                                                                      | `pull` の動き。4.で自分でも設定します                                                                                                     |
| 13   | Choose a credential helper                                   | **Git Credential Manager** が選ばれていることを確認                                                      | GitHub へのログイン情報を安全に保存するしくみ。既定でこれが選ばれています。2日目に使います                                                |
| 14   | Configuring extra options                                    | 既定のまま                                                                                               | 高速化などの追加設定                                                                                                                      |
| 15   | Configuring experimental options                             | 何もチェックしない                                                                                       | 試験中の機能。表示されないこともあります                                                                                                  |

最後の画面で **Install** をクリックするとインストールが始まります。終わったら **Finish** をクリックします（「View Release Notes」のチェックは外しておいてかまいません）。

> [!NOTE]
> 出典：Git for Windows のインストーラーの定義ファイル（各画面のタイトル・選択肢・既定値が書かれています）
> <https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss>
> ダウンロードページ：<https://git-scm.com/install/windows>
> 画面の順番や文言は、Git for Windows のバージョンによって変わることがあります。表にない画面が出てきたら、既定のまま進めて大丈夫です。

> [!TIP]
> 5番目のエディタの画面で「Use Visual Studio Code as Git's default editor」を選んでも **Next が押せない（灰色）** 場合は、VS Code が見つかっていません。いったん既定のまま進めてかまいません。4. の初期設定で、エディタを VS Code にする設定を自分で入れます。

### インストールできたか確認する

インストールが終わったら、Git Bash を単独で開いて確かめます（VS Code の中で使う方法は次の 3. で説明します）。

1. スタートメニューを開き、「Git Bash」と入力して、表示された **Git Bash** をクリックします。黒い画面（ターミナル）が開きます。
2. 次のコマンドを入力（またはコピーして貼り付け）して、`Enter` キーを押します。単独の Git Bash の画面では、貼り付けは **右クリック → Paste** か `Shift+Insert` です。

```bash
git --version
```

次のように、`git version` に続けてバージョン番号が表示されれば成功です（数字は人によって違います）。

```text
git version 2.56.0.windows.2
```

3. 確認できたら、次のコマンドで Git Bash の画面を閉じます（右上の × で閉じてもかまいません）。

```bash
exit
```

`git: command not found` と表示された場合は、[よくあるつまずき](#よくあるつまずき) を見てください。

---

## 3. VS Code で Git Bash を使う

この勉強会では、Git のコマンドを **VS Code の中のターミナル** で入力します。ターミナル（terminal）とは、マウスではなく文字（コマンド）でパソコンに命令する画面のことです。

> [!WARNING]
> Git をインストールする前から VS Code を開いていた人は、**VS Code をいったん完全に閉じてから開き直してください**。開き直さないと、VS Code が Git を見つけられません。

### （任意）VS Code を日本語表示にする

この教材では、VS Code のメニューやボタンの名前を **日本語表示** で書き、英語表示を（ ）で添えます。日本語にしたい人は、次の手順で切り替えます。英語のままでもかまいません。

1. VS Code を開きます。
2. `Ctrl+Shift+P` を押して **コマンドパレット**（Command Palette：VS Code の機能を名前で探して実行する入力欄）を開きます。
3. `display` と入力し、**Configure Display Language**（表示言語を構成する）を選びます。
4. 一覧から **日本語（ja）** を選びます。一覧にない場合は、表示に従って「Japanese Language Pack for Visual Studio Code」をインストールします。
5. 再起動を求められたら **Restart**（再起動）をクリックします。

### 既定のターミナルを Git Bash にする

VS Code のターミナルは、最初は PowerShell（Windows 標準のターミナル）になっています。これを Git Bash に変えます。

1. VS Code で `Ctrl+Shift+P` を押して、コマンドパレットを開きます。
2. `既定のプロファイル` と入力し（英語表示の人は `default profile`）、**ターミナル: 既定のプロファイルの選択（Terminal: Select Default Profile）** を選びます。
3. 表示された一覧から **Git Bash** を選びます。
4. メニューの **ターミナル（Terminal）→ 新しいターミナル（New Terminal）** をクリックします（キーボードでは ``Ctrl+Shift+@``。英語キーボードでは ``Ctrl+Shift+` ``）。
5. 画面の下にターミナルが開きます。右上のあたりに **bash** と表示されていれば、Git Bash が開いています。

> [!TIP]
> 一覧に Git Bash が出てこないときは、VS Code を完全に閉じてから開き直してください。それでも出ないときは [レシピ setup-04](../recipes/setup.md#setup-04) を見てください。

開いたターミナルで、もう一度バージョンを確認してみましょう。

```bash
git --version
```

```text
git version 2.56.0.windows.2
```

### ターミナルの基本操作

ターミナルでは、`$` の後ろにコマンドを入力して `Enter` で実行します。`$` の前に表示される `MINGW64 ~` などの部分は「今いる場所」などの情報です（Git for Windows のバージョンによっては、`MINGW64` の代わりに `UCRT64` と表示されます。どちらでも Git Bash なので問題ありません）。

まず、よく使う4つのコマンドを覚えましょう。

| コマンド           | 意味                               | 由来                    |
| ------------------ | ---------------------------------- | ----------------------- |
| `pwd`              | 今いるフォルダの場所を表示する     | print working directory |
| `ls`               | 今いるフォルダの中身を一覧表示する | list                    |
| `cd フォルダ名`    | フォルダを移動する                 | change directory        |
| `mkdir フォルダ名` | フォルダを作る                     | make directory          |

順番に試してみます。

1. 今いる場所を表示します。

```bash
pwd
```

```text
/c/Users/hydr4
```

`hydr4` の部分は、あなたの Windows のユーザー名になります。Git Bash では、Windows の `C:\Users\hydr4` を `/c/Users/hydr4` のように **`/`（スラッシュ）区切り** で書きます。

2. ホームフォルダに移動します。`~`（チルダ）は **ホームフォルダ**（`C:\Users\<Windowsのユーザー名>`）を表す記号です。

```bash
cd ~
```

何も表示されなければ成功です。Git Bash では、成功したときは何も表示されないコマンドがたくさんあります。

3. 中身を一覧表示します。

```bash
ls
```

`Desktop`、`Documents`、`Downloads` などのフォルダ名が表示されます（人によって違います）。

**コピーと貼り付け（VS Code のターミナルの場合）**

- 貼り付け：`Ctrl+V`（または右クリック）
- コピー：コピーしたい文字をマウスで選択してから `Ctrl+C`
- **何も選択していない状態で `Ctrl+C` を押すと、「実行中のコマンドを止める」という意味になります。** 画面が止まったように見えるときに使えます。

> [!TIP]
> - `↑` キーを押すと、前に入力したコマンドを呼び出せます。
> - フォルダ名やファイル名を途中まで入力して `Tab` キーを押すと、残りを自動で補ってくれます（Tab 補完）。
> - `clear` と入力すると、画面の表示を消せます。
>
> ターミナルの操作をもっと知りたい人は [Appendix：Git Bash の基本](../appendix/git-bash-basics.md) を見てください。

---

## 4. Git の初期設定をする

Git を使い始める前に、**自分の名前やメールアドレスなどを Git に教えておく** 必要があります。これらは、パソコン全体（自分のユーザー）の設定として一度だけ行えば、以降ずっと使われます。この「パソコン全体の設定」を **グローバル設定**（global）と呼び、コマンドには `--global` を付けます。

以下のコマンドは、VS Code の Git Bash で **1つずつ** 実行してください。どれも成功すると何も表示されません。

### 名前とメールアドレス

Git では、変更を記録するたびに「誰が記録したか」として名前とメールアドレスが一緒に保存されます。

1. 名前を設定します。`"表示したい名前"` の部分を、自分の名前に書き換えてから実行します（`"` は残します）。

```bash
git config --global user.name "表示したい名前"
```

例：

```bash
git config --global user.name "Taro Yamada"
```

> [!WARNING]
> この名前は、8日目以降に GitHub に送った記録から **誰でも見られる状態** になります。本名を出したくない人は、ニックネームやローマ字の名前にしましょう。日本語でも設定できます。

2. メールアドレスを設定します。`"GitHubに登録する予定のメールアドレス"` の部分を、自分のメールアドレスに書き換えてから実行します。

```bash
git config --global user.email "GitHubに登録する予定のメールアドレス"
```

> [!NOTE]
> このメールアドレスは **2日目に、GitHub が用意する「公開用のメールアドレス（noreply アドレス）」に変更します**。今日は仮の設定と考えて大丈夫です。

### ブランチ名とエディタ

3. 新しく作るリポジトリの最初のブランチ名を `main` にします。ブランチについては6日目に学びます（インストーラーで設定した人も、念のため実行してください）。

```bash
git config --global init.defaultBranch main
```

4. Git が文章の入力を求めるときに使うエディタを VS Code にします。`--wait` は「VS Code でそのファイルが閉じられるまで待つ」という意味です。

```bash
git config --global core.editor "code --wait"
```

### 日本語ファイル名と pull の設定

5. 日本語のファイル名が `"\343\201\202..."` のような記号の並びにならず、そのまま表示されるようにします。

```bash
git config --global core.quotepath false
```

6. `pull`（GitHub から変更を取り込む操作）の動き方を決めておきます。意味は **8日目で説明します**。今はおまじないだと思って実行してください。

```bash
git config --global pull.rebase false
```

### 設定を確認する

7. 設定した内容を一覧表示します。

```bash
git config --global --list
```

次のように6行が表示されれば成功です（名前とメールアドレスは人によって違います。項目名は小文字で表示されます）。

```text
user.name=Taro Yamada
user.email=hydr4@example.com
init.defaultbranch=main
core.editor=code --wait
core.quotepath=false
pull.rebase=false
```

> [!TIP]
> 表示が長くて最後に `:` や `(END)` が出て止まったときは、`q` キーを押すと抜けられます（[レシピ trouble-09](../recipes/troubleshooting.md#trouble-09)）。

**まちがえたときは？** もう一度同じコマンドを正しい値で実行すれば上書きされます。たとえば名前をまちがえたら、`git config --global user.name "正しい名前"` を実行し直します。詳しくは [レシピ setup-02](../recipes/setup.md#setup-02) を見てください。

> [!NOTE]
> **VS Code で行う場合**：Git の初期設定には、VS Code の画面（GUI）での操作はありません。ターミナルで実行してください。

設定の意味をもっと知りたい人は [Appendix：Git の設定](../appendix/git-config.md) を見てください。

---

## 5. 練習用フォルダを作る

この勉強会で使うフォルダは、すべて **ホームフォルダの下の `git-practice`**（`C:\Users\<Windowsのユーザー名>\git-practice`）にまとめます。

1. ホームフォルダに移動します。

```bash
cd ~
```

2. `git-practice` フォルダを作ります。

```bash
mkdir ~/git-practice
```

3. できたかどうか確認します。

```bash
ls -d ~/git-practice
```

```text
/c/Users/hydr4/git-practice
```

エクスプローラーで `C:\Users\<Windowsのユーザー名>` を開くと、`git-practice` フォルダが見えるはずです。

> [!WARNING]
> **「ドキュメント」「デスクトップ」「OneDrive」の中には作らないでください。** これらのフォルダは OneDrive と同期されていることが多く、OneDrive が Git の管理用ファイルを途中で書き換えたり、ロックしたりして、履歴が壊れることがあります。必ず上の手順どおり、ユーザーフォルダ直下の `git-practice` を使ってください（[レシピ setup-07](../recipes/setup.md#setup-07)）。

> [!NOTE]
> **VS Code で行う場合**：エクスプローラーで `C:\Users\<Windowsのユーザー名>` を開き、右クリック → **新規作成** → **フォルダー** で `git-practice` を作っても同じです。

---

## 演習

[演習：1日目のセットアップ確認](../exercises/day01-setup-check/README.md) に取り組んで、今日の設定がすべてできているか確かめましょう。

## 確認チェックリスト

- [ ] VS Code のターミナルで `git --version` を実行すると `git version 2.…` と表示される
- [ ] VS Code で新しいターミナルを開くと、Git Bash（`bash`）が開く
- [ ] `git config --global --list` で、`user.name`、`user.email`、`init.defaultbranch=main`、`core.editor=code --wait`、`core.quotepath=false`、`pull.rebase=false` の6項目が表示される
- [ ] `ls -d ~/git-practice` で `/c/Users/<Windowsのユーザー名>/git-practice` が表示される
- [ ] `pwd`、`ls`、`cd`、`mkdir` の意味を説明できる

## よくあるつまずき

**`git: command not found` と表示される**
- 原因：Git がインストールされていないか、Git をインストールする前から開いていた VS Code やターミナルを使っています。
- 対処：VS Code（またはターミナル）を完全に閉じてから開き直します。それでもだめなら、Git for Windows をもう一度インストールします。PowerShell で「'git' は、内部コマンドまたは外部コマンド…として認識されていません」と出る場合も同じです。→ [レシピ trouble-01](../recipes/troubleshooting.md#trouble-01)

**VS Code のターミナルの一覧に Git Bash が出てこない**
- 原因：VS Code が Git for Windows を見つけられていません。
- 対処：VS Code を完全に閉じて開き直します。→ [レシピ setup-04](../recipes/setup.md#setup-04)

**ターミナルが PowerShell のまま開く（`PS C:\Users\...>` と表示される）**
- 原因：既定のプロファイルが変わっていないか、前から開いていたターミナルを使っています。
- 対処：ターミナルの右上の **ゴミ箱アイコン**（ターミナルの強制終了）で閉じ、もう一度 **ターミナル → 新しいターミナル** で開きます。それでも PowerShell なら、[既定のターミナルを Git Bash にする](#既定のターミナルを-git-bash-にする) をやり直します。

**`git config` の名前やメールアドレスをまちがえた**
- 対処：正しい値で同じコマンドを実行し直せば上書きされます。→ [レシピ setup-02](../recipes/setup.md#setup-02)

**`git config --global --list` の結果から抜けられない（`:` や `(END)` が出ている）**
- 対処：`q` キーを押します。→ [レシピ trouble-09](../recipes/troubleshooting.md#trouble-09)

**`code --wait` を設定したのに、VS Code が開かない（2日目以降に気づくことがあります）**
- 原因：VS Code のインストール時に「PATH への追加」がされていない可能性があります。
- 対処：Git Bash で `code --version` を実行し、バージョンが表示されるか確認します。表示されない場合は [レシピ setup-03](../recipes/setup.md#setup-03) を見てください。

**Windows のユーザー名に日本語や空白が入っている**
- Git Bash では基本的にそのまま使えます。ただし、パスを入力するときに空白があると困るので、この教材では `~` を使ってパスを書いています。`~` をそのまま使ってください。詳しくは [Appendix：Git Bash の基本](../appendix/git-bash-basics.md)。

## もっと知りたい人へ

- [Appendix：Git Bash の基本](../appendix/git-bash-basics.md)：ターミナルの種類、パスの書き方、便利な操作
- [Appendix：Git の設定](../appendix/git-config.md)：今日入れた設定の意味、設定の3階層
- [Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md)：インストーラーの改行コードの選択肢の意味
- レシピ
  - [setup-01 Git のバージョンを確かめたい・最新版に更新したい](../recipes/setup.md#setup-01)
  - [setup-02 名前とメールアドレスの設定を確認・変更したい](../recipes/setup.md#setup-02)
  - [setup-03 コミットメッセージを書くエディタを VS Code にしたい](../recipes/setup.md#setup-03)
  - [setup-04 VS Code のターミナルを Git Bash にしたい](../recipes/setup.md#setup-04)
  - [setup-07 練習用・作業用のフォルダはどこに作ればいい？](../recipes/setup.md#setup-07)
  - [trouble-01 `git: command not found` と出る](../recipes/troubleshooting.md#trouble-01)

---
[README](../README.md) ｜ [2日目 →](day02-github-account.md)
