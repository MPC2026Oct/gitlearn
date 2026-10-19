# 取り消しの詳細：reset・revert・restore・reflog・stash・clean

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[5日目「取り消しとやり直し」](../docs/day05-undo.md) を読んだ人
>
> **読む時間の目安**：約30分（手を動かして試す場合は +20分）

5日目では「どこにある変更を戻したいか」で取り消し方法を選ぶ、という使い分けを学びました。このページでは、それぞれのコマンドが **3つの場所（ワーキングツリー・ステージ・リポジトリ）のどこを、どう書き換えているのか** を図と実験で確かめます。しくみがわかると、「このコマンドで何が消えるのか」「消えたものは取り戻せるのか」を自分で判断できるようになります。

## このページでわかること

- `git reset` の3つのモード（`--soft` / `--mixed` / `--hard`）が、3つの場所のどこを動かすのか
- `git revert` と `git reset` の根本的な違い
- `git restore` と `git switch` が生まれた経緯（昔の `git checkout` との対応）
- `git reflog` で「消えた」コミットやブランチを取り戻す方法と、その限界
- `git stash`（一時退避）と `git clean`（追跡されていないファイルの削除）
- 「push した後に履歴を書き換えてはいけない」理由

---

## 1. おさらい：3つの場所と HEAD

取り消し操作を理解するには、次の図を頭に置いておくのが近道です（詳しくは [Appendix：3つの場所](three-areas.md)）。

```text
  ワーキングツリー           ステージ（インデックス）        リポジトリ（コミットの履歴）
 （実際に編集している        （次のコミットに入れる          A ── B ── C
   ファイル）                  予定の内容）                           ↑
                                                                main（ブランチ）
                                                                     ↑
                                                                   HEAD
```

- **HEAD**（ヘッド）は「今いる場所」を指す目印です。ふだんは「今いるブランチ」を指し、そのブランチが最新のコミットを指しています。
- **ブランチ** は「あるコミットを指す名札」です（[Appendix：ブランチとマージ](branches-and-merge.md)）。
- 新しくコミットすると、ブランチの名札が新しいコミットへ進み、HEAD もそれについていきます。

取り消しのコマンドは、この「名札（ブランチ）」「ステージ」「ワーキングツリー」のどれを書き換えるかで性格が決まります。

## 2. 取り消しコマンドの地図

| コマンド | ブランチ（HEAD）が指すコミット | ステージ | ワーキングツリー | 履歴を書き換えるか | 危険度 |
|---|---|---|---|---|---|
| `git restore <ファイル>` | 変えない | 変えない | ステージの内容に戻す | しない | 未コミットの編集が消える |
| `git restore --staged <ファイル>` | 変えない | HEAD の内容に戻す | 変えない | しない | 安全 |
| `git commit --amend` | 新しいコミットに置き換える | — | — | **する** | push 前なら安全 |
| `git revert <コミット>` | 打ち消しコミットを **追加** する | 更新 | 更新 | しない | 安全（push 後も使える） |
| `git reset --soft <コミット>` | 指定したコミットへ移す | 変えない | 変えない | **する** | push 前なら安全 |
| `git reset --mixed <コミット>` | 指定したコミットへ移す | 戻す | 変えない | **する** | push 前なら安全 |
| `git reset --hard <コミット>` | 指定したコミットへ移す | 戻す | 戻す | **する** | 未コミットの変更が消える |
| `git stash` | 変えない | HEAD に戻す（内容は退避） | HEAD に戻す（内容は退避） | しない | 安全（退避を忘れやすい） |
| `git clean -f` | 変えない | 変えない | 追跡されていないファイルを削除 | しない | 削除したファイルは戻らない |

表の中の `<ファイル>` や `<コミット>` は説明のための書き方です。実際のコマンドは、次の節からの実験で具体的に示します。

