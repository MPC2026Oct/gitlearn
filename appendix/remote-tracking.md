# リモートとリモート追跡ブランチ：fetch・pull・push のしくみ

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[8日目「GitHub とつなぐ」](../docs/day08-remote-github.md) を読んだ人（[10日目](../docs/day10-pull-request.md)・[12日目](../docs/day12-team-conflict.md) の後に読み返すのもおすすめです）
>
> **読む時間の目安**：約30分（手を動かして試す場合は +25分）

8日目では、`push` で送り、`pull` で受け取り、`fetch` で「確認だけ」できることを学びました。このページでは、その裏で動いている **`origin/main` のような「リモート追跡ブランチ」** を中心に、手元と GitHub がどう同期しているのかを説明します。GitHub を使わずに、パソコンの中だけで「GitHub 役」と「2人のメンバー」を作って実験できるようにしてあります。

## このページでわかること

- 3種類の `main`（手元の `main`、`origin/main`、GitHub の `main`）の関係
- `origin` の正体と、`.git/config` に書かれている設定
- 上流ブランチ（upstream）と `-u` の意味、`git branch -vv` の読み方
- `fetch` は取得だけ、`pull` は `fetch` ＋ `merge`（または `rebase`）であること、`pull.rebase` の選択肢
- push が拒否される理由（non-fast-forward）
- `--force` と `--force-with-lease` の危険性と、安全に使うための条件
- GitHub で消したブランチを手元から片付ける `fetch --prune`

---

<a id="three-mains"></a>

## 1. 3種類の `main`

8日目の図をもう少し細かく描くと、次のようになります。

```text
  あなたのパソコン（.git の中）                          GitHub
 ┌─────────────────────────────────────┐            ┌───────────────┐
 │  main            … 自分が作業するブランチ │            │  main         │
 │                                        │  fetch     │  （GitHub 上の  │
 │  origin/main     … 「最後に確認したとき │ ←───────── │   ブランチ）    │
 │                     GitHub の main は   │            │               │
 │                     ここだった」という  │  push      │               │
 │                     メモ（読み取り専用）│ ─────────→ │               │
 └─────────────────────────────────────┘            └───────────────┘
```

| 名前 | どこにあるか | 誰が動かすか |
|---|---|---|
| `main`（ローカルブランチ） | 手元 | 自分（コミット、マージなど） |
| `origin/main`（リモート追跡ブランチ） | 手元 | `fetch`・`pull`・`push` のときに Git が自動で更新する |
| GitHub の `main` | GitHub | `push` や、GitHub 上でのプルリクエスト（Pull Request、略して PR）のマージ |

ポイントは、**`origin/main` は手元にある「メモ」にすぎない** ということです。GitHub の `main` が誰かの push で進んでも、手元で `fetch`（または `pull`）するまで `origin/main` は古いままです。

