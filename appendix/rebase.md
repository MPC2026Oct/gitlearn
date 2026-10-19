# rebase：コミットを付け替えるしくみ

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[13日目「最終課題に取り組む」](../docs/day13-final-project.md) の「発展：rebase 入門」を読んだ人（[12日目](../docs/day12-team-conflict.md) で「merge の代わりに rebase で取り込む方法もある」と聞いて気になった人も）
>
> **読む時間の目安**：約30分（手を動かして試す場合は +25分）

13日目では、rebase（リベース）が「自分のブランチのコミットを `main` の最新の先に付け直す」操作だと学びました。このページでは、付け直すときに Git が何をしているのか、merge とどう違うのか、そして **なぜ「共有したブランチは rebase しない」が鉄則なのか** を説明します。後半では、コミットを整理する「対話的 rebase」と、`git pull --rebase` も紹介します。

> [!IMPORTANT]
> この教材のチーム開発編では、`main` の取り込みに **merge** を使います（9日目のチームのルール）。rebase は、自分だけのリポジトリで試してください。

## このページでわかること

- rebase がコミットを「付け替える」しくみ（新しいコミットが作られる）
- merge と rebase の履歴の違いと、それぞれの長所・短所
- 「共有したブランチは rebase しない」原則の理由
- 作業ブランチに `main` の最新を rebase で取り込む手順
- rebase 中のコンフリクトの解決（`--continue` / `--abort` / `--skip`）と、Current / Incoming が逆に見える理由
- 対話的 rebase（`git rebase -i`）でコミットをまとめる方法
- `git pull --rebase` と `pull.rebase` の設定

---

<a id="how-it-works"></a>

## 1. rebase は「コミットの付け替え」

### 何が起きているか

`topic` ブランチで `git rebase main` を実行すると、Git は次の手順を自動で行います。

