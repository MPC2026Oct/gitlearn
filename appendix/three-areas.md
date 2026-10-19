# 3つの場所：ワーキングツリー・ステージ・リポジトリ

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[3日目](../docs/day03-first-commit.md)を読んだ人（`git diff` の章は[4日目](../docs/day04-diff-log-ignore.md)の内容です）
>
> **読む時間の目安**：25分（試しながらなら40分）

3日目では「ワーキングツリーで編集 → `git add` でステージ → `git commit` でリポジトリに記録」という流れを学びました。このページでは、3つの場所がそれぞれ **何を持っているのか**、ファイルがどんな状態を行き来するのか、そして「なぜわざわざステージという場所があるのか」を説明します。

## このページでわかること

- 3つの場所の役割と、パソコンの中での実体
- ステージ（インデックス）は「差分の置き場」ではなく「次のコミットの完成予想図」であること
- ファイルの4つの状態（untracked / unmodified / modified / staged）と、その移り変わり
- `git status -s` の2文字の記号の読み方
- ステージがある理由
- `git diff`、`git diff --staged`、`git diff HEAD` の違い

---

<a id="three-areas"></a>
## 1. 3つの場所の役割

```text
 ┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
 │ ワーキングツリー │      │ ステージ          │      │ リポジトリ        │
 │ (working tree)   │      │ (staging area /   │      │ (repository)      │
 │                  │      │  index)           │      │                   │
 │ 実際に編集する   │ add  │ 次のコミットの    │commit│ これまでの        │
 │ ファイル         │─────▶│ 完成予想図        │─────▶│ コミット（履歴）  │
 │                  │      │                   │      │                   │
 └──────────────────┘      └──────────────────┘      └──────────────────┘
   フォルダの中の            .git/index             .git/objects など
   ふつうのファイル          （1つのファイル）       （たくさんのファイル）
```

| 場所 | 中身 | パソコンの中での実体 | 中身を見るコマンド |
|---|---|---|---|
| ワーキングツリー（working tree） | 今まさに編集しているファイル | リポジトリのフォルダにある、ふつうのファイル | `ls`、VS Code のエクスプローラー |
| ステージ（staging area、インデックス〔index〕とも呼ぶ） | **次にコミットするときの、全ファイルの内容の一覧** | `.git/index` という1つのファイル | `git ls-files -s` |
| リポジトリ（repository） | これまでに作ったすべてのコミット | `.git` フォルダの中（主に `.git/objects`） | `git log`、`git show` |

### ステージは「次のコミットの完成予想図」

ステージについて、よくある誤解があります。

- × ステージは「変更した部分だけ」を置いておく場所
- ○ ステージは **「次のコミットをこの内容で作る」という、全ファイルの完成予想図**

`git add profile.md` は「`profile.md` の今の内容を、完成予想図に書き写す」操作です。`git commit` は「完成予想図をそのまま1枚の写真（スナップショット）として保存する」操作です。

そのため、**コミットした直後も、ステージは空になりません**。直前のコミットとまったく同じ内容の完成予想図が残っています。`git ls-files -s` でステージの中身を見ると、コミットした直後でも全ファイルが並んでいます。

```bash
cd ~/git-practice/my-profile
git ls-files -s
```

```text
100644 4150d05c23b87181e4a5b454e3669e6e511823d2 0	hobbies.md
100644 54ed5e876e60a44ff1e9e5c6f0cdac2b890081bf 0	profile.md
```

（ハッシュ値と並ぶファイルは人によって違います）

| 欄 | 意味 |
|---|---|
| `100644` | ファイルの種類（ふつうのファイル） |
| `4150d05c...` | ファイルの内容に付けられた番号（ハッシュ値）。[Git の内部構造](git-internals.md)で説明します |
| `0` | ステージ番号。ふだんは `0`。コンフリクトの最中だけ `1`〜`3` が現れます（[ブランチとマージ](branches-and-merge.md)） |
| `profile.md` | ファイル名 |

「変更があるかどうか」は、ステージが持っているのではなく、**2つの場所を比べた結果** として毎回計算されています。`git status` は、その比較結果を表示するコマンドです。

