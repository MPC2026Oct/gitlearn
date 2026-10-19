# Git Bash とターミナルの基本

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[1日目](../docs/day01-install-git.md)を読んだ人
>
> **読む時間の目安**：25分（コマンドを試しながらなら40分）

1日目では「`pwd` `ls` `cd` `mkdir` が使えれば大丈夫」という最小限の説明にとどめました。このページでは、ターミナル（terminal：文字でコンピューターに命令する画面）について、本編で省略したことを説明します。

## このページでわかること

- ターミナル・シェル・Git Bash・PowerShell・コマンドプロンプトの関係
- Git Bash でのパスの書き方（`~`、`/c/Users/...` と `C:\Users\...`）
- よく使うコマンドと、その「危ないところ」
- Tab 補完、履歴、コピー＆ペースト、`Ctrl+C` の意味
- `git log` などで表示される「ページャー（`less`）」の操作
- 日本語やスペースを含むパスの扱い方

---

<a id="terminal-and-shell"></a>
## 1. ターミナルとシェル

### ターミナル・シェル・コマンドの関係

ふだん「ターミナル」と呼んでいるものは、実は2つの部品でできています。

```text
┌──────────── ターミナル（画面・窓） ────────────┐
│  文字を表示し、キーボード入力を受け取る係        │
│  例：VS Code のターミナルパネル、mintty         │
│                                                │
│   ┌──────── シェル（shell） ────────┐          │
│   │ 入力された1行を読んで解釈し、    │          │
│   │ プログラムを起動する係           │          │
│   │ 例：bash、PowerShell、cmd.exe    │          │
│   └───────────────┬──────────────────┘          │
└───────────────────┼────────────────────────────┘
                    │ 起動
                    ▼
        コマンド（プログラム）
        例：git.exe、ls.exe、code
```

- **ターミナル**：文字を表示する「窓」です。VS Code の下部に出るターミナルパネルや、スタートメニューから開く「Git Bash」のウィンドウ（mintty というアプリ）がこれにあたります。
- **シェル**：入力した1行（コマンドライン）を読み取り、`~` を実際のフォルダに置き換えたり、`*.md` を一致するファイル名に展開したりしてから、プログラムを起動する係です。
- **コマンド**：`git` や `ls` などの実際のプログラムです。

この教材の「VS Code 内の Git Bash」は、**ターミナル＝VS Code、シェル＝bash** という組み合わせです。

### Git Bash とは

