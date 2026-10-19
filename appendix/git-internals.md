# Git の内部構造：.git フォルダとオブジェクト

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[3日目](../docs/day03-first-commit.md)を読んだ人（ブランチと HEAD の章は[6日目](../docs/day06-branch.md)の内容です）
>
> **読む時間の目安**：35分（試しながらなら50分）

3日目で「`.git` フォルダは消さないでください」と説明しました。このページでは、その `.git` フォルダを開けて、Git がコミットやブランチを **実際にどう保存しているか** を観察します。仕組みがわかると、「コミットの番号（ハッシュ）はどうやって決まるのか」「ブランチを作るとなぜ一瞬で終わるのか」「`--amend` でなぜ番号が変わるのか」が自然に理解できるようになります。

このページのコマンドは、`my-profile` の中身を **読むだけ** で、何も変更しません。安心して試してください。

## このページでわかること

- `.git` フォルダの中身
- Git の3種類のオブジェクト（blob・tree・commit）
- ハッシュ値の決まり方と、SHA-1／SHA-256
- `git cat-file` でオブジェクトの中身を見る方法
- コミットは「差分」ではなく「スナップショット」であること
- ブランチと HEAD は、ファイルに書かれた「参照」にすぎないこと

---

<a id="dot-git"></a>
## 1. .git フォルダの中身

### .git フォルダを見る

`.git` は名前が `.` で始まるので、ふだんは表示されません。

- Git Bash：`ls -a` で表示されます。
- エクスプローラー：上部の「表示」→「表示」→「隠しファイル」にチェックを入れると表示されます（Windows 11、執筆時点の表示です）。

```bash
cd ~/git-practice/my-profile
ls -F .git
```

```text
COMMIT_EDITMSG  config  description  HEAD  hooks/  index  info/  logs/  objects/  ORIG_HEAD  refs/
```

（ファイルの種類や数は、そのリポジトリで行った操作やバージョンによって違います）

### 主なファイルとフォルダ