```text
         比べる                         比べる
 リポジトリ(HEAD) ◀──────▶ ステージ ◀──────▶ ワーキングツリー
      │                       │                     │
      └── 違えば「Changes to be committed」          │
                              └── 違えば「Changes not staged for commit」
```

（`HEAD` は「今いるブランチの最新のコミット」のことです。6日目で詳しく学びます）

---

<a id="data-flow"></a>
## 2. 場所の間でデータを動かすコマンド

```text
 ワーキングツリー            ステージ                 リポジトリ
       │                        │                        │
       │ ── git add ──────────▶ │                        │
       │                        │ ── git commit ───────▶ │
       │                        │                        │
       │                        │ ◀─ git restore --staged│  ステージを HEAD の内容に戻す
       │ ◀─ git restore ─────── │                        │  ワーキングツリーをステージの内容に戻す
       │ ◀──────────── git switch（ブランチの切り替え）──┤  両方をそのブランチの内容にする
```

- `git add`：ワーキングツリー → ステージ（写す）
- `git commit`：ステージ → リポジトリ（保存する）
- `git restore --staged <ファイル>`：ステージの内容を、直前のコミットの内容に戻す（ワーキングツリーはそのまま）
- `git restore <ファイル>`：ワーキングツリーの内容を、**ステージの内容** に戻す（編集の取り消し）

`git restore`（5日目）が「最後のコミット」ではなく「ステージ」の内容に戻す、という点は見落としやすいところです。`git add` してから編集を続け、`git restore` すると、`git add` した時点の内容に戻ります。取り消しの詳しい話は [取り消しの詳細](undo-in-depth.md) を見てください。

---

<a id="file-states"></a>
## 3. ファイルの4つの状態

Git から見ると、ワーキングツリーのファイルは次の4つのどれかの状態にあります（出典：[Pro Git「2.2 Git の基本 - 変更内容のリポジトリへの記録」](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E5%9F%BA%E6%9C%AC-%E5%A4%89%E6%9B%B4%E5%86%85%E5%AE%B9%E3%81%AE%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E3%81%B8%E3%81%AE%E8%A8%98%E9%8C%B2)）。

| 状態 | 意味 | `git status` での表示 |
|---|---|---|
| untracked（追跡されていない） | Git がまだ管理していない新しいファイル | `Untracked files:` |
| unmodified（変更なし） | 管理されていて、最後のコミットから変わっていない | 表示されない |
| modified（変更あり） | 管理されていて、編集されたが、まだステージしていない | `Changes not staged for commit:` |
| staged（ステージ済み） | 次のコミットに入れる準備ができている | `Changes to be committed:` |

### 状態の移り変わり

```text
                      git add
  ┌───────────┐ ───────────────────────────────────────────┐
  │ untracked │                                            ▼
  └───────────┘                                      ┌──────────┐
        ▲                                            │  staged  │
        │ git rm --cached                            └──────────┘
        │                                             │   ▲   │
  ┌────────────┐    編集する     ┌──────────┐ git add  │   │   │ git restore --staged
  │ unmodified │ ──────────────▶ │ modified │ ─────────┼───┘   │
  │            │ ◀────────────── │          │ ◀────────┼───────┘
  └────────────┘  git restore    └──────────┘          │
        ▲                                              │
        └──────────────── git commit ──────────────────┘
```

