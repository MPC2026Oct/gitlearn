# ブランチとマージのしくみ

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[6日目「ブランチ」](../docs/day06-branch.md)、[7日目「マージとコンフリクト」](../docs/day07-merge-conflict.md) を読んだ人（[12日目](../docs/day12-team-conflict.md) の後に読み返すのもおすすめです）
>
> **読む時間の目安**：約30分（手を動かして試す場合は +20分）

6日目では「ブランチは付箋のようなもの」、7日目では「両方が進んだらマージコミットができる」と学びました。このページでは、そのたとえの中身を実際のファイルとコマンドで確かめ、**マージがどう決まり、コンフリクトがいつ起きるのか** を説明します。

## このページでわかること

- ブランチと HEAD の正体（コミットを指す小さなファイル）
- detached HEAD（デタッチド・ヘッド）とは何か、困ったときの戻り方
- マージベース（共通の祖先）と、fast-forward マージ・3-way マージの違い
- `--no-ff` と `--ff-only` の意味、GitHub のプルリクエスト（Pull Request、略して PR）がいつもマージコミットを作る理由
- コンフリクトが起きる条件・起きない条件
- `merge.conflictStyle=zdiff3` と VS Code のマージエディター
- GitHub 上の **Resolve conflicts** が裏で何をしているか

---

<a id="lab-setup"></a>

## 1. 実験用のリポジトリを用意する

このページの実験は、専用のリポジトリで行います。

1. Git Bash で次のコマンドを実行します。1行目の `printf` は、7行の「部室のルール」を書いたファイルを作ります。

```bash
mkdir -p ~/git-practice/appendix-lab/merge
cd ~/git-practice/appendix-lab/merge
git init
printf '# 部室の使い方\n\n- 開室: 平日 12:00〜18:00\n- 鍵: 事務室で借りる\n- 掃除: 金曜日\n- 飲食: 可\n- 備品: 棚の中\n' > rules.md
git add rules.md
git commit -m "部室のルールを追加"
```

