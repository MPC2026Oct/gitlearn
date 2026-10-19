# 4日目：差分・履歴・.gitignore

[← 3日目](day03-first-commit.md) ｜ [README（全体の地図）](../README.md) ｜ [5日目 →](day05-undo.md)

## この日のゴール

- `git diff` と `git diff --staged` の違いを説明できる
- `git log` のオプションと `git show` で履歴を読める
- 「よいコミット」の単位を意識してコミットできる
- `.gitignore` で、管理したくないファイルを無視できる

## 所要時間の目安

合計 **45〜60分**

| セクション                         | 目安 |
| ---------------------------------- | ---- |
| 準備（素材のコピー）               | 5分  |
| 1. 差分を見る：git diff            | 15分 |
| 2. 履歴を読む：git log と git show | 10分 |
| 3. よいコミットの単位とメッセージ  | 5分  |
| 4. .gitignore                      | 15分 |
| 確認                               | 5分  |

## 前提

- [3日目](day03-first-commit.md) が終わっている（`~/git-practice/my-profile` に2つ以上のコミットがある）
- `git status` が `nothing to commit, working tree clean` になっている

---

## 準備：素材をコピーする

今日も `my-profile` で練習します。

1. VS Code で `my-profile` フォルダを開きます（**ファイル → フォルダーを開く** で `C:\Users\<Windowsのユーザー名>\git-practice\my-profile`）。
2. ターミナル（Git Bash）を開き、`my-profile` にいることを確かめます。

```bash
cd ~/git-practice/my-profile
```

3. 今日の素材3つをコピーします。最後の `.` は「今いるフォルダへ」という意味です。

```bash
cp ~/git-practice/gitlearn/exercises/day04-diff-and-ignore/hobbies.md .
```

```bash
cp ~/git-practice/gitlearn/exercises/day04-diff-and-ignore/debug.log .
```

```bash
cp ~/git-practice/gitlearn/exercises/day04-diff-and-ignore/private-memo.txt .
```

4. 状態を確認します。

```bash
git status
```

```text
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	debug.log
	hobbies.md
	private-memo.txt

nothing added to commit but untracked files present (use "git add" to track)
```

3つとも「追跡されていないファイル」です。`debug.log` と `private-memo.txt` は **記録したくないファイル** という想定です。後半の「4.」で扱うので、**まだ `git add` しないでください。**

5. まず `hobbies.md` だけをステージしてコミットします。

```bash
git add hobbies.md
```

```bash
git commit -m "趣味ページを追加"
```

```text
[main 5d6e7f8] 趣味ページを追加
 1 file changed, 14 insertions(+)
 create mode 100644 hobbies.md
```

（ハッシュ `5d6e7f8` は人によって違います。）

---

## 1. 差分を見る：git diff

**差分**（diff：ディフ）とは、「ファイルのどこが、どう変わったか」のことです。コミットする前に差分を確かめる習慣をつけると、まちがった変更を記録しにくくなります。

### ステージ前の差分

1. VS Code で `hobbies.md` を開き、「好きな趣味」の3行目 `- （ここを自分の内容に書き換える）` を、自分の趣味に書き換えます。例：`- ギターを弾くこと`
2. `Ctrl+S` で保存します。
3. 差分を表示します。

```bash
git diff
```

```text
diff --git a/hobbies.md b/hobbies.md
index b69bd4f..061c7e0 100644
--- a/hobbies.md
+++ b/hobbies.md
@@ -7,7 +7,7 @@

 - 散歩
 - 映画を見ること
-- （ここを自分の内容に書き換える）
+- ギターを弾くこと

 ## 最近ハマっていること
```

読み方：