- 新しいファイルは **untracked** から始まり、`git add` で直接 **staged** になります。
- `git commit` すると、ステージ済みのファイルは **unmodified** になります。
- 編集すると **modified**、`git add` すると再び **staged** です。
- `git rm --cached <ファイル>` は「ファイルは手元に残したまま、Git の管理から外す」操作で、実行した直後から **untracked** として表示され、次のコミットで Git の管理から外れたことが記録されます（[レシピ basics-08](../recipes/basics.md#basics-08)）。

> [!NOTE]
> `.gitignore` で無視されたファイル（ignored）は、この4つとは別扱いで、`git status` に表示されません。無視されているファイルも表示したいときは `git status --ignored` を使います。

### 1つのファイルが「2つの状態」を同時に持つことがある

`git add` したあとにさらに編集すると、1つのファイルが **staged と modified の両方** になります。

```text
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   profile.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   profile.md
```

これは「ステージには `git add` した時点の内容が、ワーキングツリーにはその後の内容がある」という状態です。**このまま `git commit` すると、ステージの内容（`git add` した時点の内容）だけがコミットされ、その後の編集はコミットされません**。最新の内容をコミットしたいときは、もう一度 `git add` します。

---

<a id="status-short"></a>
## 4. git status -s の読み方

`git status -s`（`--short`）を使うと、状態を2文字の記号で短く表示できます。

```bash
git status -s
```

```text
MM profile.md
A  hobbies.md
 M favorites.md
?? memo.txt
```

**左の文字＝ステージの状態（HEAD と比べて）、右の文字＝ワーキングツリーの状態（ステージと比べて）** です。

```text
 M M  profile.md
 │ │
 │ └── 右：ワーキングツリーはステージと違う（ステージしていない変更がある）
 └──── 左：ステージは HEAD と違う（ステージ済みの変更がある）
```

| 記号 | 意味 |
|---|---|
| `??` | untracked（追跡されていない） |
| `A ` | 新しいファイルをステージした（added） |
| `M ` | 変更をステージした |
| ` M` | 変更したが、まだステージしていない |
| `MM` | ステージした後に、さらに変更した |
| `D ` / ` D` | 削除をステージした／削除したがまだステージしていない |
| `R ` | 名前の変更をステージした（renamed） |
| `UU` | コンフリクトしていて未解決（unmerged） |

（出典：[git-status の Short Format](https://git-scm.com/docs/git-status#_short_format)）

VS Code のソース管理ビューでも、ファイル名の右に `U`（untracked）、`M`（modified）、`A`（added）、`D`（deleted）などの文字が表示されます。「ステージされている変更」と「変更」の2つのグループに分かれて表示されるのは、左の文字と右の文字にそれぞれ対応しています。

---

<a id="why-stage"></a>
## 5. なぜステージが必要なのか

「`add` と `commit` の2段階は面倒。直接コミットすればいいのでは？」と感じるかもしれません。ステージがあることで、次のことができます。

### 理由1：変更の一部だけをコミットできる

1回の作業で、関係のない2つの変更（例：自己紹介の誤字修正と、新しい趣味の追加）をしてしまうことはよくあります。ステージがあれば、**1つずつ別のコミットに分けられます**（[よいコミットの単位](commit-best-practices.md)）。

- **ファイル単位**：`git add profile.md` だけして、`hobbies.md` は次のコミットにする。
- **行単位**：同じファイルの中の一部の変更だけをステージする。
  - Git Bash：`git add -p profile.md` を実行すると、変更のまとまり（hunk）ごとに `Stage this hunk [y,n,q,a,d,s,e,p,P,?]?` のように聞かれます（表示される文字はバージョンや状況で変わります）。`y` でステージ、`n` でステージしない、`q` で終了です。
  - VS Code：ソース管理ビューでファイルをクリックして差分を開き、ステージしたい行を選択して右クリック →「選択した範囲をステージする（Stage Selected Ranges）」。

### 理由2：コミットする前に確認できる

ステージは「この内容でコミットしてよいか」を確かめる下書きの場所です。`git diff --staged` で、**これからコミットされる内容だけ** を見直せます（次の章）。

### 理由3：コンフリクトの解決を記録する場所になる

7日目のコンフリクト解決では、ファイルを直したあとに `git add` しました。これは「このファイルは解決済み」という印をステージに付ける操作です。コンフリクトの最中、ステージには同じファイルの3つの版（共通の元・自分側・相手側）が置かれていて、`git add` するとそれが1つにまとまります（`git ls-files -s` で見るとステージ番号 `1`〜`3` が `0` になります）。

### 理由4：速さ

ステージ（`.git/index`）には、各ファイルの更新日時やサイズも記録されています。`git status` はまずこれを見て、変わっていないファイルの中身を読み直さずに済ませるので、ファイルが多くても速く動きます。

### ステージを省略する方法もある

- `git commit -a -m "メッセージ"`：**すでに管理されているファイル** の変更を、自動でステージしてからコミットします。新しいファイル（untracked）は含まれないので注意が必要です。
- VS Code では、何もステージしていない状態でコミットボタンを押すと、すべての変更をステージしてコミットするかどうかを確認するメッセージが出ます（スマートコミット）。

慣れるまでは、`git status` → `git add` → `git diff --staged` → `git commit` と1つずつ確かめるのがおすすめです。

---

<a id="diff"></a>
## 6. git diff・git diff --staged・git diff HEAD

4日目で `git diff` と `git diff --staged` を使いました。3つの場所で考えると、**どの2つを比べているか** の違いです。

```text
  リポジトリ(HEAD)          ステージ             ワーキングツリー
        │                      │                       │
        │                      │◀──── git diff ───────▶│   まだステージしていない変更
        │◀─ git diff --staged ▶│                       │   これからコミットされる変更
        │◀────────────── git diff HEAD ───────────────▶│   最後のコミットからの全部の変更
```

| コマンド | 比べるもの | 何がわかるか |
|---|---|---|
| `git diff` | ステージ ⇔ ワーキングツリー | `git add` すると何が追加でステージされるか |
| `git diff --staged`（`--cached` も同じ） | HEAD ⇔ ステージ | `git commit` すると何がコミットされるか |
| `git diff HEAD` | HEAD ⇔ ワーキングツリー | 最後のコミットから、手元で何が変わったか（ステージしたかどうかに関係なく） |

### 具体例

`profile.md` に「好きな食べ物」の行を追加して `git add` し、そのあと「ひとこと」の行を追加した（`MM` の状態）とします。

```bash
git diff
```

```text
diff --git a/profile.md b/profile.md
index 1657a74..abe3568 100644
--- a/profile.md
+++ b/profile.md
@@ -2,3 +2,4 @@

 ニックネーム: たいち
 好きな食べ物: カレー
+ひとこと: よろしく
```

```bash
git diff --staged
```

```text
diff --git a/profile.md b/profile.md
index 54ed5e8..1657a74 100644
--- a/profile.md
+++ b/profile.md
@@ -1,3 +1,4 @@
 # 自己紹介

 ニックネーム: たいち
+好きな食べ物: カレー
```

```bash
git diff HEAD
```

```text
diff --git a/profile.md b/profile.md
index 54ed5e8..abe3568 100644
--- a/profile.md
+++ b/profile.md
@@ -1,3 +1,5 @@
 # 自己紹介

 ニックネーム: たいち
+好きな食べ物: カレー
+ひとこと: よろしく
```

（ハッシュ値は人によって違います）

`index 1657a74..abe3568` の行の数字は、比べている2つのファイル内容のハッシュ値です。`git diff` と `git diff --staged` に共通して出てくる `1657a74` が、ステージにある内容です。

> [!NOTE]
> - `git diff` には、untracked（新しく作ってまだ `git add` していない）ファイルは表示されません。Git がまだそのファイルを知らないからです。
> - コミットが1つもないリポジトリでは、`HEAD` がまだ存在しないため `git diff HEAD` はエラーになります。

---

## 7. 試してみよう

`~/git-practice/appendix-lab/` の下に使い捨てのリポジトリを作って、3つの場所の動きを確かめます。作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\three-areas` フォルダを削除してから、もう一度最初から実行してください。

1. 練習用のリポジトリを作り、最初のコミットをします。

   ```bash
   mkdir -p ~/git-practice/appendix-lab/three-areas
   cd ~/git-practice/appendix-lab/three-areas
   git init
   printf '# 自己紹介\n\nニックネーム: たいち\n' > profile.md
   git add profile.md
   git commit -m "自己紹介を追加"
   ```

2. コミット直後でもステージが空でないことを確かめます。

   ```bash
   git ls-files -s
   ```

   ```text
   100644 54ed5e876e60a44ff1e9e5c6f0cdac2b890081bf 0	profile.md
   ```

   （このハッシュ値は、ファイルの内容がまったく同じなら、誰のパソコンでも同じになります。理由は [Git の内部構造](git-internals.md#hash) で説明します）

3. 1行追加してステージし、さらにもう1行追加します。

   ```bash
   echo "好きな食べ物: カレー" >> profile.md
   git add profile.md
   echo "ひとこと: よろしく" >> profile.md
   ```

4. 短い形式で状態を見ます。`MM` になっています。

   ```bash
   git status -s
   ```

   ```text
   MM profile.md
   ```

5. 3種類の diff を順に実行して、それぞれ何行が `+` で表示されるかを確かめます。

   ```bash
   git diff
   git diff --staged
   git diff HEAD
   ```

6. このままコミットします。

   ```bash
   git commit -m "好きな食べ物を追加"
   ```

7. 状態を見ると、「ひとこと」の行がまだ残っています。コミットされたのはステージの内容だけだったことがわかります。

   ```bash
   git status -s
   ```

   ```text
    M profile.md
   ```

8. ホームフォルダに戻ります。

   ```bash
   cd
   ```

> [!TIP]
> 手順1・3の `git add` や手順5の `git diff` で、`LF will be replaced by CRLF` という警告が出ることがあります（`printf` や `echo` で作ったファイルは LF になるため）。改行コードについてのお知らせで、無視してかまいません（[改行コードと文字コード](line-endings-and-encoding.md#lf-will-be-replaced)）。

---

## まとめ

- ワーキングツリーは編集中のファイル、ステージは次のコミットの完成予想図（`.git/index`）、リポジトリはコミットの集まり。
- ステージはコミット後も空にならない。「変更」は2つの場所を比べた結果として毎回計算される。
- ファイルの状態は untracked / unmodified / modified / staged の4つ。`git status -s` の左はステージ、右はワーキングツリー。
- ステージがあるから、変更の一部だけをコミットしたり、コミット前に確認したりできる。
- `git diff` はステージとの比較、`--staged` はコミットされる内容、`HEAD` は最後のコミットからの全部。

## 関連ページ

- [3日目：はじめてのコミット](../docs/day03-first-commit.md)（「3. 3つの場所：ワーキングツリー・ステージ・リポジトリ」）
- [4日目：差分・履歴・.gitignore](../docs/day04-diff-log-ignore.md)（「1. 差分を見る：git diff」）
- [5日目：取り消しとやり直し](../docs/day05-undo.md)（`restore` と `restore --staged`）
- [7日目：マージとコンフリクト](../docs/day07-merge-conflict.md)（「解決を記録する」）
- [レシピ basics-02 今の状態（何が変わったか）を確認したい](../recipes/basics.md#basics-02)
- [レシピ basics-03 変更をステージしてコミットしたい（全部／一部のファイルだけ）](../recipes/basics.md#basics-03)
- [レシピ basics-04 変更内容（差分）を見たい](../recipes/basics.md#basics-04)

## 参考資料

- Pro Git 日本語版「2.2 Git の基本 - 変更内容のリポジトリへの記録」：<https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E5%9F%BA%E6%9C%AC-%E5%A4%89%E6%9B%B4%E5%86%85%E5%AE%B9%E3%81%AE%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E3%81%B8%E3%81%AE%E8%A8%98%E9%8C%B2>
- Pro Git 日本語版「1.3 使い始める - Gitの基本」（3つの状態）：<https://git-scm.com/book/ja/v2/%E4%BD%BF%E3%81%84%E5%A7%8B%E3%82%81%E3%82%8B-Git%E3%81%AE%E5%9F%BA%E6%9C%AC>
- git-status（Short Format）：<https://git-scm.com/docs/git-status>
- git-diff：<https://git-scm.com/docs/git-diff>
- git-add（`-p` / `--patch`）：<https://git-scm.com/docs/git-add>
- git-ls-files：<https://git-scm.com/docs/git-ls-files>

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
