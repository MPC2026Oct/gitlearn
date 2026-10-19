# 改行コードと文字コード

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[1日目](../docs/day01-install-git.md)を読んだ人（[4日目](../docs/day04-diff-log-ignore.md)まで進めているとよりわかりやすくなります）
>
> **読む時間の目安**：30分

Windows で Git を使うと、`LF will be replaced by CRLF` という警告や、日本語のファイル名が `"\343\203..."` と表示される現象に出会うことがあります。どちらも **ファイルの中の「目に見えない文字」の扱い** が原因です。このページでは、本編で「この設定を入れておけば大丈夫」とだけ説明した部分のしくみを説明します。

## このページでわかること

- 改行コード CRLF と LF の違い
- Git が改行コードを変換するしくみと、`core.autocrlf`（インストーラーの選択肢）の関係
- この教材の `.gitattributes` に書いてあることの意味
- `LF will be replaced by CRLF` 警告の意味と対処
- UTF-8 と BOM、Shift_JIS
- `core.quotepath` と、日本語のファイル名の注意点
- VS Code 右下の「CRLF」「UTF-8」の表示の見方と変え方

---

<a id="crlf-lf"></a>
## 1. 改行コードとは

テキストファイルの「改行」は、実際には **改行を表す見えない文字** として保存されています。その文字が OS によって違います。

| 名前 | 中身（文字コード） | 主に使う環境 |
|---|---|---|
| LF（ラインフィード） | `0A`（`\n`） | Linux、macOS、Git の世界の標準 |
| CRLF（キャリッジリターン＋ラインフィード） | `0D 0A`（`\r\n`） | Windows |

たとえば「あ」「い」の2行のファイルは、次のように保存されています。

```text
LF の場合：    あ \n い \n
CRLF の場合：  あ \r \n い \r \n
```

画面上の見た目は同じでも、ファイルの中身（バイト）は違います。Git は中身のバイトを比べて変更を判断するので、**改行コードが変わっただけで「全行が変更された」ことになってしまいます**。Windows の人と Mac の人が同じファイルを編集するとこの問題が起きやすいため、Git には改行コードを自動で変換するしくみがあります。

---

<a id="conversion"></a>
## 2. Git の改行コード変換のしくみ

Git の変換は、**リポジトリ（コミットの中）には LF で保存し、ワーキングツリー（実際に編集するファイル）では各自の OS に合わせる** という考え方です。

```text
  ワーキングツリー               ステージ／リポジトリ
  （手元のファイル）              （Git の中）
  ┌─────────────┐   git add     ┌─────────────┐
  │  CRLF       │ ────────────▶ │  LF         │  ← 全員共通で LF
  │ （Windows） │  CRLF→LF 変換 │             │
  │             │ ◀──────────── │             │
  └─────────────┘  LF→CRLF 変換 └─────────────┘
                  checkout / clone / switch / restore など
```

- **入れるとき**（`git add`）：CRLF を LF に変換して保存します。
- **出すとき**（`git clone`、`git switch`、`git restore` など、Git がファイルを書き出すとき）：LF を CRLF に変換します。

こうすると、Windows の人も Mac の人も、手元では自分の OS の改行コードで編集でき、Git の中ではいつも LF にそろいます。

> [!NOTE]
> 変換されるのは **テキストファイルだけ** です。画像などのバイナリーファイルは、Git が中身を見て自動的に判定し、変換しません（後述の `text=auto` の働きです）。

---

<a id="autocrlf"></a>
## 3. core.autocrlf とインストーラーの選択肢

この変換を「するかどうか」を決める設定が `core.autocrlf` です。1日目の Git for Windows のインストーラーで「Configuring the line ending conversions」の画面で選んだものが、そのまま `core.autocrlf` として **system の設定**（`C:\Program Files\Git\etc\gitconfig`）に保存されています（出典：[インストーラーのソース install.iss](https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss)）。

| インストーラーの選択肢 | `core.autocrlf` | add するとき | 書き出すとき |
|---|---|---|---|
| **Checkout Windows-style, commit Unix-style line endings**（この教材の推奨） | `true` | CRLF → LF | LF → CRLF |
| Checkout as-is, commit Unix-style line endings | `input` | CRLF → LF | 変換しない |
| Checkout as-is, commit as-is | `false` | 変換しない | 変換しない |

