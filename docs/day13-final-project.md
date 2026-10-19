# 13日目：最終課題に取り組む

[← 12日目](day12-team-conflict.md) ｜ [README（全体の地図）](../README.md) ｜ [14日目 →](day14-release-retrospective.md)

## この日のゴール

- 最終課題を Issue に分けて、担当を決められる
- 「1 Issue = 1 ブランチ = 1 PR」で、チームで並行して作業できる
- 作業中のブランチに `main` の最新を取り込める
- （発展）rebase が何をするか説明できる

## 所要時間の目安

合計 **約90分**（各自のペースで進めてよい日です。14日目の集まりまでに、すべての Issue を閉じることを目指します）

| セクション | 目安 |
|---|---|
| 1. 最終課題「サークル紹介ガイドブック」 | 10分 |
| 2. タスクを Issue に分ける | 15分 |
| 3. 並行して作業する | 30分 |
| 4. レビューとマージを回す | 20分 |
| 5. 進み具合を確かめる | 5分 |
| 6. 発展（任意）：rebase 入門 | 10〜20分（別枠） |

> [!TIP]
> 今日の進行役は **A**（3人チームは **B**）です。進行役は Issue を作り、担当を決め、終わりに全体の進み具合を確認します。

## 前提

- 9〜12日目を終えている（Issue、PR、レビュー、PR のコンフリクト解決）
- 11日目の担当ページ（`pages/` の各ページ）と12日目の練習の PR がすべてマージされている
- チームリポジトリが `~/git-practice/gitlearn-team-<チーム記号>` にクローンされている

今日の演習：[exercises/day13-final-project/README.md](../exercises/day13-final-project/README.md)（最終課題の仕様と Issue の一覧）
発展の演習：[exercises/day13-final-project/rebase-optional.md](../exercises/day13-final-project/rebase-optional.md)

---

## 1. 最終課題「サークル紹介ガイドブック」

10日目から少しずつ作ってきた `exercises/team-project/` を、**新入生が読める1冊のガイドブック** として完成させます。

### 完成イメージ

GitHub でチームリポジトリの `exercises/team-project/README.md`（表紙）を開くと、目次から全ページへリンクでたどれ、各ページの末尾から目次へ戻れる状態です。

```text
exercises/team-project/
├── README.md              表紙と目次  ← 今日、目次を完成させる
├── schedule.md            次回の活動予定  ← 今日、確定版にする
├── retrospective.md       ふりかえり（14日目に使う）
├── members/
│   ├── README.md          メンバー一覧  ← 今日、完成させる
│   ├── _template.md       ひな形（そのまま残す）
│   └── <GitHubユーザー名>.md   10日目に各自が作った紹介ページ
└── pages/
    ├── activities.md      活動紹介（11日目・A）
    ├── events.md          年間行事（11日目・B）
    ├── faq.md             よくある質問（11日目・C）
    ├── newcomers.md       新入生へ（11日目・D／3人チームは今日）
    └── git-glossary.md    チームで作る Git 用語集  ← 今日、全員で書く
```

### 完成条件

- 今日作る Issue が **すべて Close** されている
- 表紙（`exercises/team-project/README.md`）から、**すべてのページへリンクでたどれる**
- GitHub 上で `main` の各ページを開いたとき、**表示が崩れていない**（見出し、箇条書き、リンク）

---

## 2. タスクを Issue に分ける

大きな作業は、そのままだと「誰が・何を・いつまでに」がはっきりしません。**1人が1つの PR で終えられる大きさ** に分けて、それぞれを Issue にします。

### 作業の一覧

[exercises/day13-final-project/README.md](../exercises/day13-final-project/README.md) にある作業の一覧です。