| 表示                                    | 意味                                                                           |
| --------------------------------------- | ------------------------------------------------------------------------------ |
| `--- a/hobbies.md` / `+++ b/hobbies.md` | `a` が変更前、`b` が変更後                                                     |
| `@@ -7,7 +7,7 @@`                       | 変更前の7行目から7行分、変更後の7行目から7行分を表示している、という位置の情報 |
| `-` で始まる行（赤色）                  | 削除された行                                                                   |
| `+` で始まる行（緑色）                  | 追加された行                                                                   |
| 何も付いていない行                      | 変わっていない行（前後の様子がわかるように表示される）                         |

1行を書き換えると、「古い行を削除して、新しい行を追加した」として表示されます。

`git diff`（オプションなし）は、**ワーキングツリーとステージの差**、つまり「編集したけれど、まだステージしていない変更」を表示します。

### ステージ後の差分（--staged）

1. 変更をステージします。

```bash
git add hobbies.md
```

2. もう一度 `git diff` を実行します。

```bash
git diff
```

**何も表示されません。** 変更はすべてステージに移ったので、「まだステージしていない変更」はなくなったからです。

3. ステージした変更を見るには、`--staged` を付けます。

```bash
git diff --staged
```

```text
diff --git a/hobbies.md b/hobbies.md
index b69bd4f..061c7e0 100644
--- a/hobbies.md
+++ b/hobbies.md
@@ -7,7 +7,7 @@

 - 散歩
 - 映画を見ること
-- （ここを自分の内容に書き換える）
+- ギターを弾くこと

 ## 最近ハマっていること
```

`git diff --staged` は、**ステージと最新のコミットの差**、つまり「次のコミットに入る予定の変更」を表示します。

```text
  ワーキングツリー ──(git diff)── ステージ ──(git diff --staged)── 最新のコミット
```

| コマンド            | 見えるもの                             | こんなときに               |
| ------------------- | -------------------------------------- | -------------------------- |
| `git diff`          | まだステージしていない変更             | 「今どこを編集したっけ？」 |
| `git diff --staged` | ステージ済みで、次にコミットされる変更 | コミットする直前の最終確認 |

4. 確認できたら、コミットします。

```bash
git commit -m "趣味を1つ書き換え"
```

> [!TIP]
> 差分が長いときは `git log` と同じように画面が止まります。`q` で抜けられます。

### VS Code で差分を見る

VS Code では、差分を左右に並べて見られます。

1. `hobbies.md` の「最近ハマっていること」を書き換えて保存します。
2. 左端の **ソース管理** アイコンをクリックします。
3. **変更（Changes）** の下の `hobbies.md` をクリックします。
4. 左に変更前（最新のコミットの内容）、右に変更後（今のファイル）が並んで表示されます。削除された部分は赤、追加された部分は緑で色が付きます。
5. **+**（変更をステージ）を押してステージした後に、**ステージされている変更（Staged Changes）** の下の `hobbies.md` をクリックすると、`git diff --staged` にあたる差分が表示されます。
6. 確認できたら、メッセージ欄に `最近ハマっていることを記入` と入力して **✓ コミット** をクリックします。

> [!NOTE]
> エディタの行番号の横に付く色の線（緑＝追加、青＝変更、赤い三角＝削除）も、最新のコミットとの差分を表しています。クリックすると、その場所の差分が表示されます。