インストーラーの説明文でも、1つ目が「For cross-platform projects, this is the recommended setting on Windows」（複数の OS で使うプロジェクトでは Windows での推奨設定）と書かれています。GitHub Docs も Windows では `true` を案内しています（出典：[GitHub Docs - Configuring Git to handle line endings](https://docs.github.com/en/get-started/git-basics/configuring-git-to-handle-line-endings)）。

自分の設定を確かめるには、次のコマンドを実行します（設定の階層については [Git の設定のしくみ](git-config.md) を参照）。

```bash
git config --show-origin core.autocrlf
```

```text
file:C:/Program Files/Git/etc/gitconfig	true
```

公式の説明では、`core.autocrlf=true` は「すべてのファイルに `text=auto` 属性を付け、`core.eol=crlf` にするのと同じ」とされています（出典：[git-config の core.autocrlf](https://git-scm.com/docs/git-config#Documentation/git-config.txt-coreautocrlf)）。この「属性」が次の章の `.gitattributes` の話につながります。

---

<a id="gitattributes"></a>
## 4. .gitattributes：リポジトリ側で決める

`core.autocrlf` は **各自のパソコンの設定** なので、インストール時に別の選択肢を選んだ人がいると、ふるまいがそろいません。そこで、**リポジトリの中に `.gitattributes` というファイルを置いて、リポジトリ側で改行コードの扱いを決める** 方法があります。`.gitattributes` の指定は `core.autocrlf` より優先されます。

### この教材の .gitattributes

この教材（`gitlearn`）のルートには、次の内容の `.gitattributes` があります（コメント行は省略）。

```text
* text=auto
*.sh text eol=lf
```

`.gitignore` と同じように、左側がファイル名のパターン、右側がそのファイルに付ける「属性（attribute）」です。

| 行 | 意味 |
|---|---|
| `* text=auto` | すべてのファイル（`*`）について、テキストかバイナリーかを Git に自動判定させ、テキストなら改行コードを変換する。リポジトリの中は LF、ワーキングツリーは各自の設定に合わせる（Windows では CRLF） |
| `*.sh text eol=lf` | `.sh`（シェルスクリプト）はテキストとして扱い、**ワーキングツリーでも必ず LF** にする |

公式の説明では、`text` 属性が付いていて `core.autocrlf` も `core.eol` も設定されていない場合、Windows では CRLF、それ以外では LF で書き出されます（出典：[gitattributes](https://git-scm.com/docs/gitattributes) の `eol` の項）。つまり、この `.gitattributes` があれば、**インストーラーでどれを選んだ人でも、Windows では CRLF・リポジトリの中は LF** にそろいます（`core.autocrlf=input` にした人だけは、書き出し時の変換をしないので LF のままになります）。

### なぜ .sh だけ LF に固定するのか

7日目に使う `make-conflict.sh` は、Git Bash（bash）で実行するスクリプトです。bash は CR（`\r`）を改行の一部と見なさないため、CRLF のスクリプトを実行すると、行末の `\r` がコマンドの一部と解釈され、次のようなエラーになることがあります。

```text
make-conflict.sh: line 2: $'\r': command not found
```

`eol=lf` を指定しておけば、Windows でクローンしてもスクリプトは LF のまま書き出されるので、この問題が起きません。

### 手元で確かめる：git ls-files --eol

各ファイルが「Git の中」と「ワーキングツリー」でどの改行コードになっているかは、`git ls-files --eol` で見られます。

```bash
cd ~/git-practice/gitlearn
git ls-files --eol README.md exercises/day07-conflict/make-conflict.sh
```

```text
i/lf    w/crlf  attr/text=auto          README.md
i/lf    w/lf    attr/text eol=lf        exercises/day07-conflict/make-conflict.sh
```

| 欄 | 意味 | 例の読み方 |
|---|---|---|
| `i/` | index（ステージ）＝Git の中での改行コード | どちらも `lf`（Git の中は LF） |
| `w/` | working tree（ワーキングツリー）での改行コード | README は `crlf`、スクリプトは `lf` |
| `attr/` | 適用されている属性 | `.gitattributes` の行がそのまま効いている |

値が `-text` ならバイナリーと判定されたファイル、`mixed` なら CRLF と LF が混ざったファイルです（出典：[git-ls-files](https://git-scm.com/docs/git-ls-files) の `--eol` の項）。

### .gitattributes を後から変えたとき

`.gitattributes` を変更しても、すでに Git に入っているファイルは自動では変換し直されません。全ファイルを新しい設定で入れ直すには、次のようにします（出典：[gitattributes](https://git-scm.com/docs/gitattributes) の「End-of-line conversion」）。

```bash
git add --renormalize .
git status
```

この勉強会の範囲では使う必要はありません。

---

<a id="lf-will-be-replaced"></a>
## 5. 「LF will be replaced by CRLF」警告の意味

`git add` をしたときに、次のような警告が出ることがあります。

```text
warning: in the working copy of 'memo.txt', LF will be replaced by CRLF the next time Git touches it
```

### 何が起きているのか

直訳すると「`memo.txt` のワーキングツリーのコピーは、次に Git がこのファイルを書き出すとき、LF が CRLF に置き換えられます」です。

1. 手元の `memo.txt` は **LF** で保存されている。
2. `core.autocrlf=true`（または `text=auto`）なので、Git の中には LF で入る。ここまでは問題なし。
3. ただし、次に Git がこのファイルを書き出すとき（ブランチの切り替えなど）は、設定どおり **CRLF** で書き出す。
4. つまり「今の手元のファイル（LF）と、次に書き出されるファイル（CRLF）は改行コードが違いますよ」というお知らせです。

**エラーではなく、ファイルの内容も失われません。** そのまま作業を続けて大丈夫です。

### どんなときに出るか

Windows でも、次のような方法で作ったファイルは LF になっていることがあります。

- Git Bash の `echo "..." > ファイル名` で作ったファイル（bash は LF で書き込みます）
- ほかのツールやサイトからダウンロード・コピーしたファイル
- VS Code で改行コードを LF にして保存したファイル

逆向きの `CRLF will be replaced by LF` が出ることもあります。これは `*.sh` のように LF に固定しているファイルを、CRLF で保存したときです。

> [!NOTE]
> 古いバージョンの Git では、同じ意味の警告が `warning: LF will be replaced by CRLF in memo.txt.` と `The file will have its original line endings in your working directory` の2行で表示されていました。ネットで調べるときは両方の形があることを覚えておくと便利です。

### 対処

- **何もしなくてかまいません**（おすすめ）。
- 気になる場合は、VS Code でそのファイルを開き、右下の `LF` をクリックして `CRLF` に変えて保存すれば、警告は出なくなります（[8章](#vscode-status-bar)）。

> [!WARNING]
> 警告を消すために `core.autocrlf` を `false` に変えるのはおすすめしません。改行コードの変換が止まり、CRLF のままコミットされるファイルが混ざる原因になります。

関連レシピ：[trouble-11 `LF will be replaced by CRLF` という警告が出る](../recipes/troubleshooting.md#trouble-11)

---

<a id="encoding"></a>
## 6. 文字コード：UTF-8、BOM、Shift_JIS

### 文字コードとは

コンピューターは文字を数値（バイト）の並びとして保存します。どの文字をどの数値にするかの決まりが **文字コード（エンコーディング、encoding）** です。同じ「あ」でも、文字コードによって保存される数値が違います。

| 文字コード | 「あ」の保存のされ方 | 主な使われ方 |
|---|---|---|
| UTF-8 | `E3 81 82`（3バイト） | 現在の標準。Git、GitHub、VS Code の既定 |
| Shift_JIS（Windows では CP932） | `82 A0`（2バイト） | 古い Windows のソフトや、昔作られた日本語ファイル |

**Git はファイルの中身の文字コードを変換しません**。保存されたバイトをそのまま記録します。そのため、Shift_JIS のファイルをコミットすると、`git diff` や GitHub の画面で文字化けして表示されます。**この教材の素材はすべて UTF-8** です。新しく作るファイルも UTF-8 で保存してください（VS Code で作れば自動で UTF-8 になります）。

### BOM（バイトオーダーマーク）

UTF-8 のファイルの先頭に、「このファイルは UTF-8 です」という目印として `EF BB BF` の3バイトが付いていることがあります。これを **BOM（Byte Order Mark）** といいます。

```text
BOM なし：              E3 81 82 ...         （「あ」から始まる）
BOM あり（UTF-8 with BOM）：EF BB BF E3 81 82 ...  （見えない目印のあとに「あ」）
```

BOM は画面には表示されませんが、次のような問題の原因になります。

- `git diff` で、1行目が変わっていないのに「変更あり」と表示される（BOM の有無だけが違う）
- シェルスクリプトの1行目（`#!/bin/bash`）が認識されなくなる
- 一部のツールで、先頭に `ï»¿` のような文字が表示される

**Git や GitHub で扱うファイルは「UTF-8（BOM なし）」にする** のが一般的です。VS Code の既定は BOM なしの UTF-8 なので、VS Code で作ったファイルなら気にする必要はありません。Excel の「CSV UTF-8」形式など、BOM を付けて保存するソフトもあるので、ほかのソフトで作ったファイルを入れるときは確認しましょう。

### Shift_JIS のファイルを UTF-8 に変換する

昔作ったファイルを VS Code で開いたら文字化けした、という場合は Shift_JIS の可能性があります。

1. VS Code の右下の文字コードの表示（`UTF-8` など）をクリックします。
2. 「エンコード付きで再度開く（Reopen with Encoding）」を選び、「Japanese (Shift JIS)」を選びます。正しく読めることを確認します。
3. もう一度右下の表示をクリックし、「エンコード付きで保存（Save with Encoding）」→「UTF-8」を選びます。

---

<a id="quotepath"></a>
## 7. core.quotepath と日本語のファイル名

### quotepath とは

Git は、ファイル名に「普通でない文字」が含まれていると、`"` で囲んで `\` で始まる記号（エスケープ）に置き換えて表示します。初期設定では、**日本語などの ASCII 以外の文字も「普通でない文字」として扱われる** ため、次のように表示されます。

```text
?? "\343\203\241\343\203\242.md"
```

これは「メモ.md」の UTF-8 のバイト（`E3 83 A1 E3 83 A2`）を8進数で書いたものです。1日目の設定 `git config --global core.quotepath false` は、「0x80 以上のバイト（日本語など）は普通の文字として扱い、そのまま表示する」という指定です（出典：[git-config の core.quotePath](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corequotePath)）。

```text
?? メモ.md
```

> [!NOTE]
> `core.quotepath false` にしても、ダブルクォート・バックスラッシュ・制御文字はエスケープされます。また `git status -s` では、スペースを含むファイル名も `"my memo.md"` のように `"` で囲んで表示されます。どちらも正常な動作です。

関連レシピ：[setup-06 日本語のファイル名が `"\343\201..."` のように表示されるのを直したい](../recipes/setup.md#setup-06)

### 日本語のファイル名で起きやすい問題

日本語のファイル名は Git でも使えますが、次の問題があるので、この教材ではファイル名を半角英数字にしています。

| 問題 | 内容 |
|---|---|
| Mac との共有 | macOS は「が」を「か」＋「゛」の2文字に分けて保存することがあり（Unicode の正規化の違い）、Windows の人とは別のファイル名として扱われることがある |
| 入力・補完のしにくさ | ターミナルで日本語入力の切り替えが必要で、Tab 補完も使いにくい |
| URL | GitHub 上の URL が `%E3%83%A1...` のような長い形になる |

### Windows ならではのファイル名の制限

日本語に限らず、Windows には次のような制限があります。Mac や Linux の人が作ったリポジトリをクローンしたときに問題になることがあります。

- **大文字・小文字を区別しない**：`Profile.md` と `profile.md` は同じファイルとみなされます（`.git/config` の `ignorecase = true`）。大文字・小文字だけを変える名前の変更は、`git mv profile.md Profile.md` のように Git に伝える必要があります。
- **使えない文字**：`\ / : * ? " < > |` はファイル名に使えません。`CON`、`PRN`、`AUX`、`NUL` などの名前も使えません。
- **パスの長さ**：フォルダの階層が深く、パス全体が 260 文字を超えると、Git for Windows は既定ではそのファイルを書き出しません（`core.longPaths` で変更できます。出典：[Git for Windows リリースノートの Known issues](https://github.com/git-for-windows/build-extra/blob/main/ReleaseNotes.md)）。練習用フォルダを `~/git-practice` のような短い場所に置いているのは、このためでもあります。

---

<a id="vscode-status-bar"></a>
## 8. VS Code 右下の表示

VS Code でファイルを開くと、ウィンドウ右下のステータスバーに次のような表示があります（執筆時点の表示です）。

```text
… 行 3、列 12   スペース: 4   UTF-8   CRLF   {} Markdown …
                               ─────   ────
                               文字コード 改行コード
```

| 表示 | 意味 | クリックすると |
|---|---|---|
| `UTF-8` / `UTF-8 with BOM` / `Shift JIS` など | このファイルの文字コード | 「エンコード付きで再度開く（Reopen with Encoding）」「エンコード付きで保存（Save with Encoding）」を選べる |
| `CRLF` / `LF` | このファイルの改行コード | 「改行コードの選択（Select End of Line Sequence）」で切り替えられる。切り替えたら保存する |

新しく作るファイルの既定値は、設定の「既定の改行文字（Files: Eol）」と「Files: Encoding」で決まります。改行文字の既定は `auto`（OS に合わせる＝Windows では CRLF）、文字コードの既定は `utf8`（BOM なし）です。この教材では変える必要はありません。

---

## 9. 試してみよう

`~/git-practice/appendix-lab/` の下に使い捨てのリポジトリを作って、改行コードの変換を目で確かめます。インストール時に推奨設定（`core.autocrlf=true`）を選んでいる前提です。作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\eol` フォルダを削除してから、もう一度最初から実行してください。

1. 練習用のフォルダを作り、リポジトリにします。

   ```bash
   mkdir -p ~/git-practice/appendix-lab/eol
   cd ~/git-practice/appendix-lab/eol
   git init
   ```

2. `printf` で LF のファイルを作って、ステージします。

   ```bash
   printf '1行目\n2行目\n' > lf.txt
   git add lf.txt
   ```

   ```text
   warning: in the working copy of 'lf.txt', LF will be replaced by CRLF the next time Git touches it
   ```

3. 改行コードの状態を見ます。手元（`w/`）も Git の中（`i/`）も LF です。

   ```bash
   git ls-files --eol
   ```

   ```text
   i/lf    w/lf    attr/                   lf.txt
   ```

4. コミットします。

   ```bash
   git commit -m "改行コードのテスト"
   ```

5. 手元のファイルを消して、Git から書き出し直します（`git restore` は「Git に記録されている内容でファイルを元に戻す」コマンドで、5日目で学びます）。

   ```bash
   rm lf.txt
   git restore lf.txt
   ```

6. もう一度状態を見ます。Git の中は LF のまま、手元は **CRLF** で書き出されています。

   ```bash
   git ls-files --eol
   ```

   ```text
   i/lf    w/crlf  attr/                   lf.txt
   ```

7. `git status` を実行しても、変更ありにはなりません。Git は改行コードの違いを変換の結果として理解しているからです。

   ```bash
   git status --short
   ```

   （何も表示されません）

8. ホームフォルダに戻ります。

   ```bash
   cd
   ```

---

## まとめ

- 改行コードは Windows が CRLF、Git の世界の標準が LF。
- `core.autocrlf=true`（インストーラーの推奨）は「Git の中は LF、手元は CRLF」に自動変換する設定で、system の設定に保存されている。
- この教材の `.gitattributes` は `* text=auto` で全員の扱いをそろえ、`*.sh` だけは手元でも LF に固定している。
- `LF will be replaced by CRLF` はエラーではなくお知らせ。放っておいてよい。
- ファイルは UTF-8（BOM なし）で保存する。Git は文字コードを変換しない。
- `core.quotepath false` で日本語のファイル名がそのまま表示される。それでもファイル名は半角英数字がおすすめ。

## 関連ページ

- [1日目：Git のインストールと初期設定](../docs/day01-install-git.md)（「インストーラーの選択肢」「日本語ファイル名と pull の設定」）
- [4日目：差分・履歴・.gitignore](../docs/day04-diff-log-ignore.md)
- [7日目：マージとコンフリクト](../docs/day07-merge-conflict.md)（`make-conflict.sh` を実行する）
- [レシピ setup-06 日本語のファイル名が `"\343\201..."` のように表示されるのを直したい](../recipes/setup.md#setup-06)
- [レシピ trouble-11 `LF will be replaced by CRLF` という警告が出る](../recipes/troubleshooting.md#trouble-11)

## 参考資料

- gitattributes（`text`、`eol`、End-of-line conversion）：<https://git-scm.com/docs/gitattributes>
- git-config（`core.autocrlf`、`core.eol`、`core.quotePath`）：<https://git-scm.com/docs/git-config>
- git-ls-files（`--eol`）：<https://git-scm.com/docs/git-ls-files>
- GitHub Docs - Configuring Git to handle line endings：<https://docs.github.com/en/get-started/git-basics/configuring-git-to-handle-line-endings>
- Git for Windows インストーラーのソース：<https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss>
- Git for Windows リリースノート（Known issues）：<https://github.com/git-for-windows/build-extra/blob/main/ReleaseNotes.md>
- VS Code Docs - Basic Editing（File encoding support）：<https://code.visualstudio.com/docs/editing/codebasics>

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
