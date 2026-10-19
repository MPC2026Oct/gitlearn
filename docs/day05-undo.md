# 5日目：取り消しとやり直し

[← 4日目](day04-diff-log-ignore.md) ｜ [README（全体の地図）](../README.md) ｜ [6日目 →](day06-branch.md)

## この日のゴール

- 「どこにある変更を戻したいか」で、取り消しの方法を選べる
- `git restore`・`git restore --staged`・`git commit --amend`・`git revert`・`git reset --soft` を使える
- GitHub に送った（push した）後かどうかで、使ってよい方法が変わることを説明できる

## 所要時間の目安

合計 **60分**

| セクション | 目安 |
|---|---|
| 1. 取り消しの全体像 | 10分 |
| 2〜6. 各コマンド（演習のシナリオ1〜5と一緒に） | 40分 |
| 7. git reflog | 5分 |
| 8. VS Code での取り消し操作 | 5分 |

## 前提

- [3日目](day03-first-commit.md)・[4日目](day04-diff-log-ignore.md) が終わっている
- `~/git-practice/my-profile` で `git status` が `nothing to commit, working tree clean` になっている

**今日の進め方**：このページで各コマンドの意味を読み、各セクションの最後にある「やってみよう」で [演習：5日目](../exercises/day05-undo/README.md) の対応するシナリオに取り組みます。ページと演習を行ったり来たりしながら進めてください。

始める前に、VS Code で `my-profile` フォルダを開き、ターミナル（Git Bash）で次を実行しておきます。

```bash
cd ~/git-practice/my-profile
```

> [!TIP]
> 取り消しの操作をする前には、必ず `git status` と `git log --oneline` で **今の状態を確認する** 習慣をつけましょう。どの場所に変更があるかがわかれば、使うコマンドが決まります。

---

## 1. 取り消しの全体像

3日目に学んだ「3つの場所」を思い出してください。取り消しの方法は、**戻したい変更が今どこにあるか** で決まります。

```text
  ワーキングツリー          ステージ               リポジトリ（コミット）
 ┌──────────────┐     ┌──────────────┐     ┌──────────────────────────┐
 │ 編集した内容  │     │ add した内容  │     │ 直前のコミット／過去のコミット │
 └──────────────┘     └──────────────┘     └──────────────────────────┘
   git restore      git restore --staged   git commit --amend（直前を直す）
                                           git reset --soft（直前を取り消す）
                                           git revert（打ち消すコミットを追加）
```

| 戻したいもの | 方法 | 何が起きるか | GitHub に送った（push した）後でも使える？ |
|---|---|---|---|
| ワーキングツリーの編集（まだ `add` していない） | `git restore ファイル名` | 編集を捨てて、最後に記録した状態に戻す | （push とは関係なし） |
| ステージした内容 | `git restore --staged ファイル名` | ステージから外す。編集内容はワーキングツリーに残る | （push とは関係なし） |
| 直前のコミット（メッセージやファイルの入れ忘れ） | `git commit --amend` | 直前のコミットを作り直す（**履歴を書き換える**） | **使わない** |
| 直前のコミット（コミットをなかったことに） | `git reset --soft HEAD~1` | コミットを取り消し、変更はステージに残す（**履歴を書き換える**） | **使わない** |
| 過去のコミット | `git revert コミット` | そのコミットを打ち消す **新しいコミットを追加** する（履歴は書き換えない） | **使える** |

**push（プッシュ）** とは、手元のコミットを GitHub に送ることです（8日目に学びます）。GitHub に送ったコミットは、ほかの人がすでに受け取っているかもしれません。そこで履歴を書き換えると、ほかの人の履歴と食い違ってしまいます。そのため、

- **まだ送っていないコミット**：`--amend` や `reset` で自由に直してよい
- **送った後のコミット**：`revert` で「打ち消すコミット」を追加する

というのが基本のルールです。今はまだ GitHub に送っていないので、どれを使っても大丈夫です。

> [!NOTE]
> **破壊的な操作と安全な操作**：`git restore ファイル名` や `git reset --hard` は、記録していない変更を **消してしまう**（元に戻せない）操作です。`git restore --staged`、`git reset --soft`、`git revert` は、変更内容を失わない安全な操作です。実行前に、どちらの種類かを意識しましょう。