1. `topic` と `main` のマージベース（分かれ目。[Appendix：ブランチとマージ](branches-and-merge.md#merge-base)）を探す
2. マージベースより後の `topic` のコミット（C1、C2）を、「変更の差分」として一時的に取り出す
3. HEAD を `main` の先端に移す
4. 取り出した差分を、古い順に1つずつ適用して、**新しいコミット**（C1'、C2'）を作る
5. `topic` の名札を、最後に作った C2' に付け替える

```text
rebase 前：

        C1 ── C2   ← topic
       /
  A ── B ── M      ← main

git rebase main の後：

                  C1' ── C2'   ← topic       （中身は同じだが新しいコミット）
                 /
  A ── B ── M          ← main

        C1 ── C2   （古いコミット。どのブランチからもたどれないが、reflog には残る）
```

C1' は C1 と同じ変更を持っていますが、**親のコミットが違う**（B ではなく M）ので、ハッシュ値も違う「別のコミット」になります。コミットのハッシュ値は、内容だけでなく親や日時も含めて計算されるからです（[Appendix：Git の内部のしくみ](git-internals.md)）。この「新しいコミットに作り直される」ことが、後で説明する危険性の原因になります。

---

<a id="lab-setup"></a>

## 2. 実験：rebase の前後で履歴を比べる

1. 実験用リポジトリを作ります。`topic` ブランチで2回、`main` で1回コミットして、線を2本に分けます。

```bash
mkdir -p ~/git-practice/appendix-lab/rebase
cd ~/git-practice/appendix-lab/rebase
git init
echo "# 買い物メモ" > memo.md
git add memo.md
git commit -m "買い物メモを作成"
git switch -c topic
echo "- 牛乳" >> memo.md
git commit -am "牛乳を追加"
echo "- パン" >> memo.md
git commit -am "パンを追加"
git switch main
echo "# 予定" > plan.md
git add plan.md
git commit -m "予定ページを追加"
git log --oneline --graph --all
```

```text
* d5eb76b (HEAD -> main) 予定ページを追加
| * 0c140b4 (topic) パンを追加
| * 4c37c93 牛乳を追加
|/
* 586b30d 買い物メモを作成
```

（ハッシュ値は人によって違います。以下も同じです）

> [!TIP]
> `git add` などで `LF will be replaced by CRLF` という警告が出ることがありますが、無視してかまいません（`printf` や `echo` で作ったファイルは改行コードが LF になるため。[改行コードと文字コード](line-endings-and-encoding.md#lf-will-be-replaced)、[レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)）。

2. `topic` に切り替えて、`main` の上に付け替えます。

```bash
git switch topic
git rebase main
```

```text
Successfully rebased and updated refs/heads/topic.
```

3. 履歴を比べます。

```bash
git log --oneline --graph --all
```

```text
* d119aa1 (HEAD -> topic) パンを追加
* 0c085cd 牛乳を追加
* d5eb76b (main) 予定ページを追加
* 586b30d 買い物メモを作成
```

一直線になり、「牛乳を追加」のハッシュ値が `4c37c93` から `0c085cd` に、「パンを追加」が `0c140b4` から `d119aa1` に **変わりました**。

4. reflog を見ると、rebase の中で何が起きたかがわかります（下から順に読みます）。

```bash
git reflog -4
```

```text
d119aa1 (HEAD -> topic) HEAD@{0}: rebase (finish): returning to refs/heads/topic
d119aa1 (HEAD -> topic) HEAD@{1}: rebase (pick): パンを追加
0c085cd HEAD@{2}: rebase (pick): 牛乳を追加
d5eb76b (main) HEAD@{3}: rebase (start): checkout main
```

`main` に移動して（start）、コミットを1つずつ適用し直し（pick）、最後に `topic` の名札を付け替えた（finish）ことが読み取れます。途中で HEAD がブランチではなくコミットを直接指している（detached HEAD）のも、このためです。

### rebase をなかったことにする

5. rebase の直後なら、`ORIG_HEAD`（rebase 前の位置）に戻せます。

```bash
git reset --hard ORIG_HEAD
git log --oneline --graph --all
```

```text
* d5eb76b (main) 予定ページを追加
| * 0c140b4 (HEAD -> topic) パンを追加
| * 4c37c93 牛乳を追加
|/
* 586b30d 買い物メモを作成
```

元のハッシュ値（`0c140b4`）のコミットに戻りました。古いコミットは消えずに残っていたことがわかります。時間がたって `ORIG_HEAD` が別の操作で上書きされた場合は、`git reflog` で rebase 前の位置を探します（`topic@{1}` のようにブランチの reflog を使うこともできます。[Appendix：取り消しの詳細](undo-in-depth.md#reflog)）。

作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\rebase` フォルダを削除してから、手順1からやり直してください。

---

<a id="merge-vs-rebase"></a>

## 3. merge と rebase の比較

同じ状況（`topic` に `main` の最新を取り込みたい）で、2つの方法を比べます。

```text
merge（git switch topic → git merge main）：

        C1 ── C2 ──── X   ← topic        （X はマージコミット）
       /             /
  A ── B ── M ───────     ← main

rebase（git switch topic → git rebase main）：

                  C1' ── C2'   ← topic
                 /
  A ── B ── M                  ← main
```

| 観点                             | merge                                                              | rebase                                            |
| -------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------- |
| 履歴の形                         | 枝分かれと合流がそのまま残る                                       | 一直線になる                                      |
| 既存のコミット                   | 変わらない（新しいマージコミットが増える）                         | **作り直される（ハッシュ値が変わる）**            |
| コンフリクトの解決               | 1回（マージコミットで1度に）                                       | コミットごとに起きうる（C1 で1回、C2 でもう1回…） |
| 共有済みのブランチで使えるか     | 使える                                                             | **使ってはいけない**（次の節）                    |
| 「いつ、何を取り込んだか」の記録 | マージコミットとして残る                                           | 残らない（最初からそこで作業したように見える）    |
| 履歴の読みやすさ                 | 取り込みが多いと「Merge branch 'main' into ...」が並んで読みにくい | 読みやすい                                        |

どちらが正しいということはなく、チームのルールとして選ぶものです。この教材では、仕組みが単純で、共有ブランチでも安全な merge を使っています。

---

<a id="golden-rule"></a>

## 4. 「共有したブランチは rebase しない」原則

Pro Git では、これを「**公開リポジトリにプッシュしたコミットをリベースしてはいけない**」と太字で書いています（出典：[Pro Git（日本語版）3.6 Git のブランチ機能 - リベース](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E6%A9%9F%E8%83%BD-%E3%83%AA%E3%83%99%E3%83%BC%E3%82%B9) の「ほんとうは怖いリベース」）。

### 何が起きるか

1. あなたが `topic` を push し、チームメイトがそれを手元に持ってきて、C2 の上に D を作った。

```text
GitHub：             … ── C1 ── C2   ← topic
チームメイトの手元： … ── C1 ── C2 ── D   ← topic
```

2. あなたが `topic` を rebase すると、C1・C2 は C1'・C2' に作り直される。push は fast-forward でないので拒否され、force push が必要になる（[Appendix：リモート追跡ブランチ](remote-tracking.md#force-push)）。

3. force push すると、GitHub の `topic` は C1'・C2' になる。チームメイトが pull すると、手元で **C1・C2（古い版）と C1'・C2'（新しい版）が両方** 存在する状態になり、

   - 同じ変更が2回ずつ履歴に並ぶ
   - 同じ内容どうしでコンフリクトする
   - チームメイトがうっかり古い C1・C2 を含めて push すると、消したはずのコミットが復活する

といった混乱が起きます。チームメイトが D をすでに push していたなら、あなたの force push で D が消えます。

### 使ってよいのはどんなときか

| 状況                                                                                                            | rebase してよいか                                                                                   |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| まだ push していない、自分の手元だけのコミット                                                                  | よい                                                                                                |
| push したが、**自分しか使っていない** ブランチ（自分のプルリクエスト（Pull Request、略して PR）のブランチなど） | 技術的には可能。force push が必要。レビュー中だとコメントの位置が古くなるので、チームで合意してから |
| `main` など、複数人が使うブランチ                                                                               | **だめ**                                                                                            |
| 他の人が手元に持ってきている可能性があるブランチ                                                                | **だめ**                                                                                            |

---

<a id="update-branch"></a>

## 5. 作業ブランチに `main` の最新を rebase で取り込む手順

チームが rebase を使うと決めている場合の、典型的な手順です（[レシピ branch-08](../recipes/branch.md#branch-08) の rebase 版）。ここでは、ブランチ名を `hydr4/add-faq` として説明します。

1. 作業中の変更をすべてコミットしておきます（`git status` で `nothing to commit` を確認）。
2. GitHub の最新を取得します。

```bash
git fetch origin
```

3. 作業ブランチにいることを確かめて、`origin/main` の上に付け替えます。

```bash
git switch hydr4/add-faq
git rebase origin/main
```

4. コンフリクトしたら、[次の節](#rebase-conflict) の手順で解決します。
5. まだ一度も push していないブランチなら、ふつうに push します。すでに push していたブランチなら、コミットが作り直されているので、条件付きの force push が必要です。

```bash
git push --force-with-lease --force-if-includes
```

`git rebase main` ではなく `git rebase origin/main` としているのは、手元の `main` を最新にする手間を省くためです（fetch で `origin/main` は最新になっています）。

---

<a id="rebase-conflict"></a>

## 6. rebase 中のコンフリクト

### 実験：コンフリクトを起こして解決する

1. `main` で、`memo.md` の末尾（`topic` が「牛乳」を足したのと同じ位置）に「卵」を足します。

```bash
git switch main
echo "- 卵" >> memo.md
git commit -am "卵を追加"
```

2. `topic` を `main` の上に付け替えます。

```bash
git switch topic
git rebase main
```

```text
Auto-merging memo.md
CONFLICT (content): Merge conflict in memo.md
error: could not apply 4c37c93... 牛乳を追加
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
```

2つのコミットのうち、1つ目（牛乳を追加）を適用するところで止まりました。

3. 状態を見ます。

```bash
git status
```

```text
interactive rebase in progress; onto 682bb25
Last command done (1 command done):
   pick 4c37c93 牛乳を追加
Next command to do (1 remaining command):
   pick 0c140b4 パンを追加
  (use "git rebase --edit-todo" to view and edit)
You are currently rebasing branch 'topic' on '682bb25'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
	both modified:   memo.md
```

「1つ目のコミットで止まっていて、あと1つ残っている」ことがわかります。rebase 中は HEAD がブランチではなくコミットを直接指している（detached HEAD）ため、`git branch` を実行すると `* (no branch, rebasing topic)` のように表示されます。

4. `memo.md` を見ます。

```bash
cat memo.md
```

```text
# 買い物メモ
<<<<<<< HEAD
- 卵
=======
- 牛乳
>>>>>>> 4c37c93 (牛乳を追加)
```

### Current と Incoming が「逆」に見える理由

merge のときは `HEAD` 側が自分の変更でした。ところが rebase では、

- **HEAD 側（VS Code の「現在の変更（Current Change）」）** ＝ 付け替え先の `main` と、すでに付け替え終わったコミット
- **もう一方（VS Code の「入力側の変更（Incoming Change）」）** ＝ これから適用しようとしている **自分のコミット**

になります。rebase は「`main` に移動して（HEAD が `main` 側になる）、自分のコミットを1つずつ持ち込む」操作だからです。「自分の変更を残したいから Current を選ぶ」と考えると逆になるので注意してください。迷ったら、マーカーの `>>>>>>>` の後ろに書かれたコミットのメッセージ（ここでは「牛乳を追加」）を見れば、どちらが自分のコミットか判断できます。

5. VS Code で `memo.md` を開き、「両方の変更を取り込む（Accept Both Changes）」を選んで保存します。Git Bash だけで進めたい場合は、次のコマンドでファイルを解決後の内容に書き換えても同じです。

```bash
printf '# 買い物メモ\n- 卵\n- 牛乳\n' > memo.md
```

6. 解決したファイルをステージして、rebase を続けます。

```bash
git add memo.md
git rebase --continue
```

`git rebase --continue` を実行すると、コミットメッセージを確認するために VS Code でファイル（`COMMIT_EDITMSG`）が開きます。メッセージを変えないなら、そのままタブを閉じてください。閉じると rebase が先に進みます。

```text
[detached HEAD a1cbaae] 牛乳を追加
 1 file changed, 1 insertion(+)
Successfully rebased and updated refs/heads/topic.
```

2つ目のコミット（パンを追加）は、1つ目の解決結果の上にきれいに適用できたので、止まらずに終わりました。

7. 結果を確かめます。

```bash
git log --oneline --graph --all
cat memo.md
```

```text
* 4ac547a (HEAD -> topic) パンを追加
* a1cbaae 牛乳を追加
* 682bb25 (main) 卵を追加
* d5eb76b 予定ページを追加
* 586b30d 買い物メモを作成
```

```text
# 買い物メモ
- 卵
- 牛乳
- パン
```

### rebase 中に使うコマンド

| コマンド                | 意味                                                                                                     |
| ----------------------- | -------------------------------------------------------------------------------------------------------- |
| `git rebase --continue` | 解決したファイルを `git add` した後、次のコミットへ進む                                                  |
| `git rebase --abort`    | rebase を中止し、**rebase を始める前の状態** に完全に戻る                                                |
| `git rebase --skip`     | 今止まっているコミットを **適用せずに捨てて** 次へ進む（その変更は失われる。よくわからなければ使わない） |

> [!TIP]
> 途中でわからなくなったら、`git rebase --abort` で始める前に戻れます。rebase が終わった後なら、[2. の「rebase をなかったことにする」](#lab-setup) の方法（`ORIG_HEAD` や reflog）で戻れます。

---

<a id="interactive"></a>

## 7. 対話的 rebase（`git rebase -i`）でコミットを整える

### 何ができるか

`git rebase -i`（interactive）を使うと、付け替えるときに **コミットの順番を入れ替えたり、まとめたり、メッセージを直したり、消したり** できます。PR を出す前に「誤字修正」「さらに修正」のような細かいコミットを1つにまとめる、といった使い方をします（[Appendix：よいコミットの作り方](commit-best-practices.md)）。

> [!WARNING]
> 対話的 rebase もコミットを作り直します。**push 前のコミットだけ** に使ってください（[4. の原則](#golden-rule)）。

### 実験：3つのコミットを1つにまとめる

1. `topic` ブランチで、FAQ ページを作るコミットと、細かい修正のコミットを作ります。

```bash
echo "## よくある質問" > faq.md
git add faq.md
git commit -m "FAQ ページを追加"
echo "- Q. 初心者でも大丈夫ですか？" >> faq.md
git commit -am "質問を追加"
sed -i 's/大丈夫/だいじょうぶ/' faq.md
git commit -am "表記を修正"
git log --oneline -3
```

```text
22c9fea (HEAD -> topic) 表記を修正
0e0a794 質問を追加
2bb986b FAQ ページを追加
```

2. 直近の3つのコミットを対象に、対話的 rebase を始めます。

```bash
git rebase -i HEAD~3
```

3. VS Code で `git-rebase-todo` というファイルが開きます。上が古いコミットです。

```text
pick 2bb986b FAQ ページを追加
pick 0e0a794 質問を追加
pick 22c9fea 表記を修正

# Rebase 4ac547a..22c9fea onto 4ac547a (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
#                    commit's log message, unless -C is used, ...
# d, drop <commit> = remove commit
...
```

4. 2行目と3行目の先頭の `pick` を `fixup` に書き換えて保存し、タブを閉じます。

```text
pick 2bb986b FAQ ページを追加
fixup 0e0a794 質問を追加
fixup 22c9fea 表記を修正
```

5. 結果を確かめます。

```bash
git log --oneline -3
cat faq.md
```

```text
aa54ff5 (HEAD -> topic) FAQ ページを追加
4ac547a パンを追加
a1cbaae 牛乳を追加
```

```text
## よくある質問
- Q. 初心者でもだいじょうぶですか？
```

3つのコミットが「FAQ ページを追加」1つにまとまり、内容は3つ分すべて入っています。

### 主なコマンド

| コマンド        | 意味                                                                          |
| --------------- | ----------------------------------------------------------------------------- |
| `pick`（`p`）   | そのまま使う                                                                  |
| `reword`（`r`） | 使うが、メッセージを書き直す（エディタが開く）                                |
| `edit`（`e`）   | そこで止まる。`git commit --amend` などで直してから `git rebase --continue`   |
| `squash`（`s`） | 1つ前のコミットにまとめる。メッセージは両方をもとに書き直す（エディタが開く） |
| `fixup`（`f`）  | 1つ前のコミットにまとめる。メッセージは1つ前のものだけを使う                  |
| `drop`（`d`）   | そのコミットを捨てる（行を消しても同じ）                                      |
| 行の並べ替え    | コミットの順番を入れ替える（コンフリクトしやすいので注意）                    |

（出典：[git-rebase の INTERACTIVE MODE](https://git-scm.com/docs/git-rebase)）

> [!TIP]
> todo ファイルを開いた後で「やっぱりやめたい」ときは、**すべての行を消して保存** して閉じると、rebase は中止されます（ファイルの説明にも書かれています）。途中で止まった後なら `git rebase --abort` です。

### 応用：`--fixup` と `--autosquash`

「あのコミットの修正だ」とわかっているときは、修正コミットを作る時点で目印を付けておけます。

```bash
echo "- Q. 費用は？" >> faq.md
git commit -am "費用の質問を追加"
sed -i 's/費用は/費用はかかりますか/' faq.md
git commit -a --fixup HEAD
git log --oneline -2
```

```text
ce3d635 (HEAD -> topic) fixup! 費用の質問を追加
2377f63 費用の質問を追加
```

`--fixup HEAD` は「HEAD のコミットを直すためのコミット」を、`fixup! ` で始まるメッセージで作ります。後で `--autosquash` を付けて対話的 rebase すると、todo ファイルの並べ替えと `fixup` への書き換えが自動で済んだ状態で開きます。

```bash
git rebase -i --autosquash HEAD~3
```

```text
pick aa54ff5 FAQ ページを追加
pick 2377f63 費用の質問を追加
fixup ce3d635 fixup! 費用の質問を追加
```

そのまま保存してタブを閉じれば、修正がまとめられます。

---

<a id="pull-rebase"></a>

## 8. `git pull --rebase` と `pull.rebase`

### pull でも rebase できる

[Appendix：リモート追跡ブランチ](remote-tracking.md#pull) で説明したとおり、`git pull` は `fetch` の後に取り込みを行います。`--rebase` を付けると、取り込み方が merge から rebase に変わります。

```text
pull 前：手元で C を作ったが、GitHub では誰かが B を push していた

  手元の main：      A ── C
  origin/main：      A ── B

git pull（merge。この教材の設定）：

  A ── B ──── M   ← main     （M は「Merge branch 'main' of https://github.com/...」）
   \        /
    C ──────

git pull --rebase：

  A ── B ── C'   ← main      （C を B の上に付け替える。一直線）
```

`git pull --rebase` で付け替えられるのは、**まだ push していない自分のコミット（C）だけ** です。GitHub にある B は書き換えないので、「共有したコミットは rebase しない」原則には反しません。このため、`main` で直接作業する小さなプロジェクトでは、「Merge branch 'main' of ...」という意味の薄いマージコミットを増やさないために、`pull --rebase` をよく使います。

### 設定の選択肢

| 設定                                        | 動き                                                                                                                              |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `git config --global pull.rebase false`     | merge で取り込む（**この教材の設定**。1日目に設定済み）                                                                           |
| `git config --global pull.rebase true`      | rebase で取り込む                                                                                                                 |
| `git config --global rebase.autoStash true` | rebase の前に未コミットの変更を自動で [stash](undo-in-depth.md#stash) し、終わったら戻す（`pull.rebase true` と組み合わせて使う） |

この教材で `false` にしているのは、

- コンフリクトが起きたとき、7日目に学んだマージと同じ手順で、1回で解決できる
- rebase 中は Current と Incoming が逆に見えるなど、初心者がつまずきやすい点がある

からです。Git に慣れてきたら、自分のリポジトリで `pull.rebase true` を試してみるのもよいでしょう。設定の階層や消し方は [Appendix：Git の設定](git-config.md) を見てください。

---

<a id="github-rebase-merge"></a>

## 9. GitHub の「Rebase and merge」

GitHub の PR のマージボタンには、**Rebase and merge** という選択肢もあります。これは、PR のコミットを base ブランチの先に1つずつ付け替えて、マージコミットなしで取り込む方法です。GitHub の説明によると、この方法は **常に新しいコミット（新しいハッシュ値）を作ります**（出典：[About merge methods on GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github)）。そのため、マージ後は手元のブランチのコミットと `main` のコミットが「別物」になり、`git branch -d` で削除しようとすると「マージされていない」と言われることがあります。マージ方法の比較は [Appendix：GitHub でのチーム開発](github-collaboration.md#merge-methods) を見てください。

---

## まとめ

- rebase は、自分のコミットを別の土台の上に「作り直す」操作。中身は同じでもハッシュ値が変わる。
- merge は履歴をそのまま残し、rebase は一直線にする。どちらを使うかはチームで決める。
- **共有したブランチは rebase しない**。作り直したコミットと古いコミットが混ざり、他の人の作業が消えることがある。
- rebase 中のコンフリクトはコミットごとに起きうる。`--continue` で進み、`--abort` で始める前に戻る。Current と Incoming は merge と逆に見える。
- 対話的 rebase（`-i`）で、push 前のコミットをまとめたり直したりできる。
- `git pull --rebase` は、未 push の自分のコミットだけを付け替えるので安全に使える。この教材では `pull.rebase false`（merge）を使う。

## 関連ページ

- 本編：[12日目 チームでのコンフリクト](../docs/day12-team-conflict.md)、[13日目 最終課題に取り組む](../docs/day13-final-project.md)
- 演習：[rebase を試す（任意課題）](../exercises/day13-final-project/rebase-optional.md)
- レシピ：[branch-08](../recipes/branch.md#branch-08)、[trouble-08](../recipes/troubleshooting.md#trouble-08)、[undo-08](../recipes/undo.md#undo-08)
- Appendix：[ブランチとマージ](branches-and-merge.md)、[リモート追跡ブランチ](remote-tracking.md)、[取り消しの詳細](undo-in-depth.md)、[よいコミットの作り方](commit-best-practices.md)、[GitHub でのチーム開発](github-collaboration.md)

## 参考資料（公式ドキュメント）

- [git-rebase](https://git-scm.com/docs/git-rebase)
- [git-pull](https://git-scm.com/docs/git-pull)（`--rebase`）
- [Pro Git（日本語版）3.6 Git のブランチ機能 - リベース](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E6%A9%9F%E8%83%BD-%E3%83%AA%E3%83%99%E3%83%BC%E3%82%B9)
- [Pro Git（日本語版）7.6 Git のさまざまなツール - 歴史の書き換え](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E6%AD%B4%E5%8F%B2%E3%81%AE%E6%9B%B8%E3%81%8D%E6%8F%9B%E3%81%88)
- [GitHub Docs: About merge methods on GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github)

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