| # | 作業 | 編集するファイル（`exercises/team-project/` から） | 注意 |
|---|---|---|---|
| 1 | 表紙の目次を完成させ、全ページへリンクする | `README.md` | |
| 2 | メンバー一覧に、全員の紹介ページへのリンクを載せる | `members/README.md` | |
| 3 | 新入生へのページを完成させる | `pages/newcomers.md` | **3人チームのみ**（4人チームは D が11日目に作成済み） |
| 4 | Git 用語集に、各自が3語ずつ用語を追加する | `pages/git-glossary.md` | **全員が同じファイルを編集** → コンフリクトが起きうる（12日目の復習） |
| 5 | 各ページの末尾に「[目次へ戻る](../README.md)」リンクを付ける | `pages/*.md`、`schedule.md` | 担当を決めて **1人で** 行う。**ほかの作業が終わってから** 始める。`schedule.md` は表紙と同じフォルダなので `[目次へ戻る](README.md)` にする。`members/README.md` には最初から付いている（済み） |
| 6 | 活動予定を確定版に整える（12日目に残した複数の案から1つに決める） | `schedule.md` | どの案にするかは、Issue のコメントでチームで決める |

> [!NOTE]
> 作業5のリンク `[目次へ戻る](../README.md)` は、`pages/` や `members/` から見て「1つ上のフォルダの `README.md`」＝表紙を指す相対パスです。

### 進行役が Issue を作る

進行役は、上の作業ごとに Issue を作ります（「作業タスク」テンプレートを使います）。作業4は **1人1つ** の Issue にします（例：「用語集に3語追加（hanako）」）。こうすると「1 Issue = 1 ブランチ = 1 PR」がそろいます。

1. チームリポジトリの **Issues** タブ → **New issue** を押します。
2. テンプレートの一覧から「作業タスク」を選びます（画面によっては、その横の **Get started** を押します。執筆時点の表示です）。
3. タイトルと「やること」「完了条件」を書きます。例：

   ```text
   タイトル：表紙の目次を完成させる

   やること：exercises/team-project/README.md の目次の TODO を、各ページへのリンクに置き換える
   完了条件：表紙から pages/ の全ページと members/README.md へリンクでたどれる
   ```

4. 右側の **Assignees** で担当者を、**Labels** で `documentation` を付けます。
5. **Create**（画面によっては **Submit new issue**）を押します。