Git Bash は、Git for Windows に同梱されている **bash（バッシュ）というシェルと、Linux でおなじみの小さなコマンド群（`ls`、`cp`、`cat`、`less` など）** のセットです。中身は MSYS2 という「Windows で Linux 風のコマンドを動かすしくみ」をもとにしています（出典：[Git for Windows](https://gitforwindows.org/)）。

Git の公式ドキュメントや、ネット上の解説記事のほとんどは bash（または似たシェル）を前提に書かれています。この教材で Git Bash を使うのは、**調べた情報をそのまま試せる** からです。

### Git Bash・PowerShell・コマンドプロンプトの違い

Windows 11 には、最初から PowerShell とコマンドプロンプト（cmd）が入っています。Git Bash を含めた3つを比べると次のとおりです。

|                        | Git Bash                   | PowerShell                            | コマンドプロンプト |
| ---------------------- | -------------------------- | ------------------------------------- | ------------------ |
| シェル                 | bash                       | PowerShell                            | cmd.exe            |
| 入手方法               | Git for Windows に同梱     | Windows に標準                        | Windows に標準     |
| パスの区切り           | `/`                        | `\`（`/` も可）                       | `\`                |
| ホームフォルダ         | `~`                        | `~` または `$HOME`                    | `%USERPROFILE%`    |
| 今いる場所を表示       | `pwd`                      | `pwd`（`Get-Location`）               | `cd`               |
| 一覧（隠しファイルも） | `ls -a`                    | `ls -Force`（`Get-ChildItem -Force`） | `dir /a`           |
| ファイルの中身を表示   | `cat`                      | `cat`（`Get-Content`）                | `type`             |
| コピー                 | `cp`                       | `cp`（`Copy-Item`）                   | `copy`             |
| 移動・名前変更         | `mv`                       | `mv`（`Move-Item`）                   | `move`／`ren`      |
| 削除                   | `rm`                       | `rm`（`Remove-Item`）                 | `del`              |
| 画面を消す             | `clear`（または `Ctrl+L`） | `cls`                                 | `cls`              |

PowerShell にも `ls` や `cp` という名前がありますが、これは PowerShell 独自のコマンドの **別名（エイリアス）** で、オプションの書き方が違います。たとえば Git Bash の `ls -a` は PowerShell ではエラーになります。

> [!NOTE]
> `git` コマンドそのものは、どのシェルでも同じように使えます（1日目のインストーラーで「Git from the command line and also from 3rd-party software」を選ぶと、PowerShell やコマンドプロンプトからも `git` が使えるように PATH が設定されます）。違いが出るのは **`git` 以外のコマンド** と、**引用符（`"` や `'`）や特殊記号の扱い** です。この教材のコマンド例は Git Bash で動くように書いているので、PowerShell に貼り付けると動かないことがあります。

### プロンプトの読み方

Git Bash を開くと、次のような行が表示されます。これをプロンプト（prompt：入力をうながす表示）といいます。

```text
hydr4@DESKTOP-ABC1234 UCRT64 ~/git-practice/my-profile (main)
$
```

| 部分                        | 意味                                                                                                            |
| --------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `hydr4`                     | Windows のユーザー名                                                                                            |
| `DESKTOP-ABC1234`           | パソコンの名前                                                                                                  |
| `UCRT64`                    | Git Bash の動作モードの名前（Git for Windows 2.55 以前では `MINGW64` と表示されます。どちらでも Git Bash です） |
| `~/git-practice/my-profile` | 今いるフォルダ（カレントディレクトリ）                                                                          |
| `(main)`                    | 今いるフォルダが Git リポジトリなら、今いるブランチ名。リポジトリでなければ表示されません                       |
| `$`                         | ここから入力してください、という合図                                                                            |

教材のコマンド例では、この `$` は書いていません。コードブロックの中身をそのままコピーして貼り付けてください。

---

<a id="paths"></a>
## 2. パスの書き方

パス（path）は、ファイルやフォルダの「住所」です。Git Bash では Windows と書き方が違うので、最初に混乱しやすいところです。

### 同じ場所の3つの書き方

```text
Windows（エクスプローラー）の書き方   C:\Users\hydr4\git-practice\my-profile
Git Bash の書き方                     /c/Users/hydr4/git-practice/my-profile
Git Bash の省略形                     ~/git-practice/my-profile
```

- Git Bash では、区切りに `\`（バックスラッシュ、日本語キーボードでは `¥` に見えることがあります）ではなく **`/`（スラッシュ）** を使います。
- ドライブ `C:` は **`/c`** と書きます。D ドライブなら `/d` です。
- **`~`（チルダ）** は「自分のホームフォルダ」（`C:\Users\<Windowsのユーザー名>`）の省略形です。

### 絶対パスと相対パス

| 種類     | 例                                              | 意味                                |
| -------- | ----------------------------------------------- | ----------------------------------- |
| 絶対パス | `/c/Users/hydr4/git-practice`、`~/git-practice` | どこにいても同じ場所を指す          |
| 相対パス | `my-profile`、`./my-profile`                    | 今いる場所から見た場所              |
|          | `..`                                            | 1つ上のフォルダ                     |
|          | `.`                                             | 今いるフォルダそのもの              |
|          | `../gitlearn`                                   | 1つ上に行ってから `gitlearn` に入る |

たとえば `~/git-practice/my-profile` にいるときに `cd ../gitlearn` とすると、`~/git-practice/gitlearn` に移動します。

### Windows のパスと相互に変換する

Git Bash には `cygpath` という変換コマンドが入っています。

```bash
cygpath -w ~/git-practice
```

```text
C:\Users\hydr4\git-practice
```

（`hydr4` の部分は人によって違います）

逆に、エクスプローラーのアドレスバーからコピーした Windows 形式のパスを使いたいときは、**シングルクォート `'` で囲めば** そのまま `cd` できます。

```bash
cd 'C:\Users\hydr4\git-practice'
```

> [!WARNING]
> 囲まずに `cd C:\Users\hydr4\git-practice` と打つと、bash は `\` を特別な記号として扱うため、`C:Usershydr4git-practice` のような意味のない場所を探してエラーになります。

### エクスプローラーや VS Code との行き来

今いるフォルダを、エクスプローラーや VS Code で開くこともできます。`.` は「今いるフォルダ」の意味です。

```bash
explorer .
```

```bash
code .
```

---

<a id="commands"></a>
## 3. よく使うコマンド

### 一覧

| コマンド        | 意味                                                         | 例                         |
| --------------- | ------------------------------------------------------------ | -------------------------- |
| `pwd`           | 今いる場所を表示する（print working directory）              | `pwd`                      |
| `ls`            | ファイルの一覧                                               | `ls`                       |
| `ls -a`         | 隠しファイル（`.` で始まるもの）も含めた一覧                 | `ls -a`                    |
| `ls -l`         | 詳しい一覧（サイズ・日時など）                               | `ls -la`                   |
| `cd`            | 移動する（change directory）                                 | `cd ~/git-practice`        |
| `cd` だけ       | ホームフォルダに戻る                                         | `cd`                       |
| `cd -`          | 直前にいたフォルダに戻る                                     | `cd -`                     |
| `mkdir`         | フォルダを作る                                               | `mkdir notes`              |
| `mkdir -p`      | 途中のフォルダもまとめて作る（すでにあってもエラーにしない） | `mkdir -p ~/git-practice`  |
| `cp`            | コピーする                                                   | `cp a.md b.md`             |
| `cp -r`         | フォルダごとコピーする                                       | `cp -r folder1 folder2`    |
| `mv`            | 移動する・名前を変える                                       | `mv old.md new.md`         |
| `cat`           | ファイルの中身を全部表示する                                 | `cat profile.md`           |
| `head` / `tail` | 先頭・末尾の数行だけ表示する                                 | `head -n 5 profile.md`     |
| `less`          | 長いファイルを1画面ずつ表示する（[5章](#pager)）             | `less profile.md`          |
| `touch`         | 空のファイルを作る                                           | `touch memo.txt`           |
| `echo`          | 文字を表示する。`>` と組み合わせるとファイルに書き込む       | `echo "hello" > hello.txt` |
| `rm`            | ファイルを削除する                                           | `rm memo.txt`              |
| `clear`         | 画面を消す（`Ctrl+L` でも可）                                | `clear`                    |
| `exit`          | シェルを終了する                                             | `exit`                     |

### `ls -a` で見える「隠しファイル」

`.git` フォルダや `.gitignore` のように、名前が `.` で始まるものは、`ls` では表示されず、`ls -a` で初めて見えます。

```bash
cd ~/git-practice/my-profile
ls -a
```

```text
./  ../  .git/  .gitignore  debug.log  hobbies.md  private-memo.txt  profile.md
```

（4日目まで進めた場合の例です。中身は人によって違います。Git Bash の `ls` は、フォルダの名前の後ろに `/` を付けて表示します）

`.` と `..` は「このフォルダ」「1つ上のフォルダ」を表す特別な名前です。`.git` の中身は [Git の内部構造](git-internals.md) で詳しく見ます。

### 上書き・削除の危ないところ

bash のコマンドは、確認なしで実行されるものが多いので注意してください。

| 操作                                  | 何が起きるか                             | 安全にするには                            |
| ------------------------------------- | ---------------------------------------- | ----------------------------------------- |
| `cp a.md b.md`（`b.md` がすでにある） | `b.md` が **確認なしで上書き** される    | `cp -i`（上書きの前に確認する）           |
| `mv a.md b.md`（`b.md` がすでにある） | `b.md` が **確認なしで上書き** される    | `mv -i`                                   |
| `rm memo.txt`                         | **ごみ箱に入らず、すぐに消える**         | `rm -i`、またはエクスプローラーで削除する |
| `echo "..." > file.txt`               | `file.txt` の中身が **丸ごと置き換わる** | 追記したいときは `>>` を使う              |

> [!CAUTION]
> `rm -r` はフォルダを中身ごと、ごみ箱を通さずに消します。とくに `.git` フォルダを消すと、そのリポジトリの履歴はすべて失われます。この教材では `rm -r` を使う手順はありません。フォルダを消したいときはエクスプローラーで削除してください（ごみ箱から戻せます）。

### コマンドの「オプション」と「引数」

```text
cp   -r      exercises    backup
──   ──      ─────────    ──────
命令 オプション 引数1        引数2
```

- **オプション**：`-` で始まり、動作を変えます。`-r` のような短い形と、`--recursive` のような長い形があります。`ls -la` は `ls -l -a` をまとめた書き方です。
- **引数（ひきすう）**：命令の対象（ファイル名など）です。

Git のコマンドも同じ形です。`git commit -m "メッセージ"` は「`git` に `commit` という命令を、`-m` オプションとメッセージを付けて実行する」という意味です。Git では `--` の後ろは必ずファイル名として扱われます（例：`git log -- profile.md`）。

### ヘルプの見方

```bash
git status -h
```

`-h` を付けると、オプションの短い一覧が表示されます。詳しい説明を見たいときは次のようにします。Git for Windows では、ブラウザで公式のマニュアルが開きます。

```bash
git help status
```

---

<a id="keyboard"></a>
## 4. キーボード操作：補完・履歴・コピー＆ペースト・Ctrl+C

### Tab 補完

ファイル名やフォルダ名を途中まで入力して **Tab** キーを押すと、残りを自動で補ってくれます。

```text
cd ~/git-pr        ← ここで Tab を押す
cd ~/git-practice/ ← 自動で補われる
```

- 候補が複数あるときは、もう一度 Tab を押すと候補の一覧が出ます。
- Git Bash には Git 用の補完も入っているので、`git sw` → Tab で `git switch`、`git switch add-` → Tab でブランチ名も補完できます。
- **打ち間違いを防ぐいちばんの方法** です。積極的に使いましょう。

### 履歴

| キー                      | 動作                                                                                     |
| ------------------------- | ---------------------------------------------------------------------------------------- |
| `↑` / `↓`                 | 前に実行したコマンドを呼び出す                                                           |
| `Ctrl+R` のあと文字を入力 | 過去のコマンドを検索する（もう一度 `Ctrl+R` で次の候補、`Enter` で実行、`Esc` で抜ける） |
| `history`                 | これまでのコマンドの一覧を表示する                                                       |

### カーソル移動の便利なキー

| キー                | 動作                                           |
| ------------------- | ---------------------------------------------- |
| `Home` / `End`      | 行の先頭／末尾へ                               |
| `Ctrl+←` / `Ctrl+→` | 単語ごとに移動                                 |
| `Ctrl+U`            | カーソルより前を消す（入力をやり直したいとき） |

### コピーと貼り付け

使っているターミナルによって操作が違います。

| 操作     | VS Code のターミナル（この教材の標準）           | 単体の Git Bash ウィンドウ（mintty）                 |
| -------- | ------------------------------------------------ | ---------------------------------------------------- |
| コピー   | 文字を選んで `Ctrl+C`（または右クリック）        | 文字を選ぶだけでコピーされる。`Ctrl+Insert` でも可   |
| 貼り付け | `Ctrl+V`（選択していないときの右クリックでも可） | `Shift+Insert`、または右クリックメニューの **Paste** |

VS Code の右クリックは、Windows では「選択していればコピー、していなければ貼り付け」になっています（出典：[VS Code Docs - Terminal Basics](https://code.visualstudio.com/docs/terminal/basics)）。

> [!TIP]
> 教材のコマンドを貼り付けたら、**実行する前に一度目で確認する** 習慣をつけましょう。複数行をまとめて貼り付けると、VS Code が確認のメッセージを出すことがあります。迷ったら1行ずつ貼り付けて実行してください。

### `Ctrl+C` は「中断」

bash の世界では、`Ctrl+C` は **「今動いているコマンドを中断する」** という意味です。

- VS Code のターミナルでは、**文字を選択しているときだけコピー** になり、選択していないときは中断の合図が送られます。
- 入力の途中で `Ctrl+C` を押すと、その行は実行されずに新しいプロンプトが出ます。「この入力をなかったことにしたい」ときにも使えます。
- 何かのコマンドが終わらなくなったとき（入力待ちで止まって見えるときなど）も、まず `Ctrl+C` を試してください。

> [!NOTE]
> `git log` の画面（[5章](#pager)）や、コミットメッセージを書くエディタ（Vim）は `Ctrl+C` では抜けられません。`git log` などは `q`、Vim は [レシピ trouble-10](../recipes/troubleshooting.md#trouble-10) を見てください。

---

<a id="pager"></a>
## 5. ページャー（less）の操作

`git log` や `git diff` の出力が画面に収まらないとき、Git は **ページャー（pager）** と呼ばれる「1画面ずつ見るためのプログラム」を自動で起動します。Git Bash では `less` というページャーが使われます。

画面の左下に `:` や `(END)` が表示されていたら、less が動いています。この状態ではコマンドを入力できません。

### less の操作

| キー                          | 動作                            |
| ----------------------------- | ------------------------------- |
| `q`                           | **終了する（いちばん大事）**    |
| `Space` または `f`            | 1画面進む                       |
| `b`                           | 1画面戻る                       |
| `↓` / `↑`（または `j` / `k`） | 1行ずつ動く                     |
| `g` / `G`                     | 先頭へ／最後へ                  |
| `/文字` → `Enter`             | 文字を検索する（例：`/README`） |
| `n` / `N`                     | 次／前の検索結果へ              |
| `h`                           | ヘルプ（`q` で戻る）            |

### 短い出力のときはページャーが出ない理由

Git は、環境変数 `LESS` が設定されていなければ、`LESS=FRX` という設定で less を起動します（出典：[git-config の core.pager](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corepager)）。

- `F`：1画面に収まるなら、すぐに終了する（だから短い `git log` では `q` が要らない）
- `R`：色付きの表示をそのまま出す
- `X`：終了後も画面に内容を残す

### ページャーを使わずに表示したいとき

```bash
git --no-pager log --oneline
```

`--no-pager` は `git` の直後に書きます（`git log --no-pager` ではありません）。短く `git -P log --oneline` とも書けます。

関連レシピ：[trouble-09 `git log` などの画面から抜けられない](../recipes/troubleshooting.md#trouble-09)

---

<a id="spaces-and-japanese"></a>
## 6. 日本語やスペースを含むパス

### スペースを含むパスは引用符で囲む

bash はスペースを「区切り」として扱います。`my folder` というフォルダに移動しようとして次のように打つと、`my` と `folder` の2つを指定したことになりエラーになります。

```text
$ cd my folder
bash: cd: too many arguments
```

引用符で囲むか、スペースの前に `\` を付けます。

```bash
mkdir "my folder"
cd "my folder"
cd ..
```

```bash
cd my\ folder
cd ..
```

Tab 補完を使うと、自動で `\` を付けてくれます。

### `~` は引用符の外に出す

`~` は、**引用符の中に入れるとホームフォルダに置き換わりません**。

| 書き方             | 結果                                                    |
| ------------------ | ------------------------------------------------------- |
| `cd ~/"my folder"` | ○ `~` が置き換わり、ホームの下の `my folder` に移動する |
| `cd "~/my folder"` | × `~` という名前のフォルダを探してしまい、エラーになる  |

### 日本語のファイル名・フォルダ名

Git Bash でも日本語の名前は使えますが、次の理由から、**Git で管理するファイルやフォルダの名前は半角英数字・ハイフン・アンダースコアにする** のがおすすめです。

- 入力が面倒で、Tab 補完も効きにくい（日本語入力の切り替えが必要）
- 設定によっては `git status` で `"\343\203\241..."` のような表示になる（1日目の `core.quotepath false` で対策済み。詳しくは [改行コードと文字コード](line-endings-and-encoding.md#quotepath)）
- Mac を使う人と共有すると、文字の内部表現の違いで別のファイルとして扱われることがある

この教材のファイル名がすべて半角英数字なのは、このためです。ファイルの **中身** に日本語を書くのは問題ありません。

> [!NOTE]
> Windows のユーザー名が日本語の場合、ホームフォルダのパスも日本語（例：`/c/Users/太郎`）になります。Git 自体はこれで問題なく動きますが、ほかのツールでまれに不具合が出ることがあります。練習用フォルダは README のとおり `~/git-practice` に作れば十分です。

### OneDrive のフォルダを避ける理由

README で「ドキュメント」や「デスクトップ」を避けるようにお願いしているのは、これらが OneDrive で同期されていることが多いからです。同期ソフトが `.git` フォルダの中のファイルを Git と同時に書き換えたり、「オンライン専用」にして中身を手元から消したりすると、リポジトリが壊れることがあります（[レシピ setup-07](../recipes/setup.md#setup-07)）。

---

## 7. 試してみよう

Appendix の実験は、`~/git-practice/appendix-lab/` の下に作る練習専用のフォルダで行います。ここなら失敗しても困りません。

1. 練習用のフォルダを作って移動します。

   ```bash
   mkdir -p ~/git-practice/appendix-lab/bash
   cd ~/git-practice/appendix-lab/bash
   ```

2. 今いる場所を Git Bash 形式と Windows 形式で表示します。

   ```bash
   pwd
   cygpath -w "$(pwd)"
   ```

   ```text
   /c/Users/hydr4/git-practice/appendix-lab/bash
   C:\Users\hydr4\git-practice\appendix-lab\bash
   ```

   （ユーザー名の部分は人によって違います）

3. ファイルを作って、上書きと追記の違いを確かめます。

   ```bash
   echo "1行目" > memo.txt
   echo "2行目" >> memo.txt
   cat memo.txt
   ```

   ```text
   1行目
   2行目
   ```

4. スペースを含むフォルダを作って、Tab 補完で入ります（`cd my` まで打って Tab）。

   ```bash
   mkdir "my folder"
   ```

5. 終わったらホームフォルダに戻ります。`appendix-lab` フォルダは、不要になったらエクスプローラーで削除してかまいません。

   ```bash
   cd
   ```

---

## まとめ

- ターミナルは「窓」、シェルは「命令を解釈する係」。この教材は VS Code（窓）＋ bash（シェル）。
- Git Bash のパスは `/` 区切り、`C:` は `/c`、ホームは `~`。Windows 形式のパスは `'...'` で囲めば使える。
- `cp` `mv` `>` は確認なしで上書き、`rm` はごみ箱を通らない。
- Tab 補完と `↑` の履歴で打ち間違いを減らす。`Ctrl+C` は中断、less は `q` で抜ける。
- スペースを含むパスは引用符で囲む。ただし `~` は引用符の外に出す。

## 関連ページ

- [1日目：Git のインストールと初期設定](../docs/day01-install-git.md)（「3. VS Code で Git Bash を使う」）
- [レシピ setup-04 VS Code のターミナルを Git Bash にしたい](../recipes/setup.md#setup-04)
- [レシピ setup-07 練習用・作業用のフォルダはどこに作ればいい？](../recipes/setup.md#setup-07)
- [レシピ trouble-01 `git: command not found` と出る](../recipes/troubleshooting.md#trouble-01)
- [レシピ trouble-09 `git log` などの画面から抜けられない](../recipes/troubleshooting.md#trouble-09)

## 参考資料

- Git for Windows：<https://gitforwindows.org/>
- Git for Windows リリースノート（既知の問題：パスの変換など）：<https://github.com/git-for-windows/build-extra/blob/main/ReleaseNotes.md>
- VS Code Docs - Terminal Basics：<https://code.visualstudio.com/docs/terminal/basics>
- git-config（`core.pager` の項）：<https://git-scm.com/docs/git-config>
- GNU Bash マニュアル：<https://www.gnu.org/software/bash/manual/>

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