> [!IMPORTANT]
> 「危険度」が高いのは、**一度もコミットしていない変更を消す操作**（`restore`、`reset --hard`、`clean`）です。コミットした内容はたいてい [reflog](#reflog) で取り戻せますが、コミットしていない編集は Git の記録に残っていないため、取り戻せません。

---

<a id="lab-setup"></a>

## 3. 実験用のリポジトリを用意する

このページの実験は、壊しても困らない専用のリポジトリで行います。`my-profile` は使わないでください。

1. Git Bash で次のコマンドを1行ずつ実行します（まとめて貼り付けても動きます）。

```bash
mkdir -p ~/git-practice/appendix-lab/undo
cd ~/git-practice/appendix-lab/undo
git init
echo "1行目" > memo.md
git add memo.md
git commit -m "メモ1"
echo "2行目" >> memo.md
git commit -am "メモ2"
echo "3行目" >> memo.md
git commit -am "メモ3"
git log --oneline
```

2. 最後の `git log --oneline` で、3つのコミットが表示されれば準備完了です（ハッシュ値は人によって違います）。

```text
9c1e2f4 (HEAD -> main) メモ3
5b7a0d1 メモ2
2f4e8a3 メモ1
```

- `git commit -am "..."` は「すでに Git が管理しているファイルの変更をすべてステージしてからコミットする」省略形です。新しく作ったファイルには効かないので、最初の1回だけ `git add` しています。
- 作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\undo` フォルダを削除してから、もう一度上のコマンドを実行してください。

> [!TIP]
> `git add` などで `LF will be replaced by CRLF` という警告が出ることがありますが、無視してかまいません（`printf` や `echo` で作ったファイルは改行コードが LF になるため。[改行コードと文字コード](line-endings-and-encoding.md#lf-will-be-replaced)、[レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)）。

---

<a id="reset-modes"></a>

## 4. `git reset` の3つのモード

### reset は「ブランチの名札を動かす」コマンド

`git reset` の本質は、**今いるブランチの名札を、指定したコミットへ付け替える** ことです。そのうえで、ステージとワーキングツリーを「どこまで名札に合わせるか」をモードで選びます。

```text
reset 前：   A ── B ── C   ← main ← HEAD

git reset HEAD~1 の後：

             A ── B   ← main ← HEAD
                   \
                    C   （どのブランチからもたどれなくなった。消えたわけではない）
```

`HEAD~1` は「HEAD の1つ前のコミット」という意味です。`HEAD~2` なら2つ前です（`HEAD^` と書く人もいますが、意味は `HEAD~1` と同じです）。

| モード | ブランチの名札 | ステージ | ワーキングツリー | C の変更はどこに残るか |
|---|---|---|---|---|
| `--soft` | B へ動かす | そのまま | そのまま | ステージに残る（すぐコミットし直せる） |
| `--mixed`（既定） | B へ動かす | B の状態に戻す | そのまま | ワーキングツリーに残る（未ステージ） |
| `--hard` | B へ動かす | B の状態に戻す | B の状態に戻す | どこにも残らない（reflog からは戻せる） |

`--soft` → `--mixed` → `--hard` の順に、「名札に合わせて巻き戻す範囲」が広がっていく、と覚えると整理しやすくなります。

### 実験1：`--soft`

1. 直前のコミットを `--soft` で取り消します。

```bash
git reset --soft HEAD~1
```

2. 状態を短い形式で確かめます。

```bash
git status --short
git log --oneline
```

```text
M  memo.md
5b7a0d1 (HEAD -> main) メモ2
2f4e8a3 メモ1
```

`git status --short` の表示は2列で、**左の列がステージ、右の列がワーキングツリー** の状態です。`M ` のように左に `M` があるので、「3行目」の追加はステージに残っています。

3. そのままコミットし直せます（`--amend` と似た使い方ができます）。

```bash
git commit -m "メモ3"
```

（コミットし直したので、メモ3 のハッシュ値は最初と変わります。以降の例の `9c1e2f4` は、自分の画面の最新のメモ3 の値に読み替えてください）

### 実験2：`--mixed`（モードを書かないときの既定）

1. 今度はモードを付けずに実行します。

```bash
git reset HEAD~1
```

```text
Unstaged changes after reset:
M	memo.md
```

2. 状態を確かめます。

```bash
git status --short
```

```text
 M memo.md
```

今度は右の列に `M` があります。変更はワーキングツリーに残り、ステージからは外れました。「コミットの単位を分け直したい」ときに便利です。

3. 元に戻しておきます。

```bash
git commit -am "メモ3"
```

（コミットし直したので、メモ3 のハッシュ値は最初と変わります。以降の例の `9c1e2f4` は、自分の画面の最新のメモ3 の値に読み替えてください）

### 実験3：`--hard`

1. `--hard` で取り消します。

```bash
git reset --hard HEAD~1
```

```text
HEAD is now at 5b7a0d1 メモ2
```

2. ファイルの中身を確かめます。

```bash
cat memo.md
```

```text
1行目
2行目
```

「3行目」がファイルからも消えました。この時点で「3行目」はどの場所にも残っていませんが、**コミットとしては Git の中にまだ残っています**。取り戻し方は [7. reflog](#reflog) で試します。

> [!WARNING]
> `git reset --hard` は、**まだコミットしていない編集も一緒に消します**。こちらは reflog でも戻せません。実行前に `git status` で「消えて困る変更がないか」を必ず確かめてください。

### ORIG_HEAD：直前の reset を戻す

`git reset` を実行すると、Git は動かす前の位置を `ORIG_HEAD` という名前で覚えています。直後であれば次のコマンドで reset 前に戻れます。

```bash
git reset --hard ORIG_HEAD
git log --oneline
```

```text
9c1e2f4 (HEAD -> main) メモ3
5b7a0d1 メモ2
2f4e8a3 メモ1
```

`ORIG_HEAD` は `git merge` や `git rebase` でも上書きされるので、「直前の1回分だけ」の命綱だと考えてください。もっと前の状態に戻りたいときは reflog を使います。

### ファイルを指定した reset

`git reset memo.md` のようにファイルを指定すると、名札は動かさず「そのファイルのステージだけを HEAD の状態に戻す」動きになります。これは `git restore --staged memo.md` と同じ結果です。この教材では意味がわかりやすい `git restore --staged` を使います。

### VS Code の「前回のコミットを元に戻す（Undo Last Commit）」

VS Code のソース管理ビューの **…（その他の操作）** → **コミット（Commit）** → **前回のコミットを元に戻す（Undo Last Commit）** は、`git reset --soft HEAD~1` に相当します。直前のコミットが取り消され、変更はステージされた状態で残ります（出典：[VS Code Docs: Staging, Commits & Undo](https://code.visualstudio.com/docs/sourcecontrol/staging-commits)）。push 前のコミットにだけ使ってください。

---

<a id="revert-vs-reset"></a>

## 5. `git revert` と `git reset` の違い

### 「なかったことにする」か「打ち消しを記録する」か

```text
reset：履歴から消す（名札を戻す）

  A ── B ── C   ← main          →     A ── B   ← main

revert：C を打ち消すコミット C' を新しく足す

  A ── B ── C   ← main          →     A ── B ── C ── C'   ← main
                                               （C' は C の変更を逆向きにしたもの）
```

| | `git reset` | `git revert` |
|---|---|---|
| 履歴 | 書き換える（コミットが消えたように見える） | 書き換えない（打ち消しコミットが増える） |
| 何をした記録が残るか | 残らない | 「C を取り消した」ことが残る |
| push 後に使えるか | 使ってはいけない（[理由](#rewrite-after-push)） | 使える |
| 取り消せる範囲 | 指定したコミットより後ろ全部 | 指定したコミットだけ（途中のコミットも選べる） |

### 実験：真ん中のコミットだけを打ち消す

revert は「最新のコミット」でなくても、途中のコミットだけを打ち消せます。

1. 2つ前のコミット（メモ2）を打ち消します。`--no-edit` を付けると、メッセージ入力のエディタを開かずに既定のメッセージ（`Revert "メモ2"`）でコミットします。

```bash
git revert --no-edit HEAD~1
```

2. このリポジトリでは「2行目」を消すと「3行目」の位置とぶつかるため、コンフリクト（conflict、競合）になります。

```text
Auto-merging memo.md
CONFLICT (content): Merge conflict in memo.md
error: could not revert 5b7a0d1... メモ2
```

revert も「変更を逆向きにして取り込む」という意味ではマージの一種なので、近くの行が変わっているとコンフリクトします。ここでは練習なので、やめておきます。

3. revert を中止します。

```bash
git revert --abort
```

コンフリクトを解決して続けたい場合は、[7日目](../docs/day07-merge-conflict.md) と同じ要領で解決して `git add memo.md` したあと、`git revert --continue` を実行します。

> [!NOTE]
> マージコミットを revert するときは、どちらの親を基準にするかを `-m 1` のように指定する必要があります（例：`git revert -m 1 HEAD`）。`1` は「マージしたときにいたブランチ側」を意味します。詳しくは [git-revert のドキュメント](https://git-scm.com/docs/git-revert) を見てください。

---

<a id="restore-and-switch"></a>

## 6. `restore` と `switch`：`checkout` が分割された経緯

### checkout は「やることが多すぎた」

昔の Git では、`git checkout` 1つで次のようなまったく違う操作をしていました。

| やりたいこと | 昔の書き方 | 今の書き方（この教材） |
|---|---|---|
| ブランチを切り替える | `git checkout main` | `git switch main` |
| ブランチを作って切り替える | `git checkout -b add-favorites` | `git switch -c add-favorites` |
| ファイルの編集を取り消す | `git checkout -- memo.md` | `git restore memo.md` |
| ステージを取り消す | `git reset HEAD memo.md` | `git restore --staged memo.md` |
| ファイルを過去のコミットの状態にする | `git checkout HEAD~2 -- memo.md` | `git restore --source=HEAD~2 memo.md` |
| 過去のコミットを見に行く | `git checkout 2f4e8a3` | `git switch --detach 2f4e8a3` |

（表の「ファイルを過去のコミットの状態にする」の行は、まったく同じ動きではありません。`git checkout HEAD~2 -- memo.md` はステージとワーキングツリーの両方を書き換えますが、`git restore --source=HEAD~2 memo.md` はワーキングツリーだけを戻します。checkout と同じにしたいときは `git restore --source=HEAD~2 --staged --worktree memo.md` と書きます）

「ブランチを切り替える」（安全）と「ファイルの編集を捨てる」（危険）が同じコマンドだったため、たとえばブランチに切り替えるつもりで `git checkout <名前>` と打ったとき、その名前のブランチがなく、同じ名前のファイルがあると、ファイルの編集が捨てられてしまう、といった事故が起きえました。昔の書き方で `--` を付けるのは「ここから後ろはファイル名です」と区別するためです。

そこで **Git 2.23（2019年）** で、ブランチ操作の `git switch` と、ファイルを戻す `git restore` が追加されました（出典：[Highlights from Git 2.23 - GitHub Blog](https://github.blog/open-source/git/highlights-from-git-2-23/)）。`git checkout` は今も使えるので、ネット上の記事で見かけたら上の表で読み替えてください。

### restore の「どこから」「どこへ」

`git restore` は「どこから（source）」「どこへ（ステージ／ワーキングツリー）」を指定するコマンドです（出典：[git-restore](https://git-scm.com/docs/git-restore)）。

| コマンド | どこから | どこへ |
|---|---|---|
| `git restore memo.md` | ステージ | ワーキングツリー |
| `git restore --staged memo.md` | HEAD | ステージ |
| `git restore --source=HEAD~2 memo.md` | 2つ前のコミット | ワーキングツリー |
| `git restore --source=HEAD --staged --worktree memo.md` | HEAD | ステージとワーキングツリーの両方 |

`git restore memo.md` が「最後のコミット」ではなく「ステージ」から戻す点に注意してください。ステージしてから編集を続けた場合、ステージした時点の内容に戻ります。

### 実験：ファイルを2つ前のコミットの状態にする

1. `memo.md` を「メモ1」の時点の内容にします（今のブランチの位置は動きません）。

```bash
git restore --source=HEAD~2 memo.md
cat memo.md
```

```text
1行目
```

2. ワーキングツリーだけが変わったので、`git status --short` では ` M memo.md` と表示されます。この状態でコミットすれば、「ファイルを過去の状態に戻した」という新しいコミットになります（[レシピ undo-06](../recipes/undo.md#undo-06)）。今回は元に戻しておきます。

```bash
git restore memo.md
```

---

<a id="reflog"></a>

## 7. `git reflog`：消えたコミットやブランチを取り戻す

### reflog とは

reflog（リファレンスログ）は、**HEAD やブランチの名札が「いつ」「どこからどこへ」動いたかを記録した、手元だけの日誌** です。コミット、切り替え、reset、merge、rebase などで名札が動くたびに1行ずつ記録されます。

1. 実験用リポジトリで reflog を表示します。

```bash
git reflog
```

```text
9c1e2f4 (HEAD -> main) HEAD@{0}: reset: moving to 9c1e2f4a8d...
9c1e2f4 (HEAD -> main) HEAD@{1}: reset: moving to ORIG_HEAD
5b7a0d1 HEAD@{2}: reset: moving to HEAD~1
9c1e2f4 (HEAD -> main) HEAD@{3}: commit: メモ3
...
```

（表示される行は、ここまでに試した操作によって違います。いちばん上の行は、5. で `git revert --abort` したときの記録です。ハッシュ値は人によって違います）

- `HEAD@{0}` は「今」、`HEAD@{1}` は「1回前に HEAD がいた場所」、`HEAD@{2}` は「2回前」です。
- `git reflog show main` とすると、`main` の名札の動きだけを見られます（`main@{1}` のように使えます）。
- 書式の詳細は [gitrevisions](https://git-scm.com/docs/gitrevisions) にあります。

### 実験：`reset --hard` で消したコミットを取り戻す

1. わざと直前のコミットを消します。

```bash
git reset --hard HEAD~1
git log --oneline
```

```text
5b7a0d1 (HEAD -> main) メモ2
2f4e8a3 メモ1
```

2. reflog を見ると、消したはずのコミットが残っています。

```bash
git reflog -3
```

```text
5b7a0d1 (HEAD -> main) HEAD@{0}: reset: moving to HEAD~1
9c1e2f4 HEAD@{1}: reset: moving to 9c1e2f4a8d...
9c1e2f4 HEAD@{2}: reset: moving to ORIG_HEAD
```

`HEAD@{1}`（1回前の位置）に、消したはずの「メモ3」のコミット（`9c1e2f4`）がいます。

3. 1回前の位置（`HEAD@{1}`）に戻します。

```bash
git reset --hard HEAD@{1}
git log --oneline
```

```text
9c1e2f4 (HEAD -> main) メモ3
5b7a0d1 メモ2
2f4e8a3 メモ1
```

> [!TIP]
> いきなり `reset --hard` で戻るのが不安なときは、まず **名札だけ付けて保護** するのがおすすめです。`git branch rescue HEAD@{1}` とすると、そのコミットを指す `rescue` ブランチができ、`git log --oneline --graph --all` で中身を確かめてから落ち着いて判断できます。

### 実験：削除したブランチを取り戻す

1. ブランチを作ってコミットし、マージせずに強制削除します（`-D` は「マージされていなくても消す」）。

```bash
git switch -c experiment
echo "実験の行" >> memo.md
git commit -am "実験のコミット"
git switch main
git branch -D experiment
```

```text
Deleted branch experiment (was 7d3a9b2).
```

2. 削除時のメッセージに表示されたハッシュ値（例では `7d3a9b2`）で、ブランチを作り直します。次のコマンドの `7d3a9b2` は、**自分の画面に表示された値に置き換えて** 実行してください。

```bash
git branch experiment 7d3a9b2
```

3. メッセージを見逃した場合は、reflog の中から「実験のコミット」の行を探します。

```bash
git reflog
```

```text
9c1e2f4 (HEAD -> main) HEAD@{0}: checkout: moving from experiment to main
7d3a9b2 HEAD@{1}: commit: 実験のコミット
...
```

`HEAD@{1}` の位置にあるので、`git branch experiment HEAD@{1}` でも作り直せます。

### reflog の限界

| 限界 | 説明 |
|---|---|
| **手元だけ** | reflog は自分のパソコンの `.git` の中にだけあり、push されません。GitHub 上の操作や、他の人のパソコンでの操作は記録されません。クローンし直すと空から始まります。 |
| **期限がある** | 古い記録は自動で掃除されます。既定では、今のブランチからたどれる記録は90日、たどれなくなった記録は30日で消える対象になります（出典：[git-reflog](https://git-scm.com/docs/git-reflog) の `--expire` の説明）。 |
| **コミットしていない変更は記録されない** | `git restore` や `reset --hard` で捨てた「未コミットの編集」は、reflog には出てきません。 |

「迷ったらとりあえずコミットしておく」と、reflog という命綱が効く範囲が広がります。コミットはあとから `reset --soft` でまとめ直せます。

---

<a id="stash"></a>

## 8. `git stash`：作業途中の変更を一時退避する

### どんなときに使うか

- 作業途中だが、急いで別のブランチに切り替えたい（`Your local changes ... would be overwritten` と出て切り替えられない。[レシピ branch-03](../recipes/branch.md#branch-03)、[trouble-05](../recipes/troubleshooting.md#trouble-05)）
- `git pull` したいが、手元の編集とぶつかって止まった
- 今の編集をいったん脇に置いて、きれいな状態で何かを確かめたい

stash（スタッシュ）は、ステージとワーキングツリーの変更を「棚」にしまい、両方を HEAD の状態に戻すコマンドです。棚は積み重ねられ、`stash@{0}` が一番新しいものです。

### 実験：退避して戻す

1. 実験用リポジトリで、編集を1つと、新しいファイルを1つ作ります。

```bash
echo "編集中の行" >> memo.md
echo "下書き" > draft.md
git status --short
```

```text
 M memo.md
?? draft.md
```

2. 退避します。`-u` を付けると、追跡されていないファイル（`??` のもの）も一緒にしまいます。`-m` で棚に名前を付けられます。

```bash
git stash push -u -m "メモの編集途中"
git status --short
git stash list
```

```text
stash@{0}: On main: メモの編集途中
```

`git status --short` は何も表示されず、ワーキングツリーがきれいになりました。

3. 戻します。`pop` は「取り出して棚から消す」、`apply` は「取り出すが棚にも残す」です。

```bash
git stash pop
git status --short
```

```text
 M memo.md
?? draft.md
```

4. 実験が終わったら、編集を捨てて元に戻しておきます（次の節で `draft.md` を使うので、ここでは `memo.md` だけ戻します）。

```bash
git restore memo.md
```

### stash の注意点

| 注意 | 説明 |
|---|---|
| 忘れやすい | 棚にしまったことを忘れがちです。ときどき `git stash list` を見る習慣をつけましょう。長く置くなら、ブランチを作ってコミットするほうが安全です。 |
| `-u` を付けないと新しいファイルは残る | 既定では、追跡されていないファイルはしまわれません。 |
| pop でコンフリクトすることがある | 戻す先の内容が変わっていると、マージと同じようにコンフリクトします。この場合、棚の中身は消えずに残るので、解決後に `git stash drop` で消します。 |
| drop したものは見えなくなる | `git stash drop` すると `Dropped refs/stash@{0} (ハッシュ)` と表示されます。このハッシュを控えていれば、しばらくは `git stash apply` にそのハッシュを渡して取り戻せますが、あてにしないでください。 |

### VS Code での stash

ソース管理ビューの「…」（その他の操作）メニューに「スタッシュ（Stash）」があり、退避・適用・ポップ・削除ができます（執筆時点の表示です）。どの棚に何が入っているかは名前（メッセージ）でしか区別できないので、退避するときに名前を付けておくと後で困りません。

詳しい使い方は [git-stash](https://git-scm.com/docs/git-stash) と [レシピ undo-07](../recipes/undo.md#undo-07) を見てください。

---

<a id="clean"></a>

## 9. `git clean`：追跡されていないファイルを削除する

`git restore` や `git reset --hard` は、**Git が管理しているファイル** だけを戻します。まだ一度も `git add` していないファイル（`git status` で Untracked files と表示されるもの）は対象外です。これを消すのが `git clean` です。

### 必ず「予行演習」から

1. `-n`（dry run：実際には消さず、消える予定のものを表示する）で確かめます。

```bash
git clean -n
```

```text
Would remove draft.md
```

2. 消えてよいことを確かめてから、`-f`（force）で実行します。

```bash
git clean -f
```

```text
Removing draft.md
```

| オプション | 意味 |
|---|---|
| `-n` | 消える予定のものを表示するだけ（必ず最初に使う） |
| `-f` | 実際に削除する（Git の設定により、これがないと実行できません） |
| `-d` | 追跡されていないフォルダも削除する |
| `-x` | `.gitignore` で無視しているファイルも削除する |
| `-i` | 1つずつ確認しながら削除する |

> [!CAUTION]
> `git clean` で消したファイルは **ごみ箱にも入らず、Git の記録にもない** ので取り戻せません。特に `-x` は、4日目に `.gitignore` で無視した `private-memo.txt` のような「Git には入れていないが大事なファイル」まで消します。この教材の範囲で `-x` を使う必要はありません。

詳細は [git-clean](https://git-scm.com/docs/git-clean) を見てください。

---

<a id="rewrite-after-push"></a>

## 10. push した後に履歴を書き換えてはいけない理由

5日目で「`--amend` や `reset` は push 前だけ」と学びました。その理由を図で確かめます。

### 何が起きるか

1. あなたが `A ── B ── C` を push し、チームメイトがそれを pull して、C の上に自分のコミット D を作りました。

```text
GitHub：           A ── B ── C   ← main
チームメイトの手元：A ── B ── C ── D   ← main
```

2. その後あなたが C を `--amend` で直して C' にしました。C' は C と **別のコミット（ハッシュ値が違う）** です。

```text
あなたの手元：     A ── B ── C'  ← main
```

3. ここで push しようとすると、GitHub の `main`（C）はあなたの `main`（C'）の祖先ではないので、push は拒否されます（non-fast-forward。[Appendix：リモート追跡ブランチ](remote-tracking.md#non-fast-forward)）。

4. 拒否を無理やり通すために `git push --force` すると、GitHub の `main` が C' に置き換わります。すると、

   - チームメイトが pull すると、手元には C と C' の **両方** が残り、同じ内容の変更が二重になったり、コンフリクトしたりします。
   - チームメイトがすでに D を push していた場合は、あなたの強制 push で **D が GitHub から消えます**。

```text
強制 push 後の GitHub：   A ── B ── C'          （D はどこにもつながっていない）
チームメイトの手元：      A ── B ── C ── D
```

つまり、履歴の書き換えは「自分の手元だけ」なら自由ですが、一度共有したコミットを書き換えると、**それを持っている全員の手元とずれる** のです。

### 安全に取り消すには

| 状況 | 使う方法 |
|---|---|
| まだ push していない | `--amend`、`reset`、[rebase -i](rebase.md#interactive) などで自由に整えてよい |
| push した（共有ブランチ、`main` など） | `git revert` で「打ち消しコミット」を足す |
| push したが、自分しか使っていないブランチ | 書き換えて `git push --force-with-lease` することもできる（[注意点](remote-tracking.md#force-push)）。この教材のチーム開発編では、混乱を避けるため使いません |

チームリポジトリでは、`main` への強制 push をルールセットで禁止しておくと事故を防げます（[Appendix：GitHub でのチーム開発](github-collaboration.md#rulesets)）。

---

## 11. どれを使う？早見フローチャート

```text
戻したいのはどれ？
│
├─ まだコミットしていない編集
│    ├─ ステージしていない ………… git restore <ファイル>         （編集は消える）
│    ├─ ステージした ………………… git restore --staged <ファイル>  （編集は残る）
│    └─ 一時的にどけたいだけ ……… git stash push -u
│
├─ 新しく作った、管理していないファイル ………… git clean -n → git clean -f
│
└─ コミット済み
     ├─ push 前
     │    ├─ 直前のコミットを直す ………… git commit --amend
     │    ├─ コミットを取り消し、変更は残す … git reset --soft HEAD~1（または --mixed）
     │    └─ コミットも変更も捨てる ……… git reset --hard HEAD~1（未コミットの編集に注意）
     └─ push 後 ……………………………………… git revert <コミット>
```

どれを実行した後でも、「しまった」と思ったら **まず手を止めて `git reflog`** を見てください。コミットしたことのある内容なら、たいてい取り戻せます。

---

## まとめ

- `reset` は「ブランチの名札を動かす」コマンドで、モードによってステージとワーキングツリーをどこまで合わせるかが変わる。
- `revert` は履歴を書き換えず、打ち消しを記録する。push 後に使えるのはこちら。
- `restore`（ファイルを戻す）と `switch`（ブランチを切り替える）は、何でも屋だった `checkout` から分かれたコマンド。
- `reflog` は手元の名札の移動記録で、消したコミットやブランチを取り戻せる。ただしコミットしていない変更は記録されない。
- `stash` は一時退避、`clean` は追跡されていないファイルの削除（取り戻せないので `-n` から）。
- 共有した履歴を書き換えると、全員の手元とずれる。共有後は `revert`。

## 関連ページ

- 本編：[5日目 取り消しとやり直し](../docs/day05-undo.md)、[6日目 ブランチ](../docs/day06-branch.md)
- レシピ：[undo-01](../recipes/undo.md#undo-01)〜[undo-08](../recipes/undo.md#undo-08)、[branch-03](../recipes/branch.md#branch-03)、[branch-07](../recipes/branch.md#branch-07)
- Appendix：[3つの場所](three-areas.md)、[Git の内部のしくみ](git-internals.md)、[ブランチとマージ](branches-and-merge.md)、[リモート追跡ブランチ](remote-tracking.md)、[rebase](rebase.md)

## 参考資料（公式ドキュメント）

- [git-reset](https://git-scm.com/docs/git-reset)
- [git-revert](https://git-scm.com/docs/git-revert)
- [git-restore](https://git-scm.com/docs/git-restore)、[git-switch](https://git-scm.com/docs/git-switch)
- [git-reflog](https://git-scm.com/docs/git-reflog)、[gitrevisions](https://git-scm.com/docs/gitrevisions)
- [git-stash](https://git-scm.com/docs/git-stash)、[git-clean](https://git-scm.com/docs/git-clean)
- [Pro Git（日本語版）7.7 Git のさまざまなツール - リセットコマンド詳説](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E3%83%AA%E3%82%BB%E3%83%83%E3%83%88%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E8%A9%B3%E8%AA%AC)
- [VS Code Docs: Staging, Commits & Undo](https://code.visualstudio.com/docs/sourcecontrol/staging-commits)

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
