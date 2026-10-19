# 3日目：はじめてのコミット

[← 2日目](day02-github-account.md) ｜ [README（全体の地図）](../README.md) ｜ [4日目 →](day04-diff-log-ignore.md)

## この日のゴール

- リポジトリ・コミット・3つの場所（ワーキングツリー・ステージ・リポジトリ）を自分の言葉で説明できる
- `git init` でリポジトリを作れる
- `status` → `add` → `commit` → `log` の流れで変更を記録できる
- 同じことを VS Code のソース管理ビューでもできる

## 所要時間の目安

合計 **60分**

| セクション                                    | 目安 |
| --------------------------------------------- | ---- |
| 1. リポジトリとコミットのイメージ             | 5分  |
| 2. 練習用リポジトリ my-profile を作る         | 10分 |
| 3. 3つの場所                                  | 10分 |
| 4. はじめてのコミット                         | 15分 |
| 5. 何回かコミットしてみる                     | 10分 |
| 6. VS Code のソース管理ビューで同じことをする | 10分 |

## 前提

- [1日目](day01-install-git.md)・[2日目](day02-github-account.md) が終わっている
- `~/git-practice/gitlearn`（教材の自分用コピー）がある。`ls ~/git-practice/gitlearn` で確かめられます

---

## 1. リポジトリとコミットのイメージ

ゲームの **セーブポイント** を思い浮かべてください。ボス戦の前にセーブしておけば、失敗してもそこからやり直せます。セーブデータを並べれば、どこまで進んだかの記録にもなります。

Git でも同じことをします。

| ゲーム                             | Git                          | 説明                                                                       |
| ---------------------------------- | ---------------------------- | -------------------------------------------------------------------------- |
| セーブする                         | **コミット**（commit）       | ファイルのその時点の状態を、メモ付きで記録すること。動詞は「コミットする」 |
| セーブデータの一覧                 | **履歴**（log）              | コミットを時間順に並べたもの                                               |
| セーブデータが入ったメモリーカード | **リポジトリ**（repository） | 変更履歴ごと保存されたフォルダ。Git で管理しているフォルダのこと           |

ゲームとちがうのは、Git のセーブは **自分で「何を変えたか」のメモ（コミットメッセージ）を書く** 点です。後から履歴を見たときに、どこで何をしたかがすぐにわかります。

```text
●──────────●──────────●──────────●   ← コミット（セーブポイント）が並んだ履歴
「ひな形を追加」 「ニックネームを記入」 「好きなことを追記」 「目標を記入」
```

---

## 2. 練習用リポジトリ my-profile を作る

3日目から8日目までは、自己紹介を書く練習用リポジトリ `my-profile` を使います。

### フォルダを作って git init する

> [!WARNING]
> **`~/git-practice/gitlearn` フォルダの中では `git init` しないでください。** `gitlearn` はすでにリポジトリなので、その中にリポジトリを作ると「リポジトリの入れ子」になり、混乱のもとになります。必ず `~/git-practice` の直下に、新しいフォルダを作ります。

1. VS Code のターミナル（Git Bash）を開きます。
2. `my-profile` フォルダを作ります。

```bash
mkdir ~/git-practice/my-profile
```

3. 作ったフォルダに移動します。

```bash
cd ~/git-practice/my-profile
```

4. このフォルダを Git で管理し始めます。`init` は initialize（初期化）の略です。

```bash
git init
```

次のように表示されれば成功です（ユーザー名の部分は人によって違います）。

```text
Initialized empty Git repository in C:/Users/hydr4/git-practice/my-profile/.git/
```

「空の Git リポジトリを初期化しました」という意味です。これで `my-profile` フォルダは **リポジトリ** になりました。