---

## 2. 編集を取り消す：git restore

**こんなとき**：ファイルを編集したけれど、まちがえてしまったので、最後にコミットした状態に戻したい（まだ `git add` していない）。

1. 状態を確認します。

```bash
git status
```

```text
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   hobbies.md

no changes added to commit (use "git add" and/or "git commit -a")
```

`git status` のヒントに `use "git restore <file>..." to discard changes`（変更を捨てるには `git restore`）と書かれています。

2. 編集を取り消します。

```bash
git restore hobbies.md
```

何も表示されなければ成功です。VS Code で開いている `hobbies.md` も、最後のコミットの状態に戻ります。

3. 確認します。

```bash
git status
```

```text
On branch main
nothing to commit, working tree clean
```

> [!WARNING]
> `git restore ファイル名` で捨てた編集は、**Git に記録されていないので、元に戻せません。** 本当に捨ててよいか、`git diff` で確かめてから実行しましょう。

**やってみよう**：[演習](../exercises/day05-undo/README.md) の「シナリオ1」（詳しくは [レシピ undo-01](../recipes/undo.md#undo-01)）

---

## 3. ステージを取り消す：git restore --staged

**こんなとき**：関係ないファイルまで `git add` してしまった。ステージから外したい（編集内容は残したい）。

1. 状態を確認します（例：`scratch.txt` と `profile.md` をステージしてしまった場合）。

```bash
git status
```

```text
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   profile.md
	new file:   scratch.txt
```

ヒントに `use "git restore --staged <file>..." to unstage`（ステージを取り消すには `git restore --staged`）と書かれています。

2. `scratch.txt` だけをステージから外します。

```bash
git restore --staged scratch.txt
```

3. 確認します。

```bash
git status
```

```text
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   profile.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	scratch.txt
```

`profile.md` はステージに残り、`scratch.txt` は「追跡されていないファイル」に戻りました。**ファイルの中身は消えていません。**

> [!TIP]
> 演習では、練習用に作った `scratch.txt` を最後に削除します。ファイルを削除するコマンドは `rm`（remove）です。
>
> ```bash
> rm scratch.txt
> ```
>
> `rm` で消したファイルはごみ箱に入らないので、ファイル名をよく確かめてから実行してください。

**やってみよう**：[演習](../exercises/day05-undo/README.md) の「シナリオ2」（詳しくは [レシピ undo-02](../recipes/undo.md#undo-02)）

---

## 4. 直前のコミットを直す：git commit --amend

**こんなとき**：コミットした直後に、メッセージの誤字に気づいた。またはファイルを入れ忘れた。

`--amend`（アメンド：修正する）は、**直前のコミットを作り直す** オプションです。

**メッセージを直す場合**

1. 直前のコミットのメッセージを確認します。

```bash
git log --oneline -1
```

```text
d4e5f6a (HEAD -> main) 自己紹会を更新
```

2. 正しいメッセージで作り直します。

```bash
git commit --amend -m "自己紹介を更新"
```

```text
[main e5f6a7b] 自己紹介を更新
 Date: Tue Oct 13 22:00:00 2026 +0900
 1 file changed, 1 insertion(+), 1 deletion(-)
```

3. 確認します。

```bash
git log --oneline -2
```

```text
e5f6a7b (HEAD -> main) 自己紹介を更新
b7c8d9e 自己紹介に1行追記
```

コミットの数は増えず、メッセージだけが直りました。**ハッシュが `d4e5f6a` から `e5f6a7b` に変わっている** ことに注目してください。`--amend` は元のコミットを直すのではなく、**新しいコミットに置き換えている** のです。これが「履歴を書き換える」ということです。

**ファイルを入れ忘れた場合**

入れ忘れたファイルをステージしてから、`--no-edit`（メッセージはそのまま）を付けて `--amend` します。

```bash
git add hobbies.md
```

```bash
git commit --amend --no-edit
```

> [!NOTE]
> `-m` も `--no-edit` も付けずに `git commit --amend` とすると、VS Code にメッセージの編集画面（`COMMIT_EDITMSG`）が開きます。1行目を直して保存し、タブを閉じれば完了です。

> [!CAUTION]
> `--amend` は履歴を書き換えます。**GitHub に送った（push した）コミットには使いません。**

> [!TIP]
> **`git commit -am "メッセージ"` について**：演習では `git commit -am` という書き方が出てきます。`-a` は「すでに追跡しているファイルの変更を、自動でステージしてからコミットする」オプションで、`-m` と組み合わせて `-am` と書けます。`git add` を省略できて便利ですが、**新しいファイル（untracked）はステージされない** ことに注意してください。

**やってみよう**：[演習](../exercises/day05-undo/README.md) の「シナリオ3」（詳しくは [レシピ undo-03](../recipes/undo.md#undo-03)）

---

## 5. コミットを打ち消す：git revert

**こんなとき**：あるコミットの変更を取り消したい。ただし、そのコミットはもう GitHub に送ってしまった（またはその可能性がある）。

`git revert`（リバート：元に戻す）は、指定したコミットと **逆の変更をするコミットを新しく追加** します。元のコミットは消さないので、履歴を書き換えません。

```text
 revert 前：  A ── B ── C          （C を取り消したい）
 revert 後：  A ── B ── C ── C'    （C' は「C を打ち消す」コミット。内容は B の状態に戻る）
```

1. 最新のコミット（`HEAD`）を打ち消します。**HEAD**（ヘッド）は「今いる場所＝最新のコミット」を表す名前です（6日目に詳しく学びます）。

```bash
git revert HEAD
```

2. VS Code に `COMMIT_EDITMSG` というタブが開きます。1行目に `Revert "自己紹介を更新"` のようなメッセージがすでに書かれています。**そのまま `Ctrl+S` で保存して、タブを閉じます。**

```text
[main f6a7b8c] Revert "自己紹介を更新"
 1 file changed, 1 insertion(+), 1 deletion(-)
```

3. 履歴を確認します。

```bash
git log --oneline -3
```

```text
f6a7b8c (HEAD -> main) Revert "自己紹介を更新"
e5f6a7b 自己紹介を更新
b7c8d9e 自己紹介に1行追記
```

「自己紹介を更新」のコミットは残ったまま、それを打ち消す `Revert "..."` のコミットが増えました。`profile.md` の中身は、「自己紹介を更新」の前の状態に戻っています。

> [!TIP]
> - エディタを開かずに、自動のメッセージのままコミットしたいときは `git revert --no-edit HEAD` と書けます。
> - 最新以外のコミットを打ち消すときは、`HEAD` の代わりにハッシュを指定します（例：`git revert e5f6a7b`。ハッシュは `git log --oneline` で確認し、自分のものに置き換えます）。

> [!NOTE]
> **VS Code で行う場合**：`revert` には、VS Code の標準のボタンはありません。ターミナルで実行してください。

**やってみよう**：[演習](../exercises/day05-undo/README.md) の「シナリオ4」（詳しくは [レシピ undo-05](../recipes/undo.md#undo-05)、ファイルを過去の状態に戻したいときは [レシピ undo-06](../recipes/undo.md#undo-06)）

---

## 6. コミットを取り消す：git reset（push 前だけ）

**こんなとき**：直前のコミットを「なかったこと」にして、やり直したい（まだ GitHub に送っていない）。

`git reset`（リセット）は、**今いる場所（HEAD）を過去のコミットに戻す** コマンドです。`HEAD~1` は「HEAD の1つ前のコミット」という意味です。

```text
 reset 前：  A ── B ── C   ← HEAD
 reset 後：  A ── B        ← HEAD    （C の変更はステージに残る：--soft の場合）
```

### --soft と --mixed

1. 直前のコミットを取り消し、変更はステージに残します。

```bash
git reset --soft HEAD~1
```

何も表示されなければ成功です。

2. 確認します。

```bash
git status
```

```text
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   hobbies.md
```

コミットだけが取り消され、変更はステージに残っています。ここから書き足して、あらためてコミットできます。

`reset` には、変更をどこに残すかで3つのモードがあります。

| モード | コミット | ステージ | ワーキングツリー（ファイルの中身） | 使いどころ |
|---|---|---|---|---|
| `--soft` | 取り消す | **残る** | **残る** | コミットだけやり直したい |
| `--mixed`（何も付けないときと同じ） | 取り消す | 取り消す | **残る** | ステージからやり直したい |
| `--hard` | 取り消す | 取り消す | **消える** | 変更をすべて捨てたい（危険） |

### --hard は最後の手段

書き方は `git reset --hard HEAD~1` です（**今日は実行しないでください**）。`--hard` は、コミットだけでなく **ステージとワーキングツリーの変更もすべて消します**。保存していた編集もすべて失われます。この勉強会の演習では使いません。「どうしてもすべてをなかったことにしたい」ときの最後の手段だと覚えておいてください。

> [!CAUTION]
> - `git reset` は履歴を書き換えます。**GitHub に送った（push した）コミットには使いません。** 送った後は `git revert` を使います。
> - `--hard` は、まだコミットしていない変更を **元に戻せない形で消します**。使う前に `git status` で、消えて困る変更がないか必ず確認してください。

**やってみよう**：[演習](../exercises/day05-undo/README.md) の「シナリオ5」（詳しくは [レシピ undo-04](../recipes/undo.md#undo-04)）

---

## 7. 困ったときの命綱：git reflog

`reset` や `--amend` で「消してしまった」と思ったコミットも、実はしばらくの間は Git の中に残っています。**`git reflog`**（リフログ：参照の記録）は、HEAD がこれまでどこを指してきたかの記録を表示します。

```bash
git reflog
```

```text
f6a7b8c (HEAD -> main) HEAD@{0}: reset: moving to HEAD~1
1b2c3d4 HEAD@{1}: commit: 趣味を追記
f6a7b8c HEAD@{2}: revert: Revert "自己紹介を更新"
e5f6a7b HEAD@{3}: commit (amend): 自己紹介を更新
d4e5f6a HEAD@{4}: commit: 自己紹会を更新
```

（ハッシュや行の数は人によって違います。`q` で抜けられます。）

`reset` で取り消した「趣味を追記」のコミット（`1b2c3d4`）も、ここに記録されています。このハッシュを使えば、取り消したコミットを取り戻せます。具体的な取り戻し方は [レシピ undo-08](../recipes/undo.md#undo-08) と [Appendix：取り消しの詳細](../appendix/undo-in-depth.md) を見てください。今日は「**こういう命綱がある**」とだけ覚えておけば十分です。

> [!NOTE]
> `reflog` に残るのは **コミットしたもの** だけです。一度もコミットしていない編集を `git restore` や `git reset --hard` で消した場合は、取り戻せません。

---

## 8. VS Code での取り消し操作

ソース管理ビューでも、よく使う取り消し操作ができます（ラベルは執筆時点の表示です）。

| やりたいこと | 対応するコマンド | VS Code での操作 |
|---|---|---|
| 編集を取り消す | `git restore ファイル名` | **変更（Changes）** の下のファイルにマウスを乗せ、**↶ 変更を破棄（Discard Changes）** アイコンをクリック → 確認画面で **ファイルの破棄** などを選ぶ |
| ステージを取り消す | `git restore --staged ファイル名` | **ステージされている変更（Staged Changes）** の下のファイルにマウスを乗せ、**−（変更のステージング解除（Unstage Changes））** アイコンをクリック |
| 直前のコミットを直す | `git commit --amend` | ✓ **コミット** ボタンの右の **∨** をクリック → **コミット (修正)（Commit (Amend)）** |
| 直前のコミットを取り消す | `git reset --soft HEAD~1` | ソース管理ビュー上部の **…（その他の操作）** → **コミット（Commit）** → **前回のコミットを元に戻す（Undo Last Commit）**。変更はステージに残ります |
| コミットを打ち消す | `git revert` | 標準のボタンはありません。ターミナルで実行します |

> [!WARNING]
> **変更を破棄（Discard Changes）** は `git restore` と同じで、**元に戻せません**。新しいファイル（untracked）に対して使うと、そのファイル自体が削除されます。確認画面の文をよく読んでからクリックしましょう。

> 出典：VS Code Docs「Staging and committing changes」 <https://code.visualstudio.com/docs/sourcecontrol/staging-commits>

---

## 演習

[演習：5日目 取り消しとやり直し](../exercises/day05-undo/README.md) のシナリオ1〜5に、まだ取り組んでいないものがあれば取り組みましょう。最後に `git status` が `nothing to commit, working tree clean` になっていることを確認してください（`scratch.txt` は削除済みのはずです）。

## 確認チェックリスト

- [ ] 演習のシナリオ1〜5の完了条件をすべて満たした
- [ ] `git log --oneline` に `Revert "..."` で始まるコミットがある
- [ ] `git status` が `nothing to commit, working tree clean` になっていて、`scratch.txt` が残っていない
- [ ] 「ワーキングツリー」「ステージ」「直前のコミット」「過去のコミット」のそれぞれについて、取り消しに使うコマンドを言える
- [ ] `git revert` は push した後でも使えるが、`git commit --amend` と `git reset` は使わない理由を説明できる

## よくあるつまずき

**`git revert` を実行したら、ターミナルが止まって何も入力できない**
- 原因：VS Code でコミットメッセージの編集画面（`COMMIT_EDITMSG`）が開いて、閉じられるのを待っています（`hint: Waiting for your editor to close the file...`）。
- 対処：VS Code の `COMMIT_EDITMSG` タブを保存して閉じます。見慣れない黒い画面のエディタ（Vim）が開いた場合は [レシピ trouble-10](../recipes/troubleshooting.md#trouble-10)。

**`git restore` したのに、ファイルの中身が戻らない**
- 原因：その変更はすでにステージされています。
- 対処：先に `git restore --staged ファイル名` でステージを取り消してから、`git restore ファイル名` を実行します。

**`--amend` でメッセージを直したら、コミットが2つになった**
- 原因：`--amend` を付けずに `git commit` をもう一度実行しています。
- 対処：まだ GitHub に送っていなければ、`git reset --soft HEAD~1` で最新のコミットを取り消し、`git commit --amend -m "正しいメッセージ"` で直します。

**`reset` や `--amend` で、必要なコミットまで消してしまった**
- 対処：あわてずに `git reflog` で消えたコミットのハッシュを探します。→ [レシピ undo-08](../recipes/undo.md#undo-08)

**作業の途中で、変更を一時的にどこかに退避したい**
- 対処：`git stash` という方法があります。→ [レシピ undo-07](../recipes/undo.md#undo-07)

**`git add scratch.txt` で `warning: in the working copy of 'scratch.txt', LF will be replaced by CRLF the next time Git touches it` と表示される**
- 原因：`echo` で作ったファイルの改行コードが LF で、Windows の Git が CRLF に変換することを知らせています。
- 対処：エラーではないので、無視してかまいません。→ [レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)

**`fatal: ambiguous argument 'HEAD~1': unknown revision` と表示される**
- 原因：コミットが1つしかないため、「1つ前」がありません。
- 対処：`git log --oneline` でコミットが2つ以上あるか確認します。

## もっと知りたい人へ

- [Appendix：取り消しの詳細](../appendix/undo-in-depth.md)：`reset` の3モードと3つの場所の関係図、`revert` との違い、`reflog` で取り戻す方法、`stash`、push 後に履歴を書き換えてはいけない理由
- レシピ
  - [undo-01 編集中のファイルを最後のコミットの状態に戻したい](../recipes/undo.md#undo-01)
  - [undo-02 ステージを取り消したい](../recipes/undo.md#undo-02)
  - [undo-03 直前のコミットを直したい（メッセージの修正・ファイルの入れ忘れ）](../recipes/undo.md#undo-03)
  - [undo-04 直前のコミットを取り消したい（まだ push していない）](../recipes/undo.md#undo-04)
  - [undo-05 push 済みのコミットを打ち消したい](../recipes/undo.md#undo-05)
  - [undo-06 ファイルを過去のコミットの状態に戻したい](../recipes/undo.md#undo-06)
  - [undo-07 作業途中の変更を一時的に退避したい（stash）](../recipes/undo.md#undo-07)
  - [undo-08 消してしまったコミットやブランチを取り戻したい（reflog）](../recipes/undo.md#undo-08)

---
[← 4日目](day04-diff-log-ignore.md) ｜ [README](../README.md) ｜ [6日目 →](day06-branch.md)