`origin/main` に直接コミットすることはできません（切り替えようとすると detached HEAD になります。[Appendix：ブランチとマージ](branches-and-merge.md#detached-head)）。

---

<a id="lab-setup"></a>

## 2. 実験用の「GitHub 役」とメンバーを用意する

GitHub の代わりに、手元に **ベアリポジトリ**（bare repository：ワーキングツリーを持たない、保管専用のリポジトリ）を作り、それを「アリス」と「ボブ」の2人分クローンします。GitHub と同じ `clone`・`push`・`pull` がそのまま使えます。

1. 次のコマンドを実行します。

```bash
mkdir -p ~/git-practice/appendix-lab/remote
cd ~/git-practice/appendix-lab/remote
git init --bare fake-github.git
git clone fake-github.git alice
git clone fake-github.git bob
```

```text
Cloning into 'alice'...
warning: You appear to have cloned an empty repository.
done.
Cloning into 'bob'...
warning: You appear to have cloned an empty repository.
done.
```

「空のリポジトリをクローンしたようです」という警告は、まだコミットが1つもないためで、問題ありません。

2. アリスが最初のコミットを作って push します。

```bash
cd ~/git-practice/appendix-lab/remote/alice
echo "# 共有メモ" > memo.md
git add memo.md
git commit -m "最初のコミット"
git push -u origin main
```

```text
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

> [!TIP]
> `git add` などで `LF will be replaced by CRLF` という警告が出ることがありますが、無視してかまいません（`printf` や `echo` で作ったファイルは改行コードが LF になるため。[改行コードと文字コード](line-endings-and-encoding.md#lf-will-be-replaced)、[レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)）。

3. ボブが受け取ります。

```bash
cd ~/git-practice/appendix-lab/remote/bob
git pull
```

```text
 * [new branch]      main       -> origin/main
```

作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\remote` フォルダを削除してから、もう一度実行してください。

---

<a id="origin"></a>

## 3. `origin` の正体

### origin は「URL のあだ名」

`origin` は、クローンしたときに Git が自動で付ける **リモートリポジトリの URL のあだ名** です。特別な意味はなく、名前を変えたり、2つ目のリモート（たとえばフォーク元を指す `upstream`）を追加したりもできます（[Appendix：GitHub でのチーム開発](github-collaboration.md#fork)）。

ボブのリポジトリの設定ファイルを見てみます。

```bash
cat .git/config
```

```text
[remote "origin"]
	url = …/git-practice/appendix-lab/remote/fake-github.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
	remote = origin
	merge = refs/heads/main
```

（`url` の部分は環境によって表示が違います。GitHub からクローンしたリポジトリでは `https://github.com/...` になります）

- `url`：`origin` の実際の場所です。`git remote -v` でも確認できます。
- `fetch = +refs/heads/*:refs/remotes/origin/*`：これは **refspec**（リフスペック）と呼ばれる対応表で、「リモートの `refs/heads/` にあるブランチを、すべて手元の `refs/remotes/origin/` にコピーする」という意味です。`origin/main` の正体は、手元の `.git/refs/remotes/origin/main` です。
- `[branch "main"]` の部分は、次の節で説明する **上流ブランチ** の設定です。

### リモート追跡ブランチを一覧する

```bash
git branch -a
```

```text
* main
  remotes/origin/main
```

`-a`（all）でローカルとリモート追跡ブランチの両方、`-r`（remote）でリモート追跡ブランチだけを表示します。GitHub からクローンしたリポジトリでは、`remotes/origin/HEAD -> origin/main`（GitHub 側の既定のブランチが `main` であること）も表示されます。

---

<a id="upstream"></a>

## 4. 上流ブランチ（upstream）と `-u`

### 上流ブランチとは

上流ブランチ（upstream branch）は、**「このローカルブランチは、どのリモートのどのブランチと対になっているか」** という設定です。8日目の `git push -u origin main` の `-u`（`--set-upstream`）は、push と同時にこの設定を書き込むオプションでした。`.git/config` の次の部分がそれです。

```text
[branch "main"]
	remote = origin
	merge = refs/heads/main
```

上流が設定されていると、次のことができるようになります。

| できること | 例 |
|---|---|
| 引数なしの `git push` / `git pull` | `git push origin main` と書かなくてよい |
| `git status` で「進んでいる／遅れている」を表示 | `Your branch is ahead of 'origin/main' by 1 commit.` |
| `git branch -vv` で対応を確認 | 下を参照 |
| VS Code のステータスバーに ↑↓ の数を表示 | ↑1 は「送っていないコミットが1つ」 |

### `git branch -vv` の読み方

```bash
git branch -vv
```

```text
* main 22a5c27 [origin/main] 最初のコミット
```

| 部分 | 意味 |
|---|---|
| `*` | 今いるブランチ |
| `22a5c27` | このブランチが指すコミット（人によって違います） |
| `[origin/main]` | 上流ブランチ。`[origin/main: ahead 1, behind 2]` なら「自分が1つ進み、2つ遅れている」 |
| `[origin/bob/test: gone]` | 上流のブランチがリモートで削除された（[7. fetch --prune](#prune)） |
| `[...]` がない | 上流が設定されていない（まだ push していない新しいブランチなど） |

### 上流を設定するほかの方法

- 新しいブランチを初めて push するとき：`git push -u origin <ブランチ名>`（10日目）。VS Code の「**Branch の発行**（Publish Branch）」も、push と上流の設定を同時に行います（出典：[VS Code Docs: Repositories & Remotes](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)）。
- `git switch <ブランチ名>` で、手元にないが `origin/<ブランチ名>` があるブランチに切り替えると、Git が自動でローカルブランチを作り、上流も設定します（11日目の「他の人のブランチを手元で確かめる」。後の実験で体験します）。
- すでにあるブランチに後から設定する：`git branch -u origin/main`（`--set-upstream-to`）
- 毎回 `-u` を書くのが面倒なら、`git config --global push.autoSetupRemote true` とすると、上流のない新しいブランチで `git push` しただけで同じ名前のブランチを作り、上流も設定するようになります（[Appendix：Git の設定](git-config.md)）。

> [!IMPORTANT]
> `ahead` / `behind` の数は、**手元の `origin/main`（最後に fetch したときのメモ）との比較** です。`git status` が「up to date」と言っていても、GitHub が本当に同じだとは限りません。次の実験で確かめます。

---

<a id="non-fast-forward"></a>

## 5. push が拒否されるしくみ（non-fast-forward）

### 実験：同時に変更して push する

1. ボブが追記して push します。

```bash
cd ~/git-practice/appendix-lab/remote/bob
echo "- ボブの行" >> memo.md
git commit -am "ボブが追記"
git push
```

2. アリスは、ボブの push を知らないまま別のファイルを追加します。

```bash
cd ~/git-practice/appendix-lab/remote/alice
echo "# アリスのページ" > alice.md
git add alice.md
git commit -m "アリスがページを追加"
git status
```

```text
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)
```

アリスの `origin/main` は古いままなので、Git は「1つ進んでいる」としか言いません。「遅れている」ことには気づいていません。

3. アリスが push します。

```bash
git push
```

```text
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to '…/fake-github.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. This is usually caused by another repository pushing to
hint: the same ref. If you want to integrate the remote changes, use
hint: 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

### なぜ拒否されるのか

push は、リモートのブランチの名札を自分のコミットへ進める操作です。Git は、**名札の移動が fast-forward（今の位置の子孫へ進むだけ）になるときだけ** push を受け付けます（出典：[git-push](https://git-scm.com/docs/git-push) の「NOTE ABOUT FAST-FORWARDS」）。

```text
GitHub 役の main：   A ── B（ボブ）
アリスの main：      A ── C（アリス）

アリスの push を受け付けると、main の名札が B から C へ移り、B がどこからもたどれなくなる
→ ボブの変更が消えてしまうので拒否する
```

拒否のメッセージには2種類あります。

| 表示 | 意味 |
|---|---|
| `(fetch first)` | リモートに、手元がまだ **受け取ってもいない** コミットがある |
| `(non-fast-forward)` | リモートのコミットは fetch 済みだが、まだ自分のブランチに **取り込んでいない** |

どちらも対処は同じで、「リモートの変更を取り込んでから push し直す」です（[レシピ trouble-04](../recipes/troubleshooting.md#trouble-04)）。

### 実験の続き：fetch して状況を確かめる

4. まず fetch だけします。

```bash
git fetch
git branch -vv
```

```text
* main 1793d9c [origin/main: ahead 1, behind 1] アリスがページを追加
```

今度は「1つ進んで、1つ遅れている」と正しく表示されました。

5. グラフで見ると、分かれていることがわかります。

```bash
git log --oneline --graph --all
```

```text
* 1793d9c (HEAD -> main) アリスがページを追加
| * 7fdd563 (origin/main) ボブが追記
|/
* 22a5c27 最初のコミット
```

6. 取り込んでから push します。`--no-edit` は、マージコミットのメッセージを既定のまま使うオプションです（付けないと VS Code が開くので、内容を確かめてタブを閉じます）。

```bash
git pull --no-edit
git push
```

```text
Merge made by the 'ort' strategy.
 memo.md | 1 +
 1 file changed, 1 insertion(+)
```

今度は push が通ります。マージコミットの親の1つがボブのコミットなので、GitHub 役の `main` から見て fast-forward になったからです。

### 実験の続き：ボブの「up to date」はうそ？

7. ボブ側で状態を見ます。

```bash
cd ~/git-practice/appendix-lab/remote/bob
git status
```

```text
On branch main
Your branch is up to date with 'origin/main'.
```

アリスが push したばかりなのに「最新です」と表示されます。ボブの `origin/main` が古いメモのままだからです。

8. fetch してからもう一度見ます。

```bash
git fetch
git status
```

```text
Your branch is behind 'origin/main' by 2 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)
```

9. 取り込みます。ボブは何もコミットしていないので fast-forward で済みます。

```bash
git pull
```

```text
Updating 7fdd563..647b038
Fast-forward
```

---

<a id="fetch"></a>

## 6. fetch と pull の違い

### fetch は「メモを最新にする」だけ

`git fetch` は、リモートの新しいコミットをダウンロードし、`origin/main` などの **リモート追跡ブランチだけ** を更新します。自分の `main` やワーキングツリーには一切触れないので、**いつ実行しても安全** です。「何が変わったか見てから取り込みたい」ときは、fetch してから次のように確かめます（[レシピ remote-06](../recipes/remote.md#remote-06)）。

```bash
git log --oneline main..origin/main
git diff main origin/main
```

`main..origin/main` は「`origin/main` にはあって `main` にはないコミット」、つまりこれから取り込まれるコミットを表します。

<a id="pull"></a>

### pull は fetch ＋ merge（または rebase）

```text
git pull  ＝  git fetch  ＋  git merge origin/main      （pull.rebase=false のとき）
          ＝  git fetch  ＋  git rebase origin/main     （pull.rebase=true のとき）
```

取り込む先は、上流ブランチの設定（`branch.main.merge`）で決まります。

### pull.rebase の選択肢

1日目に `git config --global pull.rebase false` を設定しました。これは「手元とリモートが分かれていたら、マージで取り込む」という設定です。

| 設定 | 分かれていたときの動き | 履歴 |
|---|---|---|
| `pull.rebase false`（この教材） | マージコミットを作る | 枝分かれが残る（「Merge branch 'main' of https://github.com/...」というコミットができる） |
| `pull.rebase true` | 自分の未 push のコミットを `origin/main` の先に付け替える | 一直線になる。ただしコンフリクトの解決がコミットごとになる（[Appendix：rebase](rebase.md#pull-rebase)） |
| `pull.ff only` | 取り込まずにエラーで止まる（fast-forward できるときだけ取り込む） | 自分で merge か rebase を選んで実行する |

どれも設定していない状態で、手元とリモートが分かれていると、Git は `Need to specify how to reconcile divergent branches`（分かれたブランチをどう統合するか指定してください）と表示して止まります（[レシピ trouble-08](../recipes/troubleshooting.md#trouble-08)）。この教材で `false` を選んでいるのは、7日目に学んだマージと同じしくみで説明でき、コンフリクトの解決も1回で済むからです。

> [!NOTE]
> VS Code の「変更の同期（Sync Changes）」は、pull してから push します。pull のしかた（マージか rebase か）は、上の Git の設定に従います（出典：[VS Code Docs: Repositories & Remotes](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)）。

---

<a id="prune"></a>

## 7. GitHub で消したブランチを片付ける：`fetch --prune`

### 削除したのに残る `origin/...`

10日目以降、PR をマージしたら GitHub 上のブランチを **Delete branch** で削除しています。ところが、手元の `origin/<ブランチ名>` は **自動では消えません**。fetch は既定では「増えたもの・進んだもの」を取ってくるだけで、「なくなったもの」を消さないからです。

### 実験：消えたブランチのメモが残る

1. ボブがブランチを作って push し、アリスが fetch します。

```bash
cd ~/git-practice/appendix-lab/remote/bob
git switch -c bob/test
git push -u origin bob/test
git switch main
cd ~/git-practice/appendix-lab/remote/alice
git fetch
git branch -r
```

```text
  origin/bob/test
  origin/main
```

2. ボブがリモートのブランチを削除します（GitHub の **Delete branch** と同じ操作です）。

```bash
cd ~/git-practice/appendix-lab/remote/bob
git push origin --delete bob/test
git branch -vv
```

```text
  bob/test 647b038 [origin/bob/test: gone] Merge branch 'main' of …
* main     647b038 [origin/main] Merge branch 'main' of …
```

ボブの手元のローカルブランチ `bob/test` は残っていて、上流が `gone`（なくなった）と表示されます。

3. アリスの手元では、まだ `origin/bob/test` が見えます。

```bash
cd ~/git-practice/appendix-lab/remote/alice
git branch -r
```

```text
  origin/bob/test
  origin/main
```

4. `--prune` を付けて fetch すると、リモートにないブランチのメモが消えます。

```bash
git fetch --prune
git branch -r
```

```text
 - [deleted]         (none)     -> origin/bob/test
  origin/main
```

### 毎回 prune する設定

次の設定を入れると、`git fetch` や `git pull` のたびに自動で prune します（[Appendix：Git の設定](git-config.md)）。

```bash
git config --global fetch.prune true
```

VS Code では、コマンドパレットの **Git: フェッチ（Prune）**（Git: Fetch (Prune)）で同じことができ、設定 `git.pruneOnFetch` を有効にすると毎回 prune します（出典：[VS Code Docs: Repositories & Remotes](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)）。

> [!NOTE]
> prune が消すのは `origin/...` のメモだけです。**ローカルブランチ**（上の例ではボブの `bob/test`）は消えないので、`git branch -d bob/test` で自分で削除します（[レシピ branch-04](../recipes/branch.md#branch-04)）。

---

<a id="force-push"></a>

## 8. `--force` と `--force-with-lease`

### force push とは

`git push --force`（`-f`）は、fast-forward でなくても **リモートの名札を自分のコミットに強制的に付け替える** push です。git-push のドキュメントは、これを「履歴を失うことを本当に意図している場合のための方法」と説明しています（出典：[git-push](https://git-scm.com/docs/git-push) の「NOTE ABOUT FAST-FORWARDS」）。

必要になるのは、push 済みのコミットを `--amend` や rebase で書き換えたときです。書き換えたコミットは元のコミットの子孫ではないので、ふつうの push は拒否されます。

> [!CAUTION]
> `main` など **複数人で使っているブランチに force push してはいけません**。他の人がすでに push したコミットが消えます（[なぜ消えるのか](undo-in-depth.md#rewrite-after-push)）。チームリポジトリでは、ルールセットの **Block force pushes** で `main` への force push を禁止できます（[Appendix：GitHub でのチーム開発](github-collaboration.md#rulesets)）。

### `--force-with-lease`：「自分の知っている状態のままなら」上書き

`--force-with-lease` は、「リモートのブランチが、**手元の `origin/<ブランチ名>` と同じ位置にあるときだけ** 上書きする」という条件付きの force push です（出典：[git-push](https://git-scm.com/docs/git-push) の `--force-with-lease`）。自分が最後に確認した後で誰かが push していたら、拒否してくれます。

### 実験：force-with-lease が守ってくれる場面

1. アリスが自分用のブランチを作って push します。

```bash
cd ~/git-practice/appendix-lab/remote/alice
git switch -c alice/topic
echo "- アリスの案" >> memo.md
git commit -am "アリスの案を追加"
git push -u origin alice/topic
```

2. ボブがそのブランチを手元に持ってきて、補足をコミットして push します。手元にない `alice/topic` に `git switch` すると、`origin/alice/topic` をもとにローカルブランチが自動で作られます。

```bash
cd ~/git-practice/appendix-lab/remote/bob
git fetch
git switch alice/topic
echo "- ボブの補足" >> memo.md
git commit -am "ボブが補足"
git push
```

```text
Switched to a new branch 'alice/topic'
branch 'alice/topic' set up to track 'origin/alice/topic'.
```

3. アリスは、ボブの push を知らないまま、自分のコミットのメッセージを `--amend` で直し、`--force-with-lease` で push しようとします。

```bash
cd ~/git-practice/appendix-lab/remote/alice
git commit --amend -m "アリスの案を追加（修正）"
git push --force-with-lease
```

```text
 ! [rejected]        alice/topic -> alice/topic (stale info)
```

`stale info`（情報が古い）として拒否されました。アリスの `origin/alice/topic` とリモートの実際の位置が違うためです。もし `--force` を使っていたら、**ボブの「補足」のコミットが消えていました**。

### 落とし穴：fetch した後だと守ってくれない

`--force-with-lease` が比べる相手は、手元の `origin/alice/topic` です。そのため、**push の前に fetch していると**（中身を見ていなくても）「最新を知っている」とみなされ、上書きが通ってしまいます。VS Code の自動フェッチ（設定 `git.autofetch`。執筆時点ではエディターでは既定でオフ）を有効にしている場合は、知らないうちに fetch されていることがあるので特に注意が必要です。

この穴をふさぐのが `--force-if-includes`（Git 2.30 以降）です。「リモートの先端のコミットを、自分のブランチに一度でも取り込んだことがあるか」を reflog で確かめ、取り込んでいなければ拒否します（出典：[git-push](https://git-scm.com/docs/git-push) の `--force-if-includes`）。

4. fetch してから、両方のオプションを付けて push してみます。

```bash
git fetch
git push --force-with-lease --force-if-includes
```

```text
 ! [rejected]        alice/topic -> alice/topic (remote ref updated since checkout)
```

fetch した後でも、ボブのコミットを取り込んでいないことを見抜いて拒否しました。

### 安全な使い方のまとめ

| ルール | 理由 |
|---|---|
| `--force` は使わず、`--force-with-lease --force-if-includes` を使う | 他の人の push を消す事故を防ぐ |
| `main` など共有ブランチには force push しない（ルールセットで禁止する） | 全員の手元とずれる |
| 自分しか使っていないブランチでも、PR のレビュー中は避ける | レビュアーのコメント位置が古くなり、手元に持ってきた人の履歴とずれる |
| この教材のチーム開発編では force push を使わない | 修正は新しいコミットを足す（11日目の PR の更新と同じ） |

---

## 9. clone で起きていること

最後に、2日目・8日目に使った `git clone` が何をしているかをまとめます。

1. 新しいフォルダを作り、`git init` する
2. リモートを `origin` という名前で登録する（`git remote add origin <URL>` と同じ）
3. `git fetch` して、すべてのブランチを `origin/...` として取得する
4. リモートの既定のブランチ（ふつうは `main`）と同じ名前のローカルブランチを作り、上流を `origin/main` に設定する
5. そのブランチに切り替え、ワーキングツリーにファイルを展開する

`origin/...` は全ブランチ分あるのに、ローカルブランチが `main` しかないのはこのためです。ほかのブランチは、必要になったときに `git switch <ブランチ名>` すれば作られます（[レシピ remote-07](../recipes/remote.md#remote-07)）。

---

## まとめ

- `origin/main` は「最後に fetch したときの GitHub の `main` の位置」を記録した手元のメモ。fetch するまで古いまま。
- 上流ブランチ（`-u`）を設定すると、引数なしの push / pull や ahead / behind の表示が使える。表示は最後の fetch 時点との比較。
- `fetch` は取得だけで安全。`pull` は `fetch` ＋ `merge`（`pull.rebase=true` なら `rebase`）。
- push は fast-forward のときだけ受け付けられる。拒否されたら、取り込んでから push し直す。
- force push は共有ブランチでは使わない。どうしても必要なら `--force-with-lease --force-if-includes`。
- GitHub で消したブランチのメモは `git fetch --prune`（または `fetch.prune=true`）で片付ける。

## 関連ページ

- 本編：[8日目 GitHub とつなぐ](../docs/day08-remote-github.md)、[10日目 はじめてのプルリクエスト](../docs/day10-pull-request.md)、[11日目 コードレビュー](../docs/day11-code-review.md)、[12日目 チームでのコンフリクト](../docs/day12-team-conflict.md)
- レシピ：[remote-01](../recipes/remote.md#remote-01)〜[remote-07](../recipes/remote.md#remote-07)、[branch-04](../recipes/branch.md#branch-04)、[branch-08](../recipes/branch.md#branch-08)、[trouble-04](../recipes/troubleshooting.md#trouble-04)、[trouble-07](../recipes/troubleshooting.md#trouble-07)、[trouble-08](../recipes/troubleshooting.md#trouble-08)
- Appendix：[認証のしくみ](authentication.md)、[Git の設定](git-config.md)、[ブランチとマージ](branches-and-merge.md)、[rebase](rebase.md)、[GitHub でのチーム開発](github-collaboration.md)

## 参考資料（公式ドキュメント）

- [git-fetch](https://git-scm.com/docs/git-fetch)、[git-pull](https://git-scm.com/docs/git-pull)、[git-push](https://git-scm.com/docs/git-push)
- [git-branch](https://git-scm.com/docs/git-branch)（`-vv`、`--set-upstream-to`）
- [Pro Git（日本語版）3.5 Git のブランチ機能 - リモートブランチ](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E6%A9%9F%E8%83%BD-%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%88%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81)
- [VS Code Docs: Repositories & Remotes](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