詳しくは [レシピ basics-04](../recipes/basics.md#basics-04) を見てください。

---

## 2. 履歴を読む：git log と git show

### 1行表示とグラフ表示

3日目に使った `git log --oneline` に加えて、この勉強会の **定番の表示方法** を覚えましょう。

```bash
git log --oneline --graph --all
```

```text
* 9a0b1c2 (HEAD -> main) 最近ハマっていることを記入
* 7f8a9b0 趣味を1つ書き換え
* 5d6e7f8 趣味ページを追加
* c3d4e5f 目標を記入
* 8b9c0d1 好きなことを追記
* 4e5f6a7 ニックネームを記入
* a1b2c3d 自己紹介のひな形を追加
```

| オプション  | 意味                             |
| ----------- | -------------------------------- |
| `--oneline` | 1つのコミットを1行で表示する     |
| `--graph`   | 履歴のつながりを線（`*` や `     | `）で表示する |
| `--all`     | すべてのブランチの履歴を表示する |

今はまっすぐ1本の履歴なので `*` が縦に並ぶだけですが、6日目でブランチを作ると、枝分かれした図になります。

ほかにも、次のような表示ができます。

| コマンド         | 表示されるもの                       |
| ---------------- | ------------------------------------ |
| `git log -3`     | 新しい順に3件だけ                    |
| `git log --stat` | 各コミットで変わったファイル名と行数 |

### 1つのコミットの中身を見る

**`git show`** は、1つのコミットの情報と、そのとき何を変えたか（差分）を表示します。

1. `git log --oneline` で、「趣味を1つ書き換え」のコミットの **ハッシュ**（先頭の7文字）を確認します。
2. そのハッシュを指定して `git show` を実行します。下の `7f8a9b0` を、自分の画面に表示されたハッシュに置き換えてから実行します。

```bash
git show 7f8a9b0
```

```text
commit 7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a
Author: Taro Yamada <12345678+hydr4@users.noreply.github.com>
Date:   Tue Oct 13 21:30:00 2026 +0900

    趣味を1つ書き換え

diff --git a/hobbies.md b/hobbies.md
index b69bd4f..061c7e0 100644
--- a/hobbies.md
+++ b/hobbies.md
@@ -7,7 +7,7 @@

 - 散歩
 - 映画を見ること
-- （ここを自分の内容に書き換える）
+- ギターを弾くこと

 ## 最近ハマっていること
```

上半分が `git log` と同じコミットの情報、下半分がそのコミットでの差分です。

> [!TIP]
> - ハッシュは、マウスで選択して `Ctrl+C`、入力欄で `Ctrl+V` で貼り付けると楽です。
> - ハッシュを省略して `git show` とだけ入力すると、最新のコミットが表示されます。
> - **ハッシュ**は、コミットの内容から計算される ID です。同じ内容でも日時や作者が違えば別の値になるので、人によって違います。

### ファイルごとの履歴

特定のファイルに関係するコミットだけを見ることもできます。`--` の後ろにファイル名を書きます。

```bash
git log --oneline -- profile.md
```

```text
c3d4e5f 目標を記入
8b9c0d1 好きなことを追記
4e5f6a7 ニックネームを記入
a1b2c3d 自己紹介のひな形を追加
```

```bash
git log --oneline -- hobbies.md
```

```text
9a0b1c2 (HEAD -> main) 最近ハマっていることを記入
7f8a9b0 趣味を1つ書き換え
5d6e7f8 趣味ページを追加
```

> [!NOTE]
> **VS Code で行う場合**：ファイルを開いた状態で、左のエクスプローラーの下のほうにある **タイムライン（Timeline）** を開くと、そのファイルのコミットの一覧が表示されます。項目をクリックすると、そのコミットでの差分が見られます。

詳しくは [レシピ basics-05](../recipes/basics.md#basics-05)、[レシピ basics-06](../recipes/basics.md#basics-06) を見てください。

---

## 3. よいコミットの単位とメッセージ

コミットは、後から履歴を読む人（未来の自分やチームの仲間）のための記録です。次の2つを意識すると、読みやすい履歴になります。

**1. 1つのコミットには1つの目的**

| よくない例                                                          | よい例                                                                            |
| ------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| 「自己紹介と趣味ページとあれこれを更新」（3つの目的が混ざっている） | 「ニックネームを記入」「趣味を1つ書き換え」「最近ハマっていることを記入」に分ける |
| 1週間分の変更をまとめて1コミット                                    | 意味のあるまとまりができるたびにコミット                                          |

1つの目的ごとにコミットしておくと、5日目で学ぶ「取り消し」もしやすくなります。

**2. メッセージは「何をしたか」を短く**

| よくない例              | よい例                   |
| ----------------------- | ------------------------ |
| `更新` / `修正` / `aaa` | `自己紹介に趣味を追加`   |
| `いろいろ直した`        | `趣味ページの誤字を修正` |

この勉強会では、**日本語で「何をしたか」を短く**（20〜30文字くらい）書くことにします。

> [!TIP]
> ステージは「この変更だけを今回のコミットに入れる」ためのしくみでした。複数のファイルを変えたときは、目的ごとに `git add` → `git commit` を分けてみましょう。

もっと詳しくは [Appendix：よいコミットの書き方](../appendix/commit-best-practices.md) を見てください。

---

## 4. 管理したくないファイルを無視する：.gitignore

フォルダの中には、Git で記録したくないファイルもあります。

- ソフトが自動で作るログファイル（例：`debug.log`）
- 人に見せたくないメモやパスワードなど（例：`private-memo.txt`）
- パソコンが勝手に作るファイル（例：`Thumbs.db`、`desktop.ini`）

こうしたファイルは、**`.gitignore`**（ギット・イグノア）というファイルに書いておくと、Git が無視してくれます。

```bash
git status
```

```text
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	debug.log
	private-memo.txt

nothing added to commit but untracked files present (use "git add" to track)
```

今は、毎回この2つが表示されてじゃまです。`git add .` でうっかり記録してしまう危険もあります。

### .gitignore を書く

1. VS Code のエクスプローラーで、`MY-PROFILE` の見出しにマウスを乗せ、**新しいファイル**（New File）アイコンをクリックします。
2. ファイル名に `.gitignore` と入力して `Enter` を押します（先頭の `.` を忘れずに）。
3. 開いた `.gitignore` に、次の2行を書きます。

```text
*.log
private-memo.txt
```

4. `Ctrl+S` で保存します。

| 書き方             | 意味                                                                  |
| ------------------ | --------------------------------------------------------------------- |
| `*.log`            | `*` は「何文字でも」の意味。`.log` で終わるすべてのファイルを無視する |
| `private-memo.txt` | この名前のファイルを無視する                                          |

> [!NOTE]
> **Git Bash で作る場合**：次のコマンドでも同じ内容の `.gitignore` が作れます。`printf` は文字を出力するコマンド、`>` は出力をファイルに書き込む記号です。
>
> ```bash
> printf '%s\n' '*.log' 'private-memo.txt' > .gitignore
> ```
>
> Windows のエクスプローラーでは、`.` で始まる名前のファイルを作りにくいので、VS Code か Git Bash で作るのがおすすめです。

### 無視されているか確かめる

1. 状態を確認します。

```bash
git status
```

```text
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.gitignore

nothing added to commit but untracked files present (use "git add" to track)
```

`debug.log` と `private-memo.txt` が一覧から消え、代わりに `.gitignore` が表示されました。VS Code のエクスプローラーでも、無視されたファイルは灰色で表示されます。

2. どのルールで無視されているかを確かめます。`check-ignore -v` は「なぜ無視されているか」を表示するコマンドです。

```bash
git check-ignore -v debug.log private-memo.txt
```

```text
.gitignore:1:*.log	debug.log
.gitignore:2:private-memo.txt	private-memo.txt
```

「`.gitignore` の1行目の `*.log` によって `debug.log` が無視されている」という意味です。何も表示されないファイルは、無視されていません。

### .gitignore 自体はコミットする

`.gitignore` は「このリポジトリではこのファイルを無視する」というルールなので、**それ自体はコミットして記録します**。そうすれば、8日目以降にほかのパソコンやチームの仲間とも同じルールを共有できます。

1. ステージしてコミットします。

```bash
git add .gitignore
```

```bash
git commit -m ".gitignore を追加"
```

2. 状態を確認します。

```bash
git status
```

```text
On branch main
nothing to commit, working tree clean
```

`debug.log` と `private-memo.txt` はフォルダの中にあるのに、「きれい」と表示されます。これで無視の設定は完了です。

> [!WARNING]
> `.gitignore` は、**まだ一度もコミットしていないファイル** にだけ効きます。すでにコミットしたファイルを後から `.gitignore` に書いても、無視されません。その場合の対処は [レシピ basics-08](../recipes/basics.md#basics-08) を見てください。

詳しくは [レシピ basics-07](../recipes/basics.md#basics-07) を見てください。

---

## 演習

[演習：4日目 差分・履歴・.gitignore](../exercises/day04-diff-and-ignore/README.md) に取り組みましょう。このページの手順どおりに進めていれば、ほとんど終わっているはずです。完了条件を確認してください。

## 確認チェックリスト

- [ ] `git diff` と `git diff --staged` が、それぞれどの段階の変更を表示するのかを説明できる
- [ ] `git log --oneline --graph --all` で、「趣味ページを追加」と「趣味を1つ書き換え」のコミットが表示される
- [ ] `git show` にハッシュを指定して、1つのコミットの差分を表示できた
- [ ] `git check-ignore -v debug.log private-memo.txt` で、2つのファイルが `.gitignore` のどの行で無視されているかが表示される
- [ ] `git status` が `nothing to commit, working tree clean` で、`debug.log` と `private-memo.txt` が表示されない
- [ ] `git log --stat` を見ても、`debug.log` と `private-memo.txt` がどのコミットにも含まれていない

## よくあるつまずき

**`git diff` を実行しても何も表示されない**
- 原因：すでにステージ済み（`git add` した）か、ファイルを保存していません。
- 対処：`git status` を見ます。ステージ済みなら `git diff --staged` を使います。VS Code のタブに ● が付いていたら `Ctrl+S` で保存します。

**`git diff` や `git log` の画面から抜けられない**
- 対処：`q` キーを押します。→ [レシピ trouble-09](../recipes/troubleshooting.md#trouble-09)

**`.gitignore` を書いたのに、`debug.log` が `git status` に表示される**
- 原因1：`.gitignore` を保存していないか、ファイル名がまちがっています（`gitignore`、`.gitignore.txt` など）。`ls -a` で `.gitignore` という名前になっているか確かめてください。
- 原因2：すでに `debug.log` を `git add` してしまっています。まだコミットしていなければ、`git restore --staged debug.log` でステージを取り消せます（5日目で詳しく学びます）。コミットしてしまった場合は [レシピ basics-08](../recipes/basics.md#basics-08)。

**`git show` で `fatal: ambiguous argument` や `unknown revision` と表示される**
- 原因：ハッシュの入力をまちがえています。
- 対処：`git log --oneline` で表示されたハッシュをコピーして貼り付けます。

**`warning: in the working copy of '...', LF will be replaced by CRLF the next time Git touches it` と表示される**
- 改行コードについての警告です。そのまま進めて問題ありません。→ [レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)、[Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md)

## もっと知りたい人へ

- [Appendix：よいコミットの書き方](../appendix/commit-best-practices.md)：コミットの単位、メッセージの書き方、Conventional Commits
- [Appendix：3つの場所](../appendix/three-areas.md)：`git diff`・`git diff --staged`・`git diff HEAD` の比較
- [Appendix：改行コードと文字コード](../appendix/line-endings-and-encoding.md)：`LF will be replaced by CRLF` 警告の意味
- レシピ
  - [basics-04 変更内容（差分）を見たい](../recipes/basics.md#basics-04)
  - [basics-05 コミット履歴を見やすく表示したい](../recipes/basics.md#basics-05)
  - [basics-06 あるコミットで何を変えたかを見たい](../recipes/basics.md#basics-06)
  - [basics-07 管理したくないファイルを無視したい（.gitignore）](../recipes/basics.md#basics-07)
  - [basics-08 コミット済みのファイルを、手元に残したまま管理対象から外したい](../recipes/basics.md#basics-08)
  - [trouble-11 `LF will be replaced by CRLF` という警告が出る](../recipes/troubleshooting.md#trouble-11)

---
[← 3日目](day03-first-commit.md) ｜ [README](../README.md) ｜ [5日目 →](day05-undo.md)