> [!NOTE]
> **VS Code で行う場合**：`my-profile` フォルダを VS Code で開き、ソース管理ビューの **リポジトリを初期化する（Initialize Repository）** ボタンを押しても同じことができます。この教材ではターミナルで行います。詳しくは [レシピ basics-01](../recipes/basics.md#basics-01)。

5. VS Code で `my-profile` フォルダを開きます。メニューの **ファイル（File）→ フォルダーを開く（Open Folder）** で `C:\Users\<Windowsのユーザー名>\git-practice\my-profile` を選び、**フォルダーの選択（Select Folder）** をクリックします。「作成者を信頼しますか?」と聞かれたら **はい、作成者を信頼します** をクリックします。

> [!TIP]
> フォルダを開いた VS Code で新しいターミナルを開くと、最初から `my-profile` の中にいる状態でターミナルが開きます。`$` の上の行に `~/git-practice/my-profile` と表示されていれば OK です。今日はこの後、このウィンドウのターミナルで作業します。

### .git フォルダについて

`git init` をすると、フォルダの中に **`.git`** という名前のフォルダが作られます。ここに、すべての履歴（セーブデータ）が保存されます。

1. 確認してみましょう。`ls` に `-a`（all：隠しファイルも表示）を付けます。

```bash
ls -a
```

```text
./  ../  .git/
```

`.` で始まる名前のファイルやフォルダは **隠しファイル** として扱われるため、ふつうの `ls` やエクスプローラーでは見えません（VS Code のエクスプローラーにも、初期設定では表示されません）。

> [!CAUTION]
> **`.git` フォルダは消したり、中身を手で書き換えたりしないでください。** 消すと、これまでの履歴がすべて失われます。中身が気になる人は [Appendix：Git の内部のしくみ](../appendix/git-internals.md) で安全に覗く方法を紹介しています。

---

## 3. 3つの場所：ワーキングツリー・ステージ・リポジトリ

Git には、ファイルの変更が通る **3つの場所** があります。これが Git でいちばん大事な考え方です。

```text
  ワーキングツリー             ステージ                    リポジトリ
  （作業する机の上）    （記録する物を置く台）        （記録の保管庫）
 ┌───────────────┐       ┌───────────────┐        ┌───────────────┐
 │ 実際に編集して │       │ 次のコミットに │        │ コミットされた │
 │ いるファイル   │ ────▶ │ 含める変更     │ ─────▶ │ 履歴           │
 └───────────────┘ git add └───────────────┘ git commit └───────────────┘
```

| 場所                                                                            | 説明                                                                                       |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| **ワーキングツリー**（working tree）                                            | 実際に編集しているファイルそのもの。VS Code で開いて書き換えている状態                     |
| **ステージ**（stage）／ステージングエリア（staging area、インデックスとも呼ぶ） | 「次のコミットに含める変更」を置いておく場所。変更をここに置くことを「ステージする」という |
| **リポジトリ**（repository）                                                    | コミットした履歴が保存される場所（`.git` フォルダの中）                                    |

**なぜステージがあるの？** 写真撮影にたとえると、ステージは「撮影台」です。机の上（ワーキングツリー）にいろいろな物があっても、撮りたい物だけを撮影台に乗せて、まとめて写真（コミット）に残せます。複数のファイルを変えたときに、「このファイルの変更だけ先に記録しよう」と選べるのです。

また、Git がまだ一度も記録していない新しいファイルは **追跡されていないファイル**（untracked file）と呼ばれます。`git add` すると、Git がそのファイルを追跡（管理）し始めます。

もっと詳しく知りたい人は [Appendix：3つの場所](../appendix/three-areas.md) を見てください。

---

## 4. はじめてのコミット

### 素材をコピーする

教材のコピー（`gitlearn`）から、自己紹介のひな形 `profile.md` を `my-profile` にコピーします。

1. 次のコマンドを実行します。`cp` は copy（コピー）の略で、`cp コピー元 コピー先` の形で使います。

```bash
cp ~/git-practice/gitlearn/exercises/day03-first-commit/profile.md ~/git-practice/my-profile/
```

2. コピーできたか確認します。

```bash
ls
```

```text
profile.md
```

> [!NOTE]
> **VS Code で行う場合**：エクスプローラー（Windows）で `C:\Users\<Windowsのユーザー名>\git-practice\gitlearn\exercises\day03-first-commit\profile.md` をコピーし、`my-profile` フォルダに貼り付けても同じです。

内容の書き換えは、最初のコミットの後に行います。まずは、ひな形のままコミットしてみましょう。

### git status で状態を見る

**`git status`** は、今のリポジトリの状態（何が変わったか、何がステージされているか）を教えてくれるコマンドです。**迷ったら、まず `git status`** を合言葉にしましょう。

1. 状態を確認します。

```bash
git status
```

```text
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	profile.md

nothing added to commit but untracked files present (use "git add" to track)
```

読み方：

| 表示                            | 意味                                                                     |
| ------------------------------- | ------------------------------------------------------------------------ |
| `On branch main`                | 今 `main` というブランチにいる（ブランチは6日目に学びます）              |
| `No commits yet`                | まだコミットが1つもない                                                  |
| `Untracked files:`              | 追跡されていないファイル（Git がまだ記録していない新しいファイル）の一覧 |
| `(use "git add <file>..." ...)` | 次にやることのヒント。「`git add` すればコミットに含められるよ」         |

VS Code の左側のエクスプローラーでは、`profile.md` の横に緑色の **U**（Untracked）が表示されます。

### git add でステージする

1. `profile.md` をステージします。

```bash
git add profile.md
```

何も表示されなければ成功です。

2. もう一度状態を見てみましょう。

```bash
git status
```

```text
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   profile.md
```

`Changes to be committed:`（コミットされる予定の変更）の下に `new file: profile.md`（新しいファイル）が表示されました。ステージに乗った状態です。

> [!TIP]
> 変更したファイルをまとめて全部ステージしたいときは、`git add .`（`.` は「今いるフォルダ全体」の意味）も使えます。ただし、意図しないファイルまで入りやすいので、慣れるまではファイル名を指定するのがおすすめです。詳しくは [レシピ basics-03](../recipes/basics.md#basics-03)。

### git commit で記録する

1. ステージした内容をコミットします。`-m` の後ろの `"..."` がコミットメッセージです。

```bash
git commit -m "自己紹介のひな形を追加"
```

```text
[main (root-commit) a1b2c3d] 自己紹介のひな形を追加
 1 file changed, 22 insertions(+)
 create mode 100644 profile.md
```

| 表示                               | 意味                                                                                                                        |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `[main (root-commit) a1b2c3d]`     | `main` ブランチの最初のコミット（root-commit）。`a1b2c3d` は **ハッシュ**（コミットの ID）の先頭7文字で、人によって違います |
| `1 file changed, 22 insertions(+)` | 1つのファイルが変わり、22行が追加された（行数は素材によって違います）                                                       |

2. 状態を確認します。

```bash
git status
```

```text
On branch main
nothing to commit, working tree clean
```

「コミットするものはない、ワーキングツリーはきれい（すべて記録済み）」という意味です。これで最初のセーブ完了です。

> [!NOTE]
> **`Author identity unknown` と表示されてコミットできない場合**は、1日目の名前とメールアドレスの設定ができていません。→ [レシピ trouble-02](../recipes/troubleshooting.md#trouble-02)

**`-m` を付け忘れた場合**

`git commit` とだけ入力すると、1日目に設定したとおり **VS Code に `COMMIT_EDITMSG` というタブが開き**、ターミナルには次のように表示されて止まります。

```text
hint: Waiting for your editor to close the file...
```

あわてずに、次のようにします。

1. 開いた `COMMIT_EDITMSG` タブの **1行目** にコミットメッセージを書きます（`#` で始まる行は無視されるので、そのままでかまいません）。
2. `Ctrl+S` で保存します。
3. タブの × をクリックしてタブを閉じます。
4. ターミナルに戻ると、コミットが完了しています。

やめたいときは、メッセージを何も書かずに保存して閉じれば、コミットは中止されます（`Aborting commit due to empty commit message.` と表示されます）。

> [!TIP]
> 見慣れない黒い画面のエディタ（Vim）が開いてしまったときは [レシピ trouble-10](../recipes/troubleshooting.md#trouble-10) を見てください。

---

## 5. 何回かコミットしてみる

ここからは、`profile.md` を自分の内容に書き換えながら、「編集 → `status` → `add` → `commit`」を繰り返します。

1. VS Code のエクスプローラーで `profile.md` をクリックして開きます。
2. 「ニックネーム」の下の「（ここを自分の内容に書き換える）」を、自分のニックネームに書き換えます。
3. `Ctrl+S` で保存します。

> [!CAUTION]
> 本名のフルネーム、電話番号、住所、学籍番号などの **個人情報は書かないでください**。8日目に GitHub に送ります。

4. 状態を確認します。

```bash
git status
```

```text
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   profile.md

no changes added to commit (use "git add" and/or "git commit -a")
```

`modified:`（変更された）と表示されています。ワーキングツリーで変更したけれど、まだステージしていない状態です。VS Code のエクスプローラーでは、ファイル名の横に **M**（Modified）が表示されます。

5. ステージして、コミットします。

```bash
git add profile.md
```

```bash
git commit -m "ニックネームを記入"
```

```text
[main 4e5f6a7] ニックネームを記入
 1 file changed, 1 insertion(+), 1 deletion(-)
```

「1行追加して1行削除した」＝1行を書き換えた、という意味です。

6. 同じように「好きなこと」を書き換えて、保存 → `git add profile.md` → `git commit -m "好きなことを追記"` を行います。

### git log で履歴を見る

**`git log`** は、コミットの履歴を新しい順に表示するコマンドです。

1. 履歴を表示します。

```bash
git log
```

```text
commit 8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c (HEAD -> main)
Author: Taro Yamada <12345678+hydr4@users.noreply.github.com>
Date:   Tue Oct 13 21:10:00 2026 +0900

    好きなことを追記

commit 4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f
Author: Taro Yamada <12345678+hydr4@users.noreply.github.com>
Date:   Tue Oct 13 21:05:00 2026 +0900

    ニックネームを記入

commit a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0
Author: Taro Yamada <12345678+hydr4@users.noreply.github.com>
Date:   Tue Oct 13 21:00:00 2026 +0900

    自己紹介のひな形を追加
```

| 表示                | 意味                                                         |
| ------------------- | ------------------------------------------------------------ |
| `commit 8b9c0d1...` | コミットのハッシュ（40文字の ID。人によって違います）        |
| `(HEAD -> main)`    | 今いる場所（最新のコミット）を表す目印                       |
| `Author:`           | コミットした人（1日目・2日目に設定した名前とメールアドレス） |
| `Date:`             | コミットした日時                                             |
| 字下げされた行      | コミットメッセージ                                           |

> [!TIP]
> 履歴が長いと、画面の最後に `:` が表示されて止まります。これは「続きがあります」という意味です。`Space` キーで次のページ、`↑` `↓` キーで1行ずつ動かせます。**`q` キーを押すと抜けられます**（[レシピ trouble-09](../recipes/troubleshooting.md#trouble-09)）。

2. 1つのコミットを1行で表示する `--oneline` も便利です。

```bash
git log --oneline
```

```text
8b9c0d1 (HEAD -> main) 好きなことを追記
4e5f6a7 ニックネームを記入
a1b2c3d 自己紹介のひな形を追加
```

ハッシュは先頭の7文字ほどに省略されます。いくつもの見方は [レシピ basics-05](../recipes/basics.md#basics-05) にまとめています。

---

## 6. VS Code のソース管理ビューで同じことをする

ここまでの「`status` → `add` → `commit`」は、VS Code の画面でもできます。

1. `profile.md` の「この勉強会での目標」を書き換えて、`Ctrl+S` で保存します。
2. 左端のアクティビティバーの **ソース管理**（Source Control）アイコンをクリックします（`Ctrl+Shift+G` でも開きます）。アイコンに数字の **1** が付いているはずです。これは「変更が1つある」という意味です。
3. **変更（Changes）** の下に `profile.md` が表示されています。これが `git status` の `modified` にあたります。
4. `profile.md` の行にマウスを乗せると、右側にアイコンが出ます。**+**（**変更をステージ**（Stage Changes））をクリックします。これが `git add` にあたります。
5. `profile.md` が **ステージされている変更（Staged Changes）** の下に移動しました。
6. 上の **メッセージ**（Message）と書かれた入力欄に、コミットメッセージを入力します。例：`目標を記入`
7. **✓ コミット（Commit）** ボタンをクリックします。これが `git commit` にあたります。
8. 変更の一覧が空になれば、コミット完了です。

ターミナルで確認してみましょう。

```bash
git log --oneline
```

```text
c3d4e5f (HEAD -> main) 目標を記入
8b9c0d1 好きなことを追記
4e5f6a7 ニックネームを記入
a1b2c3d 自己紹介のひな形を追加
```

VS Code でのコミットも、ターミナルでのコミットと同じ履歴に記録されています。

> [!NOTE]
> ステージせずに **✓ コミット** を押すと、「ステージされている変更がなく、コミットできません。すべての変更をステージして、直接コミットしますか?」と聞かれます。**はい（Yes）** を選ぶと、変更をすべてステージしてからコミットします。最初のうちは、自分で **+** を押してステージする習慣をつけましょう。

> [!TIP]
> ソース管理ビューの下のほうにある **グラフ**（Graph）の欄では、コミットの履歴を図で見られます（表示されない場合は、ソース管理ビューの右上の「…」から表示を切り替えられます）。

---

## 演習

[演習：3日目 はじめてのコミット](../exercises/day03-first-commit/README.md) に取り組みましょう。このページの手順どおりに進めていれば、ほとんど終わっているはずです。完了条件を確認してください。

## 確認チェックリスト

- [ ] `~/git-practice/my-profile` で `ls -a` を実行すると `.git/` が表示される
- [ ] `git log --oneline` で3つ以上のコミットが表示される
- [ ] 少なくとも1回は、VS Code のソース管理ビューからコミットした
- [ ] `git status` が `nothing to commit, working tree clean` になっている
- [ ] ワーキングツリー・ステージ・リポジトリの違いと、`git add`・`git commit` がそれぞれ何をするかを説明できる
- [ ] `git log` の画面から `q` で抜けられる

## よくあるつまずき

**`fatal: not a git repository (or any of the parent directories): .git` と表示される**
- 原因：リポジトリではないフォルダでコマンドを実行しています。
- 対処：`pwd` で今いる場所を確認し、`cd ~/git-practice/my-profile` で移動してからやり直します。→ [レシピ trouble-03](../recipes/troubleshooting.md#trouble-03)

**`Author identity unknown` と表示されてコミットできない**
- 原因：名前やメールアドレスが設定されていません。
- 対処：→ [レシピ trouble-02](../recipes/troubleshooting.md#trouble-02)

**`git commit` したら `nothing added to commit but untracked files present` や `no changes added to commit` と表示された**
- 原因：`git add` を忘れています。
- 対処：`git status` を見て、`git add ファイル名` でステージしてから、もう一度 `git commit` します。

**`git add` しても何も起きない／`git status` に何も出ない**
- 原因：ファイルを **保存** していない可能性があります。VS Code のタブに ● が付いていたら、未保存です。
- 対処：`Ctrl+S` で保存してから、もう一度 `git status` を見ます。

**`git log` の画面から抜けられない**
- 対処：`q` キーを押します。→ [レシピ trouble-09](../recipes/troubleshooting.md#trouble-09)

**まちがえて `gitlearn` の中で `git init` してしまった**
- 対処：`gitlearn` の中に作った練習用フォルダ（例：`~/git-practice/gitlearn/my-profile`）をエクスプローラーで削除し、`~/git-practice/my-profile` に作り直します。`gitlearn` 自体の `.git` は消さないでください。

**`warning: in the working copy of 'profile.md', LF will be replaced by CRLF the next time Git touches it` と表示される**
- 改行コードについての警告で、そのまま進めて問題ありません。→ [レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)

## もっと知りたい人へ

- [Appendix：3つの場所](../appendix/three-areas.md)：ファイルの4つの状態と、ステージがある理由
- [Appendix：Git の内部のしくみ](../appendix/git-internals.md)：`.git` フォルダの中身、コミットの正体
- レシピ
  - [basics-01 フォルダを Git で管理し始めたい](../recipes/basics.md#basics-01)
  - [basics-02 今の状態（何が変わったか）を確認したい](../recipes/basics.md#basics-02)
  - [basics-03 変更をステージしてコミットしたい](../recipes/basics.md#basics-03)
  - [basics-05 コミット履歴を見やすく表示したい](../recipes/basics.md#basics-05)
  - [trouble-02 `Author identity unknown` と出てコミットできない](../recipes/troubleshooting.md#trouble-02)
  - [trouble-03 `fatal: not a git repository` と出る](../recipes/troubleshooting.md#trouble-03)
  - [trouble-09 `git log` などの画面から抜けられない](../recipes/troubleshooting.md#trouble-09)

---
[← 2日目](day02-github-account.md) ｜ [README](../README.md) ｜ [4日目 →](day04-diff-log-ignore.md)