詳しくは [レシピ github-04](../recipes/github.md#github-04) を見てください。

### 担当を決める

担当の決め方の例です。チームで相談して変えてかまいません。

| 4人チームの例 | 担当する Issue |
|---|---|
| A | 1（表紙の目次）、4（用語集） |
| B | 2（メンバー一覧）、4（用語集） |
| C | 6（活動予定の確定）、4（用語集） |
| D | 5（目次へ戻るリンク、最後に行う）、4（用語集） |

| 3人チームの例 | 担当する Issue |
|---|---|
| A | 1（表紙の目次）、5（目次へ戻るリンク、最後に行う）、4（用語集） |
| B | 2（メンバー一覧）、6（活動予定の確定）、4（用語集） |
| C | 3（新入生へのページ）、4（用語集） |

担当が決まったら、全員が自分の Issue に「担当します！」とコメントしておきます。

---

## 3. 並行して作業する

### 1 Issue = 1 ブランチ = 1 PR

複数の Issue を担当していても、**1つの Issue ごとに、ブランチと PR を分けます**。

- レビューする人が、何の変更かすぐわかる
- 1つの PR に問題があっても、ほかの PR のマージを止めずにすむ
- PR が小さいので、コンフリクトも起きにくい（12日目の習慣）

ブランチ名は `<GitHubユーザー名>/<内容>` です。例：

| Issue | ブランチ名の例 |
|---|---|
| 1 表紙の目次 | `hanako/toc` |
| 2 メンバー一覧 | `taro/members-list` |
| 3 新入生へ | `yuki/newcomers` |
| 4 用語集 | `hanako/glossary` |
| 5 目次へ戻るリンク | `zen/back-links` |
| 6 活動予定 | `yuki/schedule` |

（例の名前は A＝hanako、B＝taro、C＝yuki、D＝zen です。3 は3人チームの C、5・6 は4人チームの D・C の例です）

### 作業の手順（1つの Issue ぶん）

ここでは、用語集（Issue 4）を例にします。ほかの Issue でも、ファイル名とブランチ名が違うだけで、手順は同じです。

**Git Bash で**

`<...>` の部分は、かっこごと置き換えてから実行します。

1. チームリポジトリに移動します。

   ```bash
   cd ~/git-practice/gitlearn-team-<チーム記号>
   ```

2. `main` に切り替えます。

   ```bash
   git switch main
   ```

3. 最新にします（**作業前に必ず**）。

   ```bash
   git pull
   ```

4. Issue 用のブランチを作ります。

   ```bash
   git switch -c <GitHubユーザー名>/glossary
   ```

5. VS Code で `exercises/team-project/pages/git-glossary.md` を開き、用語を3つ追加して保存します。用語は2週間で学んだもの（コミット、ブランチ、プルリクエストなど）から選び、**自分の言葉で** 1〜2行の説明を書きます。

   ```markdown
   - **コミット**：変更を記録したセーブポイント。メッセージで「何をしたか」を残す。
   ```

6. `Ctrl+Shift+V` でプレビューを確かめます。
7. ステージしてコミットします。

   ```bash
   git add exercises/team-project/pages/git-glossary.md
   ```

   ```bash
   git commit -m "用語集に3語を追加"
   ```

8. push します。

   ```bash
   git push -u origin <GitHubユーザー名>/glossary
   ```

9. GitHub で PR を作ります。本文に `Closes #<Issue番号>` を書き、レビューの組の相手をレビュアーに指定します（[レシピ github-05](../recipes/github.md#github-05)）。

**VS Code で**：ステータスバーで `main` に切り替え →「…」→「プル」→ ステータスバー「+ 新しいブランチの作成」→ 編集・保存 → ソース管理ビューで「+」→「✓ コミット」→「ブランチの発行（Publish Branch）」。

2つ目の Issue に取りかかるときは、**手順2の `git switch main` からやり直します**。1つ目のブランチの上で2つ目の作業を始めないように注意してください。

> [!TIP]
> 1〜2行だけの小さな修正なら、GitHub の画面上でファイルを直接編集して、そのまま新しいブランチと PR を作ることもできます（[レシピ github-12](../recipes/github.md#github-12)）。その場合も、`main` に直接コミットせず「Create a new branch for this commit and start a pull request」を選んでください（チームのルール1）。

> [!WARNING]
> 個人情報（本名のフルネーム、電話番号、住所、学籍番号、顔写真）は書かないでください（チームのルール6）。

---

## 4. レビューとマージを回す

### いつもの組でレビューする

レビューの組は10日目からと同じです（4人：A→B、B→C、C→D、D→A／3人：A→B、B→C、C→A）。11日目のように、行コメントや修正提案を使ってレビューし、作者が対応したら Approve、**作者が** マージします。

今日は PR がたくさん出るので、次のことを心がけてください。

- レビューを頼まれたら、**なるべく早く** 見る（放置すると、ほかの PR とコンフリクトしやすくなります）
- 承認（Approve）されたら、**すぐマージ** して、ブランチを削除する
- マージしたら、手元は `git switch main` → `git pull` → `git branch -d <ブランチ名>`

### こまめに main を取り込む

作業中に、ほかの人の PR が先にマージされることがあります。特に用語集（`git-glossary.md`）は全員が編集するので、同じ見出しの下に追記するとコンフリクトが起きます。そのときは12日目のラウンド1と同じ手順で、`main` の最新を自分のブランチに取り込みます。

**Git Bash で**

`<...>` の部分は、かっこごと置き換えてから実行します。

1. 自分の作業ブランチにいることを確かめます（例：用語集のブランチ）。

   ```bash
   git switch <GitHubユーザー名>/glossary
   ```

2. 最新の情報を取ってきます。

   ```bash
   git fetch origin
   ```

3. `main` の最新をマージします。

   ```bash
   git merge origin/main
   ```

   - コンフリクトがなければ、マージコミットのメッセージが VS Code で開くので、そのままタブを閉じます（または `Already up to date.` と出れば、取り込むものはありません）。
   - コンフリクトしたら、VS Code で解決します。用語集なら、たいてい「**両方の変更を取り込む（Accept Both Changes）**」で、全員の用語を残せば OK です。解決したら次の2つを実行します。

     ```bash
     git add exercises/team-project/pages/git-glossary.md
     ```

     ```bash
     git commit -m "main の最新を取り込み、用語集のコンフリクトを解決"
     ```

4. push します。

   ```bash
   git push
   ```

PR 画面にコンフリクトが表示された場合は、12日目のラウンド2のように **Resolve conflicts** ボタンで解決してもかまいません。

**VS Code で**：「…」→「フェッチ」→ コマンドパレット「Git: ブランチをマージ…（Git: Merge Branch...）」→ `origin/main` を選ぶ → 解決 → 「+」→「✓ コミット」→「変更の同期」。

詳しくは [レシピ branch-08](../recipes/branch.md#branch-08) を見てください。

> [!NOTE]
> Issue 5（目次へ戻るリンク）は複数のページを編集するので、**ほかの PR がすべてマージされてから** 始めると、コンフリクトを避けられます。これも「事前に声をかける」「担当ファイルを分ける」という12日目の習慣の応用です。

---

## 5. 進み具合を確かめる

### Issue の一覧で確かめる

1. チームリポジトリの **Issues** タブを開きます。
2. 一覧の上の **Open** と **Closed** の数を見ます。PR がマージされると、`Closes #番号` で紐づけた Issue が自動で Closed に移ります。
3. 検索欄に `is:issue is:open assignee:@me` と入力すると、**自分が担当していて、まだ終わっていない Issue** だけを表示できます。

**Pull requests** タブでは、レビュー待ちの PR を確認できます。検索欄に `is:pr is:open review-requested:@me` と入力すると、**自分がレビューを頼まれている PR** だけが表示されます。

### 履歴で確かめる

手元の `main` を最新にしてから、履歴を見ます。

```bash
git switch main
```

```bash
git pull
```

```bash
git log --oneline --graph --all
```

```text
*   9d1e4a7 (HEAD -> main, origin/main, origin/HEAD) Merge pull request #31 from hanako/glossary
|\
| * 5b0c2e8 用語集に3語を追加
|/
*   e7a3f10 Merge pull request #30 from taro/members-list
|\
| * 3c8d9b1 メンバー一覧にリンクを追加
|/
...
```

（ハッシュ値や番号、名前は人によって違います）

`Merge pull request #...` のコミットが並び、たくさんの線が合流しているのがわかります。これが「チームで並行して作業した」記録です。

### 完成条件を確かめる

全 Issue が閉じたら、進行役が中心になって、GitHub 上で完成条件を確かめます。

1. チームリポジトリで `exercises/team-project/README.md` を開きます。
2. 目次のリンクを1つずつクリックして、すべてのページが開くか確かめます。
3. 各ページの末尾の「目次へ戻る」で、表紙に戻れるか確かめます。
4. 表示が崩れているところがあれば、新しい Issue を作って直します。

---

## 6. 発展（任意）：rebase 入門

> [!NOTE]
> この節は **任意** です。チームの作業が終わって時間がある人や、もっと知りたい人向けです。**チームリポジトリではなく、自分の `my-profile` で試します。**

### rebase とは

ここまで、`main` の最新を自分のブランチに取り込むときは **merge** を使ってきました。merge は「2本の線を合流させるコミット（マージコミット）」を作ります。

**rebase**（リベース）は、別の取り込み方です。自分のブランチのコミットを、**いったん取り外して、`main` の最新の先に付け直します**。

```text
rebase 前：                          rebase 後（git rebase main）：

      A---B  try-rebase                          A'--B'  try-rebase
     /                                          /
D---E---F  main                      D---E---F  main
```

- merge：線が合流した履歴になる。元のコミットはそのまま残る
- rebase：**一直線の履歴** になる。付け直したコミット（`A'`、`B'`）は、**中身は同じでも、別のハッシュ値の新しいコミット** になる

### 自分のリポジトリで試す

詳しい課題（コンフリクトなし版と、ありの版）は [rebase-optional.md](../exercises/day13-final-project/rebase-optional.md) にあります。ここでは、流れだけを試します。

1. `my-profile` に移動します。

   ```bash
   cd ~/git-practice/my-profile
   ```

2. `main` にいて、作業中の変更がないことを確かめます。

   ```bash
   git switch main
   ```

   ```bash
   git status
   ```

3. 練習用のブランチを作り、ファイルを1つ追加してコミットします。

   ```bash
   git switch -c try-rebase
   ```

   ```bash
   echo "ブランチで書いたメモ" > memo-branch.txt
   ```

   ```bash
   git add memo-branch.txt
   ```

   ```bash
   git commit -m "ブランチでメモを追加"
   ```

   `git add` のときに `warning: in the working copy of 'memo-branch.txt', LF will be replaced by CRLF ...` という警告が出ても問題ありません（[trouble-11](../recipes/troubleshooting.md#trouble-11)）。

4. `main` に戻って、別のファイルを追加してコミットします（これで両方のブランチが進みます）。

   ```bash
   git switch main
   ```

   ```bash
   echo "main で書いたメモ" > memo-main.txt
   ```

   ```bash
   git add memo-main.txt
   ```

   ```bash
   git commit -m "main でメモを追加"
   ```

5. 履歴を見ます。線が2本に分かれています。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   * eccd091 (HEAD -> main) main でメモを追加
   | * 04d3e06 (try-rebase) ブランチでメモを追加
   |/
   * 6eadf76 （それまでのコミット）
   ```

6. `try-rebase` に切り替えて、`main` の上に付け直します。

   ```bash
   git switch try-rebase
   ```

   ```bash
   git rebase main
   ```

   ```text
   Successfully rebased and updated refs/heads/try-rebase.
   ```

7. もう一度履歴を見ます。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   * 709b4c0 (HEAD -> try-rebase) ブランチでメモを追加
   * eccd091 (main) main でメモを追加
   * 6eadf76 （それまでのコミット）
   ```

   一直線になりました。「ブランチでメモを追加」のハッシュ値が、`04d3e06` から `709b4c0` に **変わっている** ことに注目してください（ハッシュ値は人によって違います）。

8. `main` に取り込みます。一直線なので fast-forward マージ（6日目）になります。

   ```bash
   git switch main
   ```

   ```bash
   git merge try-rebase
   ```

   ```text
   Updating eccd091..709b4c0
   Fast-forward
    memo-branch.txt | 1 +
    1 file changed, 1 insertion(+)
    create mode 100644 memo-branch.txt
   ```

9. 練習用ブランチを削除します。

   ```bash
   git branch -d try-rebase
   ```

10. （任意）GitHub の `my-profile` にも反映するなら `git push` します。

rebase の途中でコンフリクトしたときは、解決して `git add` した後に `git rebase --continue`、やめたいときは `git rebase --abort` を使います。`git rebase --continue` を実行すると、VS Code にコミットメッセージ（`COMMIT_EDITMSG`）のタブが開き、ターミナルは `hint: Waiting for your editor to close the file...` と表示して止まります（1日目に `core.editor` を `code --wait` に設定したためです）。固まったわけではありません。内容を確かめてタブを閉じると、rebase が続きます。詳しくは [rebase-optional.md](../exercises/day13-final-project/rebase-optional.md) と [Appendix：rebase](../appendix/rebase.md) を見てください。

### 共有しているブランチでは使わない

rebase はコミットを **作り直す** 操作です。すでに push して、ほかの人も使っているブランチを rebase すると、

- GitHub 上の履歴と手元の履歴が食い違い、普通の `git push` が拒否される
- 無理に上書きする（`--force`）と、ほかの人の手元の履歴と合わなくなり、混乱や作業の消失につながる

ということが起きます。そのため、次の原則を守ってください。

> [!CAUTION]
> **push して共有したブランチ（特に `main`）は rebase しない。** この勉強会のチームリポジトリでは、`main` の取り込みには merge（12日目の方法）を使ってください。rebase は、まだ push していない自分だけのブランチで使うものです。

---

## 確認チェックリスト

- [ ] 進行役が作業の Issue を作り、全員に担当が付いている
- [ ] 自分が担当した Issue ごとに、別々のブランチ（`<GitHubユーザー名>/<内容>`）と PR を作った
- [ ] 用語集（`pages/git-glossary.md`）に、自分の用語を3つ追加する PR をマージした
- [ ] 作業前に `git switch main` → `git pull` で最新にしてから、ブランチを作った
- [ ] 必要なときに `git fetch origin` → `git merge origin/main` で、作業中のブランチに `main` の最新を取り込めた（コンフリクトが起きなかった人は、手順を説明できれば OK）
- [ ] **Issues** タブで、今日の Issue がすべて Closed になっている
- [ ] 表紙（`exercises/team-project/README.md`）から、すべてのページへリンクでたどれる
- [ ] （発展）`my-profile` で `git rebase main` を試し、履歴が一直線になることと、ハッシュ値が変わることを確かめた

## よくあるつまずき

**症状：2つ目の Issue の PR に、1つ目の Issue の変更まで入っている**
- 原因：1つ目の作業ブランチにいるまま、`git switch -c` で2つ目のブランチを作りました。
- 対処：2つ目の PR をマージする前なら、1つ目の PR を先にマージすれば、2つ目の PR の差分は自分の変更だけに見えるようになります。今後は、ブランチを作る前に必ず `git switch main` → `git pull` してください。

**症状：`git merge origin/main` の後、見慣れない画面（Vim）が開いた**
- 原因：エディタの設定が VS Code になっていません。
- 対処：→ [レシピ trouble-10](../recipes/troubleshooting.md#trouble-10)

**症状：用語集の PR がコンフリクトした**
- 原因：ほかの人が先に、同じ場所に用語を追加してマージしました（想定どおりです）。
- 対処：12日目と同じく、`git fetch origin` → `git merge origin/main` → 両方を残して解決 → `git add` → `git commit` → `git push`。または PR 画面の **Resolve conflicts** で解決します。→ [レシピ branch-08](../recipes/branch.md#branch-08)

**症状：PR をマージしたのに Issue が閉じない**
- 原因：PR の本文に `Closes #<Issue番号>` が書かれていない、または番号が違います。
- 対処：Issue を開き、手動で **Close issue** を押します。次からは PR 本文を確認してください。→ [レシピ github-06](../recipes/github.md#github-06)

**症状：リンクをクリックすると「404」になる**
- 原因：相対パスやファイル名が間違っています（大文字小文字の違い、`../` の数など）。
- 対処：VS Code のプレビュー（`Ctrl+Shift+V`）でリンクをクリックして開けるか確かめます（エディター上では `Ctrl`＋クリック）。開けなければパスを直して、新しいコミットとして push します。

**症状：（発展）`git rebase main` の途中で止まった**
- 原因：rebase 中にコンフリクトが起きました。
- 対処：解決して `git add` → `git rebase --continue`（VS Code にコミットメッセージのタブが開いたら、閉じると続きます）。やめたいときは `git rebase --abort` で rebase 前に戻れます。→ [Appendix：rebase](../appendix/rebase.md)

## もっと知りたい人へ

- [Appendix：rebase](../appendix/rebase.md)：merge との比較、`git pull --rebase`、対話的 rebase の紹介
- [Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)：PR のマージ方法3種、Issue と PR の自動リンク
- レシピ
  - [branch-08 作業中のブランチに main の最新を取り込みたい](../recipes/branch.md#branch-08)
  - [github-04 Issue を作って、担当者とラベルを付けたい](../recipes/github.md#github-04)
  - [github-05 プルリクエストを作りたい](../recipes/github.md#github-05)
  - [github-12 GitHub 上でファイルを直接編集したい](../recipes/github.md#github-12)

---
[← 12日目](day12-team-conflict.md) ｜ [README](../README.md) ｜ [14日目 →](day14-release-retrospective.md)