| 名前                      | 中身                                                                                    | 関連するページ                                   |
| ------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `HEAD`                    | 今いるブランチ（[6章](#refs)）                                                          | 6日目                                            |
| `config`                  | このリポジトリの設定（local の設定）                                                    | [Git の設定のしくみ](git-config.md#config-files) |
| `index`                   | ステージの中身（バイナリーファイル）                                                    | [3つの場所](three-areas.md)                      |
| `objects/`                | **コミットやファイルの内容そのもの**（[2〜5章](#objects)）                              | このページ                                       |
| `refs/heads/`             | ブランチ。ブランチ名と同じ名前のファイル                                                | このページ、6日目                                |
| `refs/tags/`              | タグ                                                                                    | 14日目                                           |
| `refs/remotes/`           | リモート追跡ブランチ（`origin/main` など）                                              | [リモート追跡ブランチ](remote-tracking.md)       |
| `logs/`                   | HEAD やブランチが動いた記録（reflog）                                                   | [取り消しの詳細](undo-in-depth.md)               |
| `hooks/`                  | 特定の操作の前後に自動で動くスクリプトの置き場（最初は見本 `*.sample` だけ）            | —                                                |
| `info/exclude`            | このリポジトリだけの、コミットされない無視リスト（`.gitignore` と同じ書き方）           | 4日目                                            |
| `COMMIT_EDITMSG`          | 最後に書いたコミットメッセージ                                                          | —                                                |
| `ORIG_HEAD`、`FETCH_HEAD` | マージや `reset`、`fetch` のときに Git が一時的に使うメモ                               | —                                                |
| `packed-refs`             | ブランチやタグをまとめて1つのファイルに保存したもの（クローンしたリポジトリなどにある） | [6章](#refs)                                     |
| `description`             | 古いツール（gitweb）用の説明文。ふだんは使わない                                        | —                                                |

> [!CAUTION]
> `.git` の中のファイルを手で書き換えたり消したりしないでください。ここで紹介するのは「見るだけ」の操作です。`.git` フォルダを消すと、そのリポジトリの履歴はすべて失われます（ワーキングツリーのファイルは残りますが、ただのフォルダに戻ります）。

### 「`.git` があるフォルダ」がリポジトリ

Git のコマンドは、今いるフォルダから親フォルダへとさかのぼって `.git` を探し、見つかったところをリポジトリとして扱います。見つからないと `fatal: not a git repository` になります（[レシピ trouble-03](../recipes/troubleshooting.md#trouble-03)）。3日目で「`gitlearn` の中で `git init` しない」と注意したのは、リポジトリの中に別のリポジトリができると、どちらの `.git` が使われるのかがわかりにくくなるからです。

今いるリポジトリの `.git` の場所は、次のコマンドで確かめられます。

```bash
git rev-parse --git-dir
```

```text
.git
```

---

<a id="objects"></a>
## 2. 3種類のオブジェクト：blob・tree・commit

Git は、保存するものをすべて **オブジェクト（object）** という単位で `.git/objects` に入れています。ふだん使うのは次の3種類です。

| 種類                   | 保存するもの                                                             | 例えると                               |
| ---------------------- | ------------------------------------------------------------------------ | -------------------------------------- |
| **blob**（ブロブ）     | ファイルの **中身だけ**（ファイル名は持たない）                          | 原稿の紙                               |
| **tree**（ツリー）     | フォルダの中身の一覧：「ファイル名 ⇔ blob」「フォルダ名 ⇔ tree」の対応表 | 原稿をまとめたファイルの目次           |
| **commit**（コミット） | ある時点の一番上の tree、1つ前のコミット（親）、作者、日時、メッセージ   | 目次に付けた「いつ・誰が・なぜ」の付箋 |

`my-profile` に2つのコミットがあるとき、オブジェクトは次のようにつながっています（例を簡単にするため、2コミットだけの架空の my-profile で説明します。本編のコミットメッセージやファイルの中身とは違います）。

```text
 commit 9bb31c5  「趣味を追加」
 ├─ tree  bb4a0be ──┬── hobbies.md ─▶ blob 4150d05  （- 読書 …）
 │                  └── profile.md ─▶ blob 54ed5e8  （# 自己紹介 …）
 │                                        ▲
 └─ parent                                │ 同じ blob を共有
      │                                   │
      ▼                                   │
 commit 1d9c7f0  「自己紹介を追加」         │
 └─ tree  b845b2e ───── profile.md ───────┘
```

（ハッシュ値は人によって違います）

このほか、`git tag -a` で作る注釈付きタグ（作者やメッセージを持つタグ）は、**tag** という4種類目のオブジェクトとして保存されます。14日目に GitHub の Release 画面で作った `v1.0` は軽量タグ（コミットを直接指す参照）なので、tag オブジェクトはできません（執筆時点の動作。チームのリポジトリで `git cat-file -t v1.0` で確認できます。`commit` と表示されれば軽量タグ、`tag` と表示されれば注釈付きタグです）。

---

<a id="hash"></a>
## 3. ハッシュ値：内容から決まる番号

### ハッシュ値とは

オブジェクトには、`54ed5e876e60a44ff1e9e5c6f0cdac2b890081bf` のような40文字の番号が付いています。これは **ハッシュ値**（hash）と呼ばれ、オブジェクトの **内容から計算** されます。

- 同じ内容なら、誰のパソコンで計算しても **必ず同じ番号** になる
- 1文字でも違えば、**まったく違う番号** になる
- 番号から元の内容を逆算することはできない

Git はこの番号をファイル名として、オブジェクトを `.git/objects/54/ed5e876e...` のように保存します（先頭2文字がフォルダ名、残り38文字がファイル名）。このように「内容から決まる番号で保存する」方式を、**内容アドレス方式**（content-addressable）といいます。

### 自分で確かめる

`git hash-object` は、ファイルや文字列のハッシュ値を計算するだけのコマンドです（保存はしません）。

```bash
echo "hello" | git hash-object --stdin
```

```text
ce013625030ba8dba906f756967f9e9ca394464a
```

この値は、**世界中の誰が実行しても同じ** です。Git は blob のハッシュ値を「`blob <バイト数>` ＋ ヌル文字 ＋ 内容」に対して SHA-1 という計算方法で求めています。同じことを `sha1sum` コマンドで再現できます（`echo "hello"` の出力は「hello」＋改行の6バイトです）。

```bash
printf 'blob 6\0hello\n' | sha1sum
```

```text
ce013625030ba8dba906f756967f9e9ca394464a  -
```

（出典：[Pro Git「10.2 Gitの内側 - Gitオブジェクト」](https://git-scm.com/book/ja/v2/Git%e3%81%ae%e5%86%85%e5%81%b4-Git%e3%82%aa%e3%83%96%e3%82%b8%e3%82%a7%e3%82%af%e3%83%88)）

### 短いハッシュ値

`git log --oneline` で表示される `1d9c7f0` のような7文字は、40文字のハッシュ値の **先頭部分** です。リポジトリの中で区別できる長さなら、短いままコマンドに使えます（例：`git show 1d9c7f0`）。オブジェクトが増えて7文字では区別できなくなると、Git は自動的にもっと長く表示します。

### SHA-1 と SHA-256

Git は長いあいだ SHA-1 という計算方法を使ってきました。2017年に SHA-1 で「別の内容なのに同じハッシュ値になる」組み合わせ（衝突）を作る攻撃が実際に示されたため、Git 2.13 からはこの攻撃を検出できる強化版の SHA-1 を使っています（出典：[hash-function-transition](https://git-scm.com/docs/hash-function-transition)）。

さらに、より強い **SHA-256**（ハッシュ値が64文字）を使うリポジトリも作れるようになっています（`git init --object-format=sha256`）。Git 3.0 では新しいリポジトリの既定を SHA-256 にする計画ですが、GitHub などのサービスやツールが対応していることが前提とされています（出典：[Git の BreakingChanges](https://git-scm.com/docs/BreakingChanges)）。執筆時点では SHA-1 が既定なので、この教材のリポジトリもすべて SHA-1（40文字）です。

---

<a id="cat-file"></a>
## 4. git cat-file で中身を見る

`.git/objects` の中のファイルは圧縮されているので、`cat` で開いても読めません。中身を見るには `git cat-file` を使います。

| コマンド                         | 表示するもの                         |
| -------------------------------- | ------------------------------------ |
| `git cat-file -t <オブジェクト>` | 種類（blob / tree / commit / tag）   |
| `git cat-file -p <オブジェクト>` | 中身を読みやすく表示（pretty-print） |
| `git cat-file -s <オブジェクト>` | サイズ（バイト数）                   |

`<オブジェクト>` にはハッシュ値のほか、次のような書き方が使えます。

| 書き方            | 意味                                       |
| ----------------- | ------------------------------------------ |
| `HEAD`            | 今いるブランチの最新のコミット             |
| `main`            | `main` ブランチの最新のコミット            |
| `HEAD~1`          | HEAD の1つ前（親）のコミット               |
| `HEAD^{tree}`     | HEAD のコミットが指している tree           |
| `HEAD:profile.md` | HEAD のコミットの中の `profile.md`（blob） |

<a id="commit-object"></a>
### コミットの中身

```bash
cd ~/git-practice/my-profile
git cat-file -t HEAD
git cat-file -p HEAD
```

```text
commit
tree bb4a0be17c2b36a6fc4defe666df9c6dc7f91787
parent 1d9c7f0b3d5de29ccd93eb4b18f5173a6b66ae6e
author たいち <12345678+hydr4@users.noreply.github.com> 1791900000 +0900
committer たいち <12345678+hydr4@users.noreply.github.com> 1791900000 +0900

趣味を追加
```

（ハッシュ値・名前・日時は人によって違います）

| 行          | 意味                                                                                                      |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| `tree`      | このコミットの時点の、一番上のフォルダの tree                                                             |
| `parent`    | 1つ前のコミット（親）。最初のコミットにはこの行がなく、マージコミットには2行ある                          |
| `author`    | 変更を書いた人。`user.name`、`user.email`、日時（1970年1月1日からの秒数）とタイムゾーン（日本は `+0900`） |
| `committer` | コミットを作った人。ふだんは author と同じ。GitHub 上でマージしたときなどに違うことがある                 |
| 空行の後    | コミットメッセージ                                                                                        |

コミットに書かれているのは、**差分ではなく「どの tree か」** だけだという点に注目してください。

### tree の中身

```bash
git cat-file -p HEAD^{tree}
```

```text
100644 blob 4150d05c23b87181e4a5b454e3669e6e511823d2	hobbies.md
100644 blob 54ed5e876e60a44ff1e9e5c6f0cdac2b890081bf	profile.md
```

各行は「モード、種類、ハッシュ値、名前」です。モードは `100644` がふつうのファイル、`100755` が実行可能なファイル、`040000` がフォルダ（中身は別の tree）を表します。同じ内容は `git ls-tree HEAD` でも表示できます。

### blob の中身

```bash
git cat-file -p HEAD:profile.md
```

```text
# 自己紹介

ニックネーム: たいち
```

blob には **ファイル名も日時も入っていない**、中身だけです。名前は tree が持っています。そのため、ファイル名だけを変えたコミットでは、新しい blob は作られず、tree の名前の欄だけが変わります。

---

<a id="snapshot"></a>
## 5. コミットは「差分」ではなく「スナップショット」

### 変わっていないファイルは同じ blob を指す

2章の図をもう一度見てください。1つ目のコミットと2つ目のコミットの tree は、どちらも `profile.md` として **同じ blob（`54ed5e8`）** を指しています。2つ目のコミットでは `profile.md` を変更していないので、内容が同じ＝ハッシュ値が同じ＝同じオブジェクトをそのまま使っているのです。

```text
 コミット1「自己紹介を追加」          コミット2「趣味を追加」
        │                                    │
        ▼                                    ▼
 tree b845b2e                         tree bb4a0be
  └ profile.md ──────┐                 ├ hobbies.md ──▶ blob 4150d05（新しく作られた）
                     │                 └ profile.md ──┐
                     ▼                                │
              blob 54ed5e8 ◀──────────────────────────┘
              （2つのコミットで共有）
```

つまり、Git のコミットは **「その時点の全ファイルの写真（スナップショット）」** です。ただし、変わっていないファイルは前と同じ blob を指すだけなので、コミットのたびに全ファイルが複製されるわけではありません。

### 差分はその場で計算している

`git show` や `git diff` で表示される差分は、保存されているものではなく、**2つのスナップショットを比べてその場で計算した結果** です。だから、隣り合っていない2つのコミットでもすぐに比べられます（例：`git diff HEAD~2 HEAD`）。

### パックファイル：保存の工夫

1つ1つのオブジェクトがばらばらのファイル（loose object）のままだと、ファイルの数が増えすぎます。そこで Git は、ときどき（`git gc` が自動で動いたときや、クローン・push のとき）オブジェクトを **パックファイル**（`.git/objects/pack/` の中）にまとめ、似た内容の間では差分の形で圧縮して保存します。

これはあくまで **保存容量を減らす工夫** で、`git cat-file` などで取り出すと、どのオブジェクトも元のままの完全な内容として出てきます。考え方としては「スナップショット」のままです。

```bash
git count-objects -vH
```

```text
count: 6
size: 24.00 KiB
in-pack: 0
packs: 0
size-pack: 0 bytes
prune-packable: 0
garbage: 0
size-garbage: 0 bytes
```

（`count` はばらばらのオブジェクトの数、`in-pack` はパックファイルの中のオブジェクトの数です。数値は人によって違います。2日目にクローンした `gitlearn` で実行すると、ほとんどが `in-pack` に入っていることがわかります）

---

<a id="refs"></a>
## 6. ブランチと HEAD は「参照」

### ブランチの正体

6日目で「ブランチは付箋のようなもの」と説明しました。実際、ブランチは **コミットのハッシュ値を1つ書いただけの小さなファイル** です。

```bash
cat .git/refs/heads/main
```

```text
9bb31c55bd4553e6bedc8310c02ae5cba9f3a9d7
```

これが `main` ブランチの正体です。`git switch -c add-favorites` でブランチを作ると、Git は `.git/refs/heads/add-favorites` というファイルを作り、今のコミットのハッシュ値を書き込みます。**ファイルを1つ作るだけなので、ブランチの作成は一瞬で終わります**。

### HEAD の正体

```bash
cat .git/HEAD
```

```text
ref: refs/heads/main
```

`HEAD` は「今いるブランチはどれか」を書いたファイルで、中身はハッシュ値ではなく **ブランチの名前**（への参照）です。

```text
  .git/HEAD                 .git/refs/heads/main           .git/objects
 ┌─────────────────────┐   ┌──────────────────┐
 │ ref: refs/heads/main│──▶│ 9bb31c5...       │──▶ commit 9bb31c5「趣味を追加」
 └─────────────────────┘   └──────────────────┘          │ parent
                           ┌──────────────────┐          ▼
                           │ refs/heads/       │    commit 1d9c7f0「自己紹介を追加」
                           │   add-favorites   │──▶ （別のコミットを指すこともある）
                           └──────────────────┘
```

### コミットすると何が起きるか

`git commit` をすると、Git は次の順に処理します。

1. ステージ（`.git/index`）の内容から blob と tree を作る（同じ内容のものはすでにあるので作らない）
2. その tree と、親（今の HEAD が指すコミット）を書いた commit オブジェクトを作る
3. **今いるブランチのファイル**（`.git/refs/heads/main`）に、新しいコミットのハッシュ値を上書きする

HEAD は「ブランチの名前」を指したままなので、ブランチが進むと HEAD も一緒に進んだことになります。`git switch main` は、`.git/HEAD` の中身を `ref: refs/heads/main` に書き換え、ワーキングツリーとステージをそのコミットの内容にそろえる操作です。

> [!NOTE]
> `.git/HEAD` にブランチ名ではなくハッシュ値が直接書かれている状態を **detached HEAD**（HEAD がブランチから外れた状態）といいます。過去のコミットを `git switch --detach <コミット>` で見に行ったときなどに起こります。詳しくは [ブランチとマージ](branches-and-merge.md) を見てください。

### ファイルが見当たらないときは

クローンしたリポジトリなどでは、ブランチやタグが `.git/refs/` の下の個別のファイルではなく、`.git/packed-refs` という1つのファイルにまとめて書かれていることがあります。また、将来のバージョンでは参照の保存方法そのもの（reftable という新しい形式）が変わる可能性もあります。**どの場合でも同じ結果が得られる** のは次のコマンドです。

```bash
git symbolic-ref HEAD
git rev-parse main
git show-ref
```

```text
refs/heads/main
9bb31c55bd4553e6bedc8310c02ae5cba9f3a9d7
9bb31c55bd4553e6bedc8310c02ae5cba9f3a9d7 refs/heads/main
```

（1行目は今いるブランチ、2行目は `main` が指すコミット、3行目以降はすべてのブランチとタグの一覧です。ハッシュ値と並ぶ参照は人によって違い、8日目以降は `refs/remotes/origin/main` なども表示されます）

---

<a id="hash-changes"></a>
## 7. コミットのハッシュ値が変わる操作

コミットのハッシュ値は、**tree・親・作者・日時・メッセージのすべて** から計算されます。どれか1つでも変わると別のコミットになります。

- `git commit --amend`（5日目）でメッセージを直すと、メッセージが変わるので **新しいハッシュ値のコミット** ができ、ブランチがそちらを指すようになります。古いコミットは消えずに残っていますが、どのブランチからも指されなくなります（`git reflog` で見つけられます）。
- 親のハッシュ値もコミットの内容の一部なので、**過去のコミットを1つ変えると、それより後のコミットもすべて別のハッシュ値になります**。

```text
 元の履歴：      A ── B ── C ── D        （main は D を指す）
 B を直すと：    A ── B' ── C' ── D'     （B' の親は A。C' の親は B' …）
                       ↑ B, C, D とは別のコミット
```

すでに push して他の人が持っている履歴でこれをすると、「同じはずの履歴」が人によって違うハッシュ値の別物になってしまいます。「push したコミットは書き換えない」というルールの理由はここにあります（[取り消しの詳細](undo-in-depth.md)、[rebase](rebase.md)）。

> [!TIP]
> 逆に言えば、**ハッシュ値が同じなら、そのコミットまでの履歴全体が完全に同じ** であることが保証されます。GitHub と手元で `git log --oneline` の番号を比べるだけで「同じ状態か」がわかるのは、このためです。

---

## 8. 試してみよう：オブジェクトができる様子を観察する

`~/git-practice/appendix-lab/` の下に使い捨てのリポジトリを作って、`git add` と `git commit` のたびにオブジェクトが増える様子を見ます。作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\internals` フォルダを削除してから、もう一度最初から実行してください。

1. 練習用のリポジトリを作り、`.git/objects` の中に何もないことを確かめます。

   ```bash
   mkdir -p ~/git-practice/appendix-lab/internals
   cd ~/git-practice/appendix-lab/internals
   git init
   find .git/objects -type f
   ```

   （何も表示されません）

2. ファイルを作ってステージし、もう一度見ます。**`git add` の時点で blob が1つできています**。

   ```bash
   echo "hello" > hello.txt
   git add hello.txt
   find .git/objects -type f
   ```

   ```text
   .git/objects/ce/013625030ba8dba906f756967f9e9ca394464a
   ```

   （`git add` のときに `LF will be replaced by CRLF` という警告が出ることがありますが、無視してかまいません。[改行コードと文字コード](line-endings-and-encoding.md#lf-will-be-replaced)を参照）

   3章で計算した `ce01362...` と同じ番号です。

3. コミットして、もう一度見ます。tree と commit が増えて3つになります。

   ```bash
   git commit -m "hello を追加"
   find .git/objects -type f
   ```

   ```text
   .git/objects/ce/013625030ba8dba906f756967f9e9ca394464a
   .git/objects/aa/a96ced2d9a1c8e72c56b253a0e2fe78393feb7
   .git/objects/xx/...（commit）
   ```

   （tree（`aaa96ce…`）も中身から決まるので、誰が試しても同じです。commit だけは日時と名前を含むので、人によって違います。表示の順番も違うことがあります）

4. コミットから順にたどります。

   ```bash
   git cat-file -p HEAD
   git cat-file -p HEAD^{tree}
   git cat-file -p HEAD:hello.txt
   ```

5. ブランチを作って、ファイルが1つ増えるだけであることを確かめます。

   ```bash
   git branch test-branch
   ls .git/refs/heads
   cat .git/refs/heads/test-branch
   git rev-parse HEAD
   ```

   最後の2つのコマンドは、同じハッシュ値を表示します。

6. ホームフォルダに戻ります。

   ```bash
   cd
   ```

---

## まとめ

- `.git` フォルダがリポジトリの本体。手で編集せず、`git` コマンドで観察する。
- オブジェクトは blob（中身）・tree（名前と構造）・commit（tree＋親＋作者＋メッセージ）の3種類。
- ハッシュ値は内容から計算される。同じ内容なら誰でも同じ番号、少しでも違えば別の番号。
- コミットはスナップショット。変わっていないファイルは同じ blob を共有し、差分は表示のたびに計算される。
- ブランチはハッシュ値を書いた小さなファイル、HEAD は「今いるブランチ」を書いたファイル。
- コミットのどこかを変えると、それ以降のコミットのハッシュ値もすべて変わる。だから push 後の履歴は書き換えない。

## 関連ページ

- [3日目：はじめてのコミット](../docs/day03-first-commit.md)（「.git フォルダについて」）
- [4日目：差分・履歴・.gitignore](../docs/day04-diff-log-ignore.md)（`git show` とハッシュ）
- [5日目：取り消しとやり直し](../docs/day05-undo.md)（`--amend` と reflog）
- [6日目：ブランチ](../docs/day06-branch.md)（「HEAD とは」）
- [レシピ trouble-03 `fatal: not a git repository` と出る](../recipes/troubleshooting.md#trouble-03)

## 参考資料

- Pro Git 日本語版「10.2 Gitの内側 - Gitオブジェクト」：<https://git-scm.com/book/ja/v2/Git%e3%81%ae%e5%86%85%e5%81%b4-Git%e3%82%aa%e3%83%96%e3%82%b8%e3%82%a7%e3%82%af%e3%83%88>
- Pro Git 日本語版「10.3 Gitの内側 - Gitの参照」：<https://git-scm.com/book/ja/v2/Git%e3%81%ae%e5%86%85%e5%81%b4-Git%e3%81%ae%e5%8f%82%e7%85%a7>
- gitrepository-layout（`.git` の中身の公式説明）：<https://git-scm.com/docs/gitrepository-layout>
- git-cat-file：<https://git-scm.com/docs/git-cat-file>
- git-hash-object：<https://git-scm.com/docs/git-hash-object>
- hash-function-transition（SHA-1 から SHA-256 への移行計画）：<https://git-scm.com/docs/hash-function-transition>
- Git の BreakingChanges（Git 3.0 で予定されている変更）：<https://git-scm.com/docs/BreakingChanges>

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