> [!TIP]
> `git add` などで `LF will be replaced by CRLF` という警告が出ることがありますが、無視してかまいません（`printf` や `echo` で作ったファイルは改行コードが LF になるため。[改行コードと文字コード](line-endings-and-encoding.md#lf-will-be-replaced)、[レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)）。

2. 中身を確かめます。

```bash
cat rules.md
```

```text
# 部室の使い方

- 開室: 平日 12:00〜18:00
- 鍵: 事務室で借りる
- 掃除: 金曜日
- 飲食: 可
- 備品: 棚の中
```

作り直したいときは、エクスプローラーで `C:\Users\<Windowsのユーザー名>\git-practice\appendix-lab\merge` フォルダを削除してから、もう一度実行してください。

---

<a id="branch-pointer"></a>

## 2. ブランチの正体：コミットを指す名札

### ブランチはファイル1つ

Git の中では、ブランチは **「あるコミットのハッシュ値を書いただけの小さなファイル」** です（オブジェクトのしくみは [Appendix：Git の内部のしくみ](git-internals.md)）。

1. `main` が指しているコミットを2通りの方法で表示します。

```bash
git rev-parse main
cat .git/refs/heads/main
```

```text
5a962a9e7417e40e7d79be4b9d8508a22c31d107
5a962a9e7417e40e7d79be4b9d8508a22c31d107
```

（ハッシュ値は人によって違います）

`git rev-parse` は「名前をハッシュ値に変換する」コマンドです。`.git/refs/heads/main` というファイルの中身と同じ値が出ます。

> [!NOTE]
> ブランチが増えたり、Git が自動で整理（`git gc`）したりすると、ブランチの情報が `.git/packed-refs` という1つのファイルにまとめられ、`.git/refs/heads/main` が見当たらないことがあります。そのときも `git rev-parse main` なら確実に調べられます。

### だからブランチは「軽い」

ブランチを作ることは「名札ファイルを1つ増やす」だけなので、ファイルの数や大きさに関係なく一瞬で終わります。ファイルのコピーは作られません。気軽にブランチを作ってよい理由がここにあります。

```text
                 main
                  ↓
  A ── B ── C ── D
                  ↑
             add-favorites      ← 作った直後は同じコミットを指している
```

### ブランチ名の `/` はフォルダになる

チーム開発編では `<GitHubユーザー名>/<内容>` という名前を使います。`hydr4/add-member-page` というブランチは、Git の中では `.git/refs/heads/hydr4/add-member-page` という **フォルダの中のファイル** として扱われます。そのため、`hydr4` というブランチと `hydr4/add-member-page` というブランチは同時に作れません。

```bash
git branch hydr4
git branch hydr4/add-page
```

```text
fatal: cannot lock ref 'refs/heads/hydr4/add-page': 'refs/heads/hydr4' exists; cannot create 'refs/heads/hydr4/add-page'
```

確かめたら、作った `hydr4` ブランチは消しておきます。

```bash
git branch -d hydr4
```

---

<a id="head"></a>

## 3. HEAD の正体

HEAD は「今いる場所」を表す名札で、これも `.git/HEAD` というファイルです。

```bash
cat .git/HEAD
```

```text
ref: refs/heads/main
```

`ref:` で始まっているのは、「HEAD は `main` というブランチを指している」という意味です。名札が2段になっているのがポイントです。

```text
HEAD ──→ main ──→ D（コミット）
```

- **コミットすると**：新しいコミット E が作られ、HEAD がたどっている先の `main` が E に進みます。HEAD は `main` を指したままなので、一緒に進んだように見えます。
- **`git switch add-favorites` すると**：`.git/HEAD` の中身が `ref: refs/heads/add-favorites` に書き換わり、ワーキングツリーがそのブランチのコミットの内容になります。

---

<a id="detached-head"></a>

## 4. detached HEAD（ブランチから外れた状態）

### どういう状態か

HEAD がブランチではなく、**コミットを直接指している** 状態を detached HEAD（デタッチド・ヘッド：切り離された HEAD）と呼びます。

```text
ふつうの状態：        HEAD ──→ main ──→ D

detached HEAD：       HEAD ──→ B（コミット）     main ──→ D
```

次のようなときにこの状態になります。

- 過去のコミットを見に行ったとき（`git switch --detach <コミット>`、昔の書き方では `git checkout <コミット>`）
- タグ（`v1.0` など）に切り替えたとき
- rebase の途中（[Appendix：rebase](rebase.md)）

### 体験する

1. 今のコミットのまま、ブランチから外れてみます（`--detach` は「ブランチではなくコミットに直接移る」オプションです。過去のコミットを見に行くときは `HEAD` の部分にハッシュ値などを書きます）。

```bash
git switch --detach HEAD
git status
```

```text
HEAD detached at 5a962a9
```

`cat .git/HEAD` を実行すると、`ref: refs/heads/main` ではなくハッシュ値そのものが書かれていることも確かめられます。

VS Code では、左下のステータスバーにブランチ名ではなくハッシュ値が表示されます。

2. `main` に戻ります。

```bash
git switch main
```

### この状態でコミットするとどうなるか

detached HEAD のままでもコミットはできますが、そのコミットを指す **ブランチがありません**。別のブランチに切り替えると、どこからもたどれなくなり、Git は次のように警告します。

```text
Warning: you are leaving 1 commit behind, not connected to
any of your branches:

  a39dd08 試しのコミット

If you want to keep it by creating a new branch, this may be a good time
to do so with:

 git branch <new-branch-name> a39dd08
```

助けたいときは、**detached HEAD のうちに** `git switch -c rescue` でブランチを作るか、切り替えてしまった後なら警告に表示されたハッシュ値でブランチを作ります（例：`git branch rescue a39dd08`。`a39dd08` は自分の画面に表示された値に置き換えます）。警告を見逃しても、[reflog](undo-in-depth.md#reflog) から探せます。

---

<a id="merge-base"></a>

## 5. マージベース：2つのブランチの「分かれ目」

マージを理解するカギは **マージベース**（merge base：2つのブランチの共通の祖先のうち、いちばん新しいコミット）です。

```text
            E ── F   ← feature
           /
  A ── B ── C ── D   ← main

  マージベース = C
```

Git はマージするとき、次の3つを比べます。

| 比べるもの                       | 例  |
| -------------------------------- | --- |
| マージベース（分かれる前の状態） | C   |
| 自分のブランチの先端（HEAD）     | D   |
| 取り込むブランチの先端           | F   |

`git merge-base` コマンドでマージベースを調べられます。次の節の実験の中で使います。

---

<a id="fast-forward"></a>

## 6. fast-forward マージと 3-way マージ

### fast-forward（早送り）マージ

`main` が分かれた後に何も進んでいなければ、マージベースは `main` の先端そのものです。この場合、Git は新しいコミットを作らず、**`main` の名札を先へ進めるだけ** で済ませます。これが fast-forward（早送り）です。

```text
マージ前：  A ── B   ← main
                  \
                   C   ← add-contact

マージ後：  A ── B ── C   ← main, add-contact     （名札が進んだだけ）
```

1. 実験用リポジトリで試します。

```bash
git switch -c add-contact
echo "- 連絡先: サークルのチャット" >> rules.md
git commit -am "連絡先を追加"
git switch main
git merge add-contact
```

```text
Updating 5a962a9..e4a868f
Fast-forward
 rules.md | 1 +
 1 file changed, 1 insertion(+)
```

2. グラフで確かめます。枝分かれのない1本の線になっています。

```bash
git log --oneline --graph --all
```

```text
* e4a868f (HEAD -> main, add-contact) 連絡先を追加
* 5a962a9 部室のルールを追加
```

<a id="no-ff"></a>

### `--no-ff`：あえてマージコミットを作る

fast-forward できる場合でも、`--no-ff` を付けると必ずマージコミットを作ります。「このコミットたちは1つのブランチでまとめて作業したものだ」という区切りが履歴に残ります。

1. もう1つブランチを作って、`--no-ff` でマージします。`--no-edit` はマージコミットのメッセージを既定のまま使うオプションです（付けないと、メッセージを編集するために VS Code が開きます）。

```bash
git switch -c add-trash
echo "- ゴミ: 持ち帰る" >> rules.md
git commit -am "ゴミのルールを追加"
git switch main
git merge --no-ff --no-edit add-trash
git log --oneline --graph --all
```

```text
*   aa8c365 (HEAD -> main) Merge branch 'add-trash'
|\
| * e38b5ca (add-trash) ゴミのルールを追加
|/
* e4a868f (add-contact) 連絡先を追加
* 5a962a9 部室のルールを追加
```

| オプション           | fast-forward できるとき | できないとき                   |
| -------------------- | ----------------------- | ------------------------------ |
| なし（`--ff`、既定） | fast-forward する       | マージコミットを作る           |
| `--no-ff`            | マージコミットを作る    | マージコミットを作る           |
| `--ff-only`          | fast-forward する       | **マージせずにエラーで止まる** |

（出典：[git-merge](https://git-scm.com/docs/git-merge) の `--ff` / `--no-ff` / `--ff-only`）

> [!NOTE]
> GitHub の PR を **Create a merge commit** でマージすると、fast-forward できる場合でも必ずマージコミットが作られます（`--no-ff` と同じ）。10日目以降の `main` の履歴に「Merge pull request #12 from ...」というコミットが並ぶのはこのためです。マージ方法の違いは [Appendix：GitHub でのチーム開発](github-collaboration.md#merge-methods) で説明しています。

### 3-way マージ

両方のブランチが進んでいると、名札を進めるだけでは片方の変更が失われます。そこで Git は、**マージベース・自分・相手の3つ** を比べて、新しいマージコミットを作ります。これが 3-way（スリーウェイ）マージです。

```text
マージ前：           F   ← fix-key
                    /
  … ── M ─────── G   ← main

マージ後：           F
                    /  \
  … ── M ─────── G ── H   ← main    （H はマージコミット。親が G と F の2つ）
```

3つを比べるのは、「どちらが変えたのか」を判断するためです。

| 行   | マージベース   | main           | fix-key        | 結果                                      |
| ---- | -------------- | -------------- | -------------- | ----------------------------------------- |
| 鍵   | 事務室で借りる | 事務室で借りる | 部長が管理する | fix-key だけが変えた → **部長が管理する** |
| 飲食 | 可             | 片付ければ可   | 可             | main だけが変えた → **片付ければ可**      |
| 掃除 | 金曜日         | 金曜日         | 金曜日         | 誰も変えていない → **金曜日**             |

もしマージベースがなく、2つのファイルだけを比べると、「鍵」の行は「どちらが正しいのか」わかりません。共通の祖先があるからこそ、片方だけが変えた行を自動で取り込めるのです。

1. 実験します。`fix-key` ブランチで「鍵」の行を、`main` で「飲食」の行を変えます。`sed -i 's/前/後/' ファイル` は「ファイルの中の文字列を置き換える」コマンドです。

```bash
git switch -c fix-key
sed -i 's/事務室で借りる/部長が管理する/' rules.md
git commit -am "鍵の管理者を変更"
git switch main
sed -i 's/飲食: 可/飲食: 片付ければ可/' rules.md
git commit -am "飲食のルールを変更"
```

2. マージベースを調べます。

```bash
git log --oneline -1 $(git merge-base main fix-key)
```

```text
aa8c365 Merge branch 'add-trash'
```

両方のブランチが分かれる直前のコミットが表示されました。

3. マージします。

```bash
git merge --no-edit fix-key
git log --oneline --graph --all
```

```text
Auto-merging rules.md
Merge made by the 'ort' strategy.
 rules.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

```text
*   2c19bbc (HEAD -> main) Merge branch 'fix-key'
|\
| * b77e455 (fix-key) 鍵の管理者を変更
* | d788bd6 飲食のルールを変更
|/
*   aa8c365 Merge branch 'add-trash'
...
```

4. `cat rules.md` で、「鍵」と「飲食」の両方の変更が入っていることを確かめてください。

`'ort' strategy` は、Git 2.34 から既定になったマージのしくみ（アルゴリズム）の名前です。結果を読むうえでは気にしなくてかまいません。

---

<a id="conflict-conditions"></a>

## 7. コンフリクトが起きる条件・起きない条件

### 起きる・起きないの一覧

| 状況                                                     | コンフリクトするか                                 |
| -------------------------------------------------------- | -------------------------------------------------- |
| 別々のファイルを変更した                                 | しない                                             |
| 同じファイルの、離れた行を変更した                       | しない（上の 3-way マージの実験）                  |
| 同じファイルの **同じ行** を、両方が違う内容に変更した   | **する**                                           |
| 同じファイルの **隣り合った行** を、それぞれが変更した   | **する**（意外な落とし穴）                         |
| 同じ位置に、両方が別々の行を追加した                     | **する**（7日目の「持ち物」）                      |
| 両方が同じ行を **まったく同じ内容** に変更した           | しない                                             |
| 片方がファイルを削除し、もう片方が同じファイルを変更した | **する**（modify/delete）                          |
| 両方が同じ名前の新しいファイルを、違う内容で作った       | **する**（add/add）                                |
| 画像などのバイナリファイルを両方が変更した               | **する**（中身を混ぜられないので、どちらかを選ぶ） |

Git は「変更された行のかたまり」が重なるか、**接している** かで判断します。間に変更されていない行が1行以上あれば、別々の変更として自動で取り込めます。

### 実験：隣り合った行でもコンフリクトする

1. `change-clean` ブランチで「掃除」の行を、`main` で1行上の「鍵」の行を変えます。

```bash
git switch -c change-clean
sed -i 's/金曜日/水曜日/' rules.md
git commit -am "掃除の日を変更"
git switch main
sed -i 's/部長が管理する/副部長が管理する/' rules.md
git commit -am "鍵の管理者を副部長に変更"
git merge change-clean
```

```text
Auto-merging rules.md
CONFLICT (content): Merge conflict in rules.md
Automatic merge failed; fix conflicts and then commit the result.
```

2. 中身を見ると、2行がまとめて1つのコンフリクトになっています。

```bash
cat rules.md
```

```text
# 部室の使い方

- 開室: 平日 12:00〜18:00
<<<<<<< HEAD
- 鍵: 副部長が管理する
- 掃除: 金曜日
=======
- 鍵: 部長が管理する
- 掃除: 水曜日
>>>>>>> change-clean
- 飲食: 片付ければ可
...
```

違う行を変えたのにコンフリクトするのは、Git が「この2行のかたまりは、どちらの版が正しいのか」を判断できないからです。正解は「両方の変更を生かす」（鍵は副部長、掃除は水曜日）ですが、それを決めるのは人間です。

3. 次の節で表示のしかたを変えて見比べるので、いったんマージを中止します。

```bash
git merge --abort
```

### 「コンフリクトしない」は「正しい」ではない

コンフリクトしなかったからといって、結果が正しいとは限りません。たとえば、ある人が見出し「## 活動内容」を「## 活動紹介」に変え、別の人が別のファイルにその見出しへのリンクを追加した場合、Git は何も言わずにマージしますが、リンクは切れてしまいます。マージ後に **プレビューで表示を確かめる** 習慣が大切なのはこのためです（11日目のレビュー観点にもつながります）。

---

<a id="zdiff3"></a>

## 8. `merge.conflictStyle=zdiff3`：元の内容も表示する

### 標準のマーカーで足りない情報

標準のコンフリクトマーカーは「自分（HEAD）」と「相手」の2つしか表示しません。そのため、**どちらが何を変えたのか**（元は何だったのか）がわかりにくいことがあります。

`merge.conflictStyle` を `zdiff3` にすると、`|||||||` と `=======` の間に **マージベース（元の内容）** も表示されます。

1. このリポジトリだけで設定を変えて、もう一度マージします。

```bash
git config merge.conflictStyle zdiff3
git merge change-clean
cat rules.md
```

（先頭の2行は省略しています）

```text
- 開室: 平日 12:00〜18:00
<<<<<<< HEAD
- 鍵: 副部長が管理する
- 掃除: 金曜日
||||||| 2c19bbc
- 鍵: 部長が管理する
- 掃除: 金曜日
=======
- 鍵: 部長が管理する
- 掃除: 水曜日
>>>>>>> change-clean
```

2. 3つを比べると、次のことが一目でわかります。

   - HEAD（main）側は「鍵」を **部長 → 副部長** に変えた（掃除は元のまま）
   - change-clean 側は「掃除」を **金曜日 → 水曜日** に変えた（鍵は元のまま）
   - だから正解は「鍵: 副部長が管理する」「掃除: 水曜日」

3. 確かめたら中止します。

```bash
git merge --abort
```

### すべてのリポジトリで使うには

`zdiff3` は Git 2.35 で追加された形式で、`diff3` という古くからある形式の改良版です（両側で同じになった行をコンフリクトの外に出し、表示を短くします。出典：[git-merge](https://git-scm.com/docs/git-merge) の「HOW CONFLICTS ARE PRESENTED」、[Highlights from Git 2.35](https://github.blog/open-source/git/highlights-from-git-2-35/)）。気に入ったら、次のコマンドで全リポジトリの既定にできます。

```bash
git config --global merge.conflictStyle zdiff3
```

設定の階層（`--global` とリポジトリごとの設定の違い）は [Appendix：Git の設定](git-config.md) を見てください。この実験用リポジトリに入れた設定は、次のコマンドで消せます。

```bash
git config --unset merge.conflictStyle
```

---

<a id="merge-editor"></a>

## 9. VS Code のマージエディター

### インライン表示とマージエディター

コンフリクトしたファイルを VS Code で開くと、まずはマーカーの上に「現在の変更を取り込む（Accept Current Change）」などのボタンが並ぶ **インライン表示** になります（7日目で使ったもの）。より複雑なコンフリクトでは、**マージエディター**（3-way merge editor）が便利です。

- 開き方：コンフリクトしたファイルを開いたときに右下に出る **マージ エディターで解決**（Resolve in Merge Editor）ボタン、またはソース管理ビューの「変更のマージ（Merge Changes）」にあるファイルを右クリックして **マージ エディターで解決** を選ぶ（執筆時点の表示です）
- 画面の構成（出典：[VS Code Docs: Resolve merge conflicts](https://code.visualstudio.com/docs/sourcecontrol/merge-conflicts)）

```text
┌──────────────────────┬──────────────────────┐
│ Incoming（受信中）    │ Current              │
│ 取り込もうとしている   │ 今いるブランチ（HEAD）│
│ ブランチの内容         │ の内容                │
├──────────────────────┴──────────────────────┤
│ Result（結果）                               │
│ 最終的にファイルに書き込まれる内容（直接編集できる）│
└─────────────────────────────────────────────┘
```

- 欄の見出しは、日本語表示では左が「受信中」（Incoming）、下が「結果」（Result）です。右の Current の日本語表示はバージョンによって違うことがあります（執筆時点）。
- 上の2つの欄で、取り込みたい側のチェックボックスを付けると、下の Result に反映されます。両方にチェックを付けると両方が入ります。Result は直接編集もできます。
- 最後に **マージの完了**（Complete Merge）を選ぶと、そのファイルがステージされます。ファイルごとの操作なので、すべてのファイルを解決した後で、ソース管理ビューからコミット（または `git commit`）してマージを完了させます。

### Current と Incoming の意味

| ラベル                   | マーカー          | merge のとき                   | rebase のとき               |
| ------------------------ | ----------------- | ------------------------------ | --------------------------- |
| Current（現在の変更）    | `<<<<<<< HEAD` 側 | 今いるブランチ（自分の変更）   | **取り込み先（main など）** |
| Incoming（入力側の変更） | `>>>>>>> ...` 側  | 取り込むブランチ（相手の変更） | **自分のコミット**          |

rebase のときは、Current と Incoming の意味が **逆に見える** ので注意してください（理由は [Appendix：rebase](rebase.md#rebase-conflict) で説明しています）。

---

<a id="abort-and-undo"></a>

## 10. マージをやめる・やり直す

| 状況                                           | 方法                                                                                                                |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| コンフリクトの途中で、マージそのものをやめたい | `git merge --abort`（マージ前の状態に戻る）                                                                         |
| マージを完了したが、push 前に取り消したい      | `git reset --hard ORIG_HEAD`（未コミットの変更がないことを確かめてから。[ORIG_HEAD](undo-in-depth.md#reset-modes)） |
| マージを push した後で取り消したい             | `git revert -m 1 <マージコミット>`（[revert](undo-in-depth.md#revert-vs-reset)）                                    |

> [!TIP]
> 解決に迷ったら、無理に進めず `git merge --abort` で戻ってかまいません。マージは何度でもやり直せます。

---

<a id="github-conflicts"></a>

## 11. GitHub の PR で起きるコンフリクト（12日目）

### PR の「コンフリクト」は何と何のぶつかり合いか

PR の画面に「This branch has conflicts that must be resolved」と表示されるのは、**PR のブランチを base ブランチ（`main`）にマージしようとするとコンフリクトする** という意味です。

```text
            X   ← hydr4/round1（PR のブランチ）
           /
  … ── M ── Y   ← main（先に別の PR がマージされて進んだ）
```

12日目のラウンド1で行った解決方法は、**逆向きに `main` を PR のブランチへマージする** ことでした。

```bash
git switch hydr4/round1
git fetch origin
git merge origin/main
```

（上の `hydr4/round1` は例です。12日目の本文では `<GitHubユーザー名>/round1` と書いています）

```text
            X ──── Z   ← hydr4/round1（Z はコンフリクトを解決したマージコミット）
           /      /
  … ── M ── Y ───    ← main
```

こうすると、PR のブランチには `main` の最新が取り込まれた状態になり、もう一度 `main` へマージするときはコンフリクトしません（解決はすでに Z に入っています）。

### Resolve conflicts ボタンがしていること

ラウンド2で使った GitHub 上の **Resolve conflicts** ボタンも、裏では同じことをしています。解決して **Commit merge** を押すと、**base ブランチ全体を PR のブランチにマージするコミット** が PR のブランチに作られます（出典：[Resolving a merge conflict on GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github)）。そのため、手元で同じブランチを使い続ける場合は `git pull` してから作業を再開します。

GitHub 上で解決できるのは「同じ行を両方が変えた」という単純なコンフリクトだけです。ファイルの削除と変更がぶつかった場合などはボタンが使えないので、手元で解決します。

### Update branch ボタン

PR の画面に **Update branch** ボタンが出ることがあります。これは「コンフリクトはしていないが、PR のブランチが `main` の最新より遅れている」ときに、`main` を PR のブランチに取り込むボタンです（出典：[Keeping your pull request in sync with the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/keeping-your-pull-request-in-sync-with-the-base-branch)）。押した後に手元で作業を続けるなら、やはり `git pull` が必要です。

merge の代わりに rebase で `main` を取り込む方法もあります。違いは [Appendix：rebase](rebase.md) を見てください。

---

## まとめ

- ブランチは「コミットのハッシュ値を書いた名札ファイル」、HEAD は「今いるブランチを指す名札」。
- HEAD がブランチではなくコミットを直接指すのが detached HEAD。コミットを残したいならブランチを作る。
- マージは「マージベース・自分・相手」の3つを比べる。相手が自分の子孫なら fast-forward、そうでなければマージコミットを作る。
- 同じ行や **隣り合った行** を両方が変えるとコンフリクトする。コンフリクトしなくても内容が正しいとは限らない。
- `zdiff3` で元の内容も表示すると、「誰が何を変えたか」がわかり、解決しやすくなる。
- PR のコンフリクト解決は、`main` を PR のブランチにマージして、解決をそのブランチに記録すること。

## 関連ページ

- 本編：[6日目 ブランチ](../docs/day06-branch.md)、[7日目 マージとコンフリクト](../docs/day07-merge-conflict.md)、[12日目 チームでのコンフリクト](../docs/day12-team-conflict.md)
- レシピ：[branch-01](../recipes/branch.md#branch-01)〜[branch-08](../recipes/branch.md#branch-08)、[github-09](../recipes/github.md#github-09)、[trouble-05](../recipes/troubleshooting.md#trouble-05)、[trouble-10](../recipes/troubleshooting.md#trouble-10)
- Appendix：[Git の内部のしくみ](git-internals.md)、[Git の設定](git-config.md)、[取り消しの詳細](undo-in-depth.md)、[リモート追跡ブランチ](remote-tracking.md)、[rebase](rebase.md)

## 参考資料（公式ドキュメント）

- [git-merge](https://git-scm.com/docs/git-merge)、[git-merge-base](https://git-scm.com/docs/git-merge-base)
- [git-branch](https://git-scm.com/docs/git-branch)、[git-switch](https://git-scm.com/docs/git-switch)
- [Pro Git（日本語版）3.1 Git のブランチ機能 - ブランチとは](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E6%A9%9F%E8%83%BD-%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E3%81%A8%E3%81%AF)
- [Pro Git（日本語版）3.2 Git のブランチ機能 - ブランチとマージの基本](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E6%A9%9F%E8%83%BD-%E3%83%96%E3%83%A9%E3%83%B3%E3%83%81%E3%81%A8%E3%83%9E%E3%83%BC%E3%82%B8%E3%81%AE%E5%9F%BA%E6%9C%AC)
- [VS Code Docs: Resolve merge conflicts](https://code.visualstudio.com/docs/sourcecontrol/merge-conflicts)
- [GitHub Docs: Resolving a merge conflict on GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github)

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
