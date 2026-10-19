# レシピ集：記録する・確かめる

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

リポジトリを作る、状態や差分を確かめる、コミットする、履歴を見る、ファイルを無視する、についてのレシピです。

- [basics-01 フォルダを Git で管理し始めたい](#basics-01)
- [basics-02 今の状態（何が変わったか）を確認したい](#basics-02)
- [basics-03 変更をステージしてコミットしたい（全部／一部のファイルだけ）](#basics-03)
- [basics-04 変更内容（差分）を見たい](#basics-04)
- [basics-05 コミット履歴を見やすく表示したい（1行表示・グラフ・ファイルで絞り込み）](#basics-05)
- [basics-06 あるコミットで何を変えたかを見たい](#basics-06)
- [basics-07 管理したくないファイルを無視したい（.gitignore）](#basics-07)
- [basics-08 コミット済みのファイルを、手元に残したまま管理対象から外したい](#basics-08)

> [!NOTE]
> コマンドはすべて VS Code 内の Git Bash で、**リポジトリのフォルダに `cd` してから** 実行します。例では `~/git-practice/my-profile` を使います。画面の説明は執筆時点（2026年10月）の表示です。出力例のハッシュ値（`a1b2c3d` など）は人によって違います。

---

<a id="basics-01"></a>
## basics-01 フォルダを Git で管理し始めたい

**こんなとき**：新しいフォルダを作って、その中のファイルの変更履歴を Git で記録し始めたいとき。

**Git Bash**：

```bash
mkdir -p ~/git-practice/my-profile
cd ~/git-practice/my-profile
git init
```

```text
Initialized empty Git repository in C:/Users/hydr4/git-practice/my-profile/.git/
```

フォルダの中に `.git` という隠しフォルダができていれば成功です（`ls -a` で見えます）。この `.git` フォルダが、リポジトリ（repository：変更履歴ごと保存されたフォルダ）の本体です。

**VS Code**：

1. 「ファイル（File）」→「フォルダーを開く（Open Folder）」で、管理したいフォルダを開きます。
2. 左のアクティビティバーで「ソース管理（Source Control）」（`Ctrl+Shift+G`）を開きます。
3. 「リポジトリを初期化する（Initialize Repository）」ボタンを選びます。

**注意点**：

- **リポジトリの中で `git init` しないでください**。特に `~/git-practice/gitlearn`（教材のコピー）の中に練習用リポジトリを作ると、リポジトリが入れ子になって混乱します。`git init` の前に `git status` を実行して、`fatal: not a git repository` と出る（＝まだリポジトリではない）ことを確かめると安全です。
- `.git` フォルダを消すと、履歴がすべて消えます。触らないでください。
- OneDrive と同期されているフォルダは避けます → [setup-07](setup.md#setup-07)
- GitHub にあるリポジトリを手元に持ってくる場合は `git init` ではなく `git clone` を使います → [remote-01](remote.md#remote-01)

**関連**：[3日目](../docs/day03-first-commit.md)、[Appendix：Git の内部のしくみ](../appendix/git-internals.md)、[trouble-03](troubleshooting.md#trouble-03)

---

<a id="basics-02"></a>
## basics-02 今の状態（何が変わったか）を確認したい

**こんなとき**：どのファイルを変更したか、何がステージ済みか、今どのブランチにいるかを知りたいとき。迷ったらまずこれです。

**Git Bash**：

```bash
git status
```

```text
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   hobbies.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   profile.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	memo.md
```

読み方：

| 表示                            | 意味                                                |
| ------------------------------- | --------------------------------------------------- |
| `On branch main`                | 今いるブランチ                                      |
| `Changes to be committed`       | ステージ済み（次のコミットに入る）                  |
| `Changes not staged for commit` | 変更したが、まだステージしていない                  |
| `Untracked files`               | Git がまだ管理していない新しいファイル（untracked） |

短く表示したいときは `-s` を付けます。

```bash
git status -s
```

```text
M  hobbies.md
 M profile.md
?? memo.md
```

左の列がステージの状態、右の列がワーキングツリー（working tree：実際に編集しているファイル）の状態です。`??` は untracked です。

**VS Code**：

1. 「ソース管理（Source Control）」ビュー（`Ctrl+Shift+G`）を開きます。
2. 「ステージされている変更（Staged Changes）」と「変更（Changes）」に分かれてファイルが並びます。
3. ファイル名の右の文字が状態を表します（`M`＝変更、`U`＝未追跡、`A`＝追加、`D`＝削除）。
4. 今のブランチ名は、画面左下のステータスバーに表示されます。

**注意点**：

- `git status` は何も変更しない安全なコマンドです。困ったら何度でも実行してください。
- 出力の `(use "git ...")` の行には、次にできる操作のヒントが書かれています。
- `fatal: not a git repository` と出たら、リポジトリの外にいます → [trouble-03](troubleshooting.md#trouble-03)

**関連**：[3日目](../docs/day03-first-commit.md)、[Appendix：3つの場所](../appendix/three-areas.md)

---

<a id="basics-03"></a>
## basics-03 変更をステージしてコミットしたい（全部／一部のファイルだけ）

**こんなとき**：変更を記録（コミット）したいとき。複数のファイルを変えたけれど、一部だけを先にコミットしたいとき。

**Git Bash**：

一部のファイルだけをステージ（stage：次のコミットに入れる準備）してコミットします。

```bash
git add profile.md
git commit -m "自己紹介に趣味を追加"
```

```text
[main a1b2c3d] 自己紹介に趣味を追加
 1 file changed, 2 insertions(+)
```

変更したファイルを **全部** ステージしてコミットします（`.` は「このフォルダ以下すべて」の意味です）。

```bash
git add .
git commit -m "趣味のページを追加"
```

ステージする前に、何がステージされたかを確認する習慣をつけましょう。

```bash
git status
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューを開きます。
2. 「変更（Changes）」の中のファイルにマウスを乗せ、「＋」（変更をステージ（Stage Changes））を選びます。全部ステージするときは「変更」の見出しの「＋」（すべての変更をステージ（Stage All Changes））を選びます。
3. 上のメッセージ欄にコミットメッセージを書きます。
4. 「✓ コミット（Commit）」ボタンを選びます。

1つのファイルの中の **一部の行だけ** をステージしたいときは、ファイルを選んで差分を表示し、ステージしたい行を選択して右クリック →「選択した範囲をステージする（Stage Selected Ranges）」を選びます。

**注意点**：

- `git add .` は、無視していない新しいファイルも全部ステージします。うっかり入れたくないファイルがないか、`git status` で確かめてからコミットしてください。管理したくないファイルは `.gitignore` に書きます → [basics-07](#basics-07)
- `-m` を付けずに `git commit` すると、メッセージを書くエディタが開きます → [setup-03](setup.md#setup-03)
- コミットメッセージは「何をしたか」を日本語で短く書きます（例：「自己紹介に趣味を追加」）。
- ステージし忘れたファイルがあったときは → [undo-03](undo.md#undo-03)、ステージしすぎたときは → [undo-02](undo.md#undo-02)
- VS Code で何もステージせずに「コミット」を押すと、「すべての変更をステージして、直接コミットしますか？」と聞かれます。「はい」を選ぶと全部がコミットされるので、意図どおりか確認してください。
- `Author identity unknown` と出るときは → [trouble-02](troubleshooting.md#trouble-02)

**関連**：[3日目](../docs/day03-first-commit.md)、[Appendix：3つの場所](../appendix/three-areas.md)、[Appendix：よいコミットの書き方](../appendix/commit-best-practices.md)

---

<a id="basics-04"></a>
## basics-04 変更内容（差分）を見たい

**こんなとき**：コミットする前に、どこをどう変えたかを1行ずつ確かめたいとき。

**Git Bash**：

まだステージしていない変更を見ます。

```bash
git diff
```

```text
diff --git a/profile.md b/profile.md
index bea1df4..656cffb 100644
--- a/profile.md
+++ b/profile.md
@@ -1 +1,2 @@
 # 自己紹介
+趣味：読書
```

`+` の行が追加、`-` の行が削除された行です。

ステージ済みの変更（次のコミットに入る内容）を見ます。

```bash
git diff --staged
```

ステージ済みかどうかに関係なく、最後のコミットからのすべての変更を見ます。

```bash
git diff HEAD
```

特定のファイルだけを見たいときは、最後に `--` とファイル名を付けます。

```bash
git diff -- profile.md
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューを開きます。
2. 「変更（Changes）」または「ステージされている変更（Staged Changes）」のファイル名を選びます。
3. 左に変更前、右に変更後が並んだ画面が開きます（赤が削除、緑が追加）。

**注意点**：

- `git diff` に何も表示されないのに変更したはずのときは、すでにステージ済みかもしれません。`git diff --staged` を試してください。
- 新しく作ったファイル（untracked）は `git diff` に出てきません。`git add` すると `git diff --staged` で見えます。
- 表示が長くて画面の下に `:` が出たら、`q` で抜けられます → [trouble-09](troubleshooting.md#trouble-09)

**関連**：[4日目](../docs/day04-diff-log-ignore.md)、[Appendix：3つの場所](../appendix/three-areas.md)

---

<a id="basics-05"></a>
## basics-05 コミット履歴を見やすく表示したい（1行表示・グラフ・ファイルで絞り込み）

**こんなとき**：これまでのコミットを一覧で見たいとき。ブランチの分かれ方を図で見たいとき。特定のファイルを変えたコミットだけを見たいとき。

**Git Bash**：

1コミット1行で表示します。

```bash
git log --oneline
```

```text
72cd3f8 (HEAD -> main) 趣味を追加
15caa63 自己紹介を書き換え
f3b1fd6 自己紹介を追加
```

ブランチの分かれ方をグラフで、すべてのブランチ分を表示します（この教材の定番です）。

```bash
git log --oneline --graph --all
```

```text
*   2dba84e (HEAD -> main) Merge branch 'add-favorites'
|\
| * e113608 (add-favorites) 好きなものリストを追加
* | 5dec255 自己紹介を更新
|/
* 1748a52 趣味を追加
```

特定のファイルを変更したコミットだけを表示します。

```bash
git log --oneline -- profile.md
```

最新の3件だけを表示します。

```bash
git log --oneline -3
```

**VS Code**：

- **リポジトリ全体の履歴**：「ソース管理（Source Control）」ビューの下の方にある「ソース管理グラフ（Source Control Graph）」の欄に、グラフ付きで表示されます。欄が閉じていたら見出しを選んで開きます。
- **ファイルごとの履歴**：エクスプローラーでファイルを選び、エクスプローラーの下の方の「タイムライン（Timeline）」を開くと、そのファイルを変えたコミットが並びます。

**注意点**：

- 画面の下に `:` や `(END)` が出て止まったら、`q` を押すと抜けられます → [trouble-09](troubleshooting.md#trouble-09)
- `--all` を付けないと、今いるブランチから見える履歴だけが表示されます。ほかのブランチが見えないときは `--all` を付けてください。
- 左の英数字（ハッシュ）は、コミットを指定するときに使います → [basics-06](#basics-06)

**関連**：[3日目](../docs/day03-first-commit.md)、[4日目](../docs/day04-diff-log-ignore.md)、[7日目](../docs/day07-merge-conflict.md)、[trouble-09](troubleshooting.md#trouble-09)

---

<a id="basics-06"></a>
## basics-06 あるコミットで何を変えたかを見たい

**こんなとき**：履歴の中の1つのコミットについて、メッセージ・日時・変更内容を詳しく見たいとき。

**Git Bash**：

まず `git log --oneline` で、見たいコミットのハッシュ（左の7文字ほどの英数字）を確かめます。

```bash
git log --oneline
```

```text
72cd3f8 (HEAD -> main) 趣味を追加
15caa63 自己紹介を書き換え
```

そのハッシュを指定して中身を見ます。次の `15caa63` は例なので、**自分の画面に表示されたハッシュに置き換えて** 実行してください。

```bash
git show 15caa63
```

最新のコミットなら、ハッシュの代わりに `HEAD`（今いる場所）を使えます。1つ前は `HEAD~1` です。

```bash
git show HEAD
```

変更したファイルの一覧と行数だけを見たいときは `--stat` を付けます。

```bash
git show --stat HEAD
```

```text
commit 72cd3f886006fd048cf7fd4a4b4fbef8a958bae7 (HEAD -> main)
Author: hydr4 <12345678+hydr4@users.noreply.github.com>
Date:   Tue Oct 13 15:21:48 2026 +0900

    趣味を追加

 profile.md | 1 +
 1 file changed, 1 insertion(+)
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューの「ソース管理グラフ（Source Control Graph）」で、見たいコミットを選びます。
2. そのコミットで変わったファイルが並ぶので、ファイルを選ぶと変更前と変更後が並んで表示されます。

ファイルの「タイムライン（Timeline）」でコミットを選んでも、そのファイルの変更内容が表示されます。

**注意点**：

- ハッシュは全部（40文字）書かなくても、先頭の7文字ほどで指定できます。
- 表示が長いときは `q` で抜けます → [trouble-09](troubleshooting.md#trouble-09)

**関連**：[4日目](../docs/day04-diff-log-ignore.md)、[Appendix：Git の内部のしくみ](../appendix/git-internals.md)

---

<a id="basics-07"></a>
## basics-07 管理したくないファイルを無視したい（.gitignore）

**こんなとき**：ログファイル、個人的なメモ、パスワードの入ったファイルなどを、うっかりコミットしないようにしたいとき。`git status` にいつも出てきて邪魔なとき。

**Git Bash**：

リポジトリの一番上のフォルダに `.gitignore` というファイルを作り、無視したいファイル名やパターンを1行に1つ書きます。VS Code で作成・編集します。

```bash
code .gitignore
```

`.gitignore` の中身の例です。

```text
# ログファイルはすべて無視する
*.log

# 個人的なメモ
private-memo.txt
```

保存したら、無視されているか確かめます。

```bash
git status
git check-ignore -v debug.log
```

```text
.gitignore:2:*.log	debug.log
```

（`.gitignore` の何行目のどのパターンで無視されたかが表示されます。何も表示されなければ、無視されていません。）

`.gitignore` 自体はコミットして、チームと共有します。

```bash
git add .gitignore
git commit -m ".gitignore を追加"
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューの「変更（Changes）」で、無視したいファイルを右クリックします。
2. 「.gitignore に追加（Add to .gitignore）」を選びます。`.gitignore` がなければ作られ、そのファイル名が追記されます。
3. `.gitignore` をステージしてコミットします。

**よく使う書き方**：

| 書き方      | 意味                                         |
| ----------- | -------------------------------------------- |
| `debug.log` | その名前のファイル（どのフォルダにあっても） |
| `*.log`     | `.log` で終わるすべてのファイル              |
| `tmp/`      | `tmp` という名前のフォルダの中身すべて       |
| `# ...`     | コメント（無視される）                       |

**注意点**：

- `.gitignore` は **まだコミットしていないファイル** にだけ効きます。すでにコミットしたファイルは、書き足しても無視されません → [basics-08](#basics-08)
- ファイル名は `.gitignore`（先頭にドット、拡張子なし）です。`gitignore.txt` などになっていると効きません。
- パスワードやトークンを誤ってコミットして push してしまった場合は、`.gitignore` に書くだけでは GitHub 上の履歴から消えません。すぐにそのパスワードやトークンを無効にして（変更して）、運営者に相談してください。

**関連**：[4日目](../docs/day04-diff-log-ignore.md)、[basics-08](#basics-08)

---

<a id="basics-08"></a>
## basics-08 コミット済みのファイルを、手元に残したまま管理対象から外したい

**こんなとき**：`debug.log` などをうっかりコミットしてしまい、`.gitignore` に書いたのに `git status` に出続けるとき。ファイル自体は消さずに、Git の管理からだけ外したいとき。

**Git Bash**：

1. まず `.gitignore` に、外したいファイルを書いておきます（[basics-07](#basics-07)）。
2. ファイルを管理対象から外します（`--cached` は「手元のファイルは消さない」という意味です）。

```bash
git rm --cached debug.log
```

```text
rm 'debug.log'
```

フォルダごと外すときは `-r` を付けます。

```bash
git rm -r --cached logs/
```

3. 状態を確認します。`debug.log` は `D`（削除）としてステージされ、手順1で書き換えた `.gitignore` は ` M`（変更あり・未ステージ）と表示されます（`.gitignore` を今回新しく作った場合は `?? .gitignore` と表示されます）。

```bash
git status -s
```

```text
 M .gitignore
D  debug.log
```

   続けて `ls` を実行し、`debug.log` が手元に残っていることも確かめます。

```bash
ls
```

4. `.gitignore` の変更と一緒にコミットします。

```bash
git add .gitignore
git commit -m "debug.log を管理対象から外す"
```

**VS Code**：GUI での操作はありません。ターミナルで実行します。

**注意点**：

- **`--cached` を付け忘れると、手元のファイルも削除されます**。必ず付けてください。
- 管理対象から外れるのは「これからのコミット」だけです。過去のコミットには、そのファイルが残っています。
- このコミットを push したあと、ほかの人が pull すると、**ほかの人の手元ではそのファイルが削除されます**。チームで使うファイルの場合は、事前に声をかけてください。

**関連**：[4日目](../docs/day04-diff-log-ignore.md)、[basics-07](#basics-07)
