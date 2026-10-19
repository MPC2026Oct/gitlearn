# 11日目：コードレビュー

[← 10日目](day10-pull-request.md) ｜ [README（全体の地図）](../README.md) ｜ [12日目 →](day12-team-conflict.md)

## この日のゴール

- 行コメントと修正提案（Suggested changes）を使って、PR をレビューできる
- 承認（Approve）・Request changes・Comment の3種類を使い分けられる
- レビューの指摘に対応して PR を更新し、再レビューを依頼できる

## 所要時間の目安

合計 **約60分**（各自のペースで進めてよい日です。レビューの依頼と返事は PR のコメントで行います）

| セクション                                  | 目安 |
| ------------------------------------------- | ---- |
| 1. レビューの目的と心がけ                   | 5分  |
| 2. 担当ページを書いて PR を出す             | 20分 |
| 3. レビューする                             | 15分 |
| 4. レビューに対応する                       | 10分 |
| 5. マージする                               | 5分  |
| 6. 他の人のブランチを手元で確かめる（任意） | 5分  |

> [!TIP]
> レビューは「相手の PR が出てから」しかできません。自分の PR を出したら、組の相手の PR が出るまでの間に、レビューの観点（[review-checklist.md](../exercises/day11-review/review-checklist.md)）を読んでおきましょう。

## 前提

- 10日目を終えている（自分のメンバー紹介ページの PR をマージし、手元の `main` を最新にした）
- チームリポジトリが `~/git-practice/gitlearn-team-<チーム記号>` にクローンされている
- 自分の **役割記号（A〜D）** と **レビューの組**（自分の PR を誰がレビューするか）がわかっている（[9日目](day09-team-kickoff.md)）

今日の演習：[exercises/day11-review/README.md](../exercises/day11-review/README.md)

---

## 1. レビューの目的と心がけ

**レビュー**（review）とは、PR で提案された変更を、マージする前にほかの人が読んで確かめることです。10日目は「Approve を押してマージする」流れだけを体験しました。今日は、**中身をきちんと読んで、意見を伝え合う** ところまで進みます。

レビューの目的は、次の3つです。

1. **間違いを早めに見つける**：誤字、リンク切れ、表示の崩れ、個人情報の書き忘れなど
2. **よりよくする**：わかりやすい言い回し、見出しの付け方など
3. **知識を共有する**：ほかの人が書いた内容を知る。「こう書けばいいのか」と学ぶ

レビューするときの心がけです。

| 心がけ                               | 例                                                                  |
| ------------------------------------ | ------------------------------------------------------------------- |
| **人ではなく、変更を見る**           | ×「書き方が雑です」 → ○「この見出しは `##` にすると目次と揃います」 |
| **具体的に書く**                     | ×「ここ変です」 → ○「『活働』は『活動』の誤字だと思います」         |
| **理由を添える**                     | 「新入生が読むので、略語は開いたほうが伝わりやすいと思います」      |
| **お願いか、ただの感想かを区別する** | 必須でない意見には「（任意）」「好みですが」と付ける                |
| **良い点も書く**                     | 「この表、すごく見やすいです！」                                    |

レビューされる側の心がけも大切です。指摘は「自分への批判」ではなく「ページをよくするための提案」です。納得できないときは、コメントで理由を聞いたり、自分の考えを返したりしてかまいません。

> [!NOTE]
> 今日のルール：**レビュアーは最低1つ、行コメントか修正提案を付けます。** 作者は指摘に対応してから、再レビューを依頼します。「問題なし」だと思っても、良い点へのコメントや、小さな提案を1つ探してみてください。

---

## 2. 担当ページを書いて PR を出す

今日は役割ごとに、ガイドブックのページを1つずつ書きます。

| 役割 | 担当ページ（チームリポジトリ内のパス）       | 内容                                    |
| ---- | -------------------------------------------- | --------------------------------------- |
| A    | `exercises/team-project/pages/activities.md` | 活動紹介                                |
| B    | `exercises/team-project/pages/events.md`     | 年間行事                                |
| C    | `exercises/team-project/pages/faq.md`        | よくある質問                            |
| D    | `exercises/team-project/pages/newcomers.md`  | 新入生へ（3人チームは13日目に作ります） |

ページには見出しと「TODO」が書かれた骨組みが入っています。サークルは架空でかまいません。**個人情報（本名のフルネーム、電話番号、住所、学籍番号、顔写真）は書きません。**

### Issue を確認する

今日の進行役（C）が、担当ページごとに「〇〇ページを書く」Issue を作り、担当者（Assignees）を付けます。自分の Issue の番号を確認しておきます（例：`#12`）。Issue の作り方は [9日目](day09-team-kickoff.md) と [レシピ github-04](../recipes/github.md#github-04) を見てください。

### main を最新にしてブランチを作る

手順は10日目と同じです。作業を始める前に、必ず `main` を最新にします（チームのルール5）。

**Git Bash で**

`<...>` の部分は、かっこごと置き換えてから実行します。

1. チームリポジトリのフォルダに移動します。

   ```bash
   cd ~/git-practice/gitlearn-team-<チーム記号>
   ```

2. `main` に切り替えます。

   ```bash
   git switch main
   ```

3. 最新にします。

   ```bash
   git pull
   ```

4. 作業用のブランチを作って切り替えます。

   ```bash
   git switch -c <GitHubユーザー名>/write-page
   ```

   ```text
   Switched to a new branch 'hydr4/write-page'
   ```

   （`hydr4` の部分は人によって違います）

**VS Code で**

1. ステータスバー左下のブランチ名をクリックし、`main` を選びます。
2. ソース管理ビューの「…」（その他の操作）→「プル（Pull）」を選びます。
3. もう一度ステータスバーのブランチ名をクリックし、「+ 新しいブランチの作成（Create new branch）」を選んで、`<GitHubユーザー名>/write-page` と入力します（例：`hydr4/write-page`）。

### ページを書いてコミットする

1. VS Code のエクスプローラーで、自分の担当ページ（例：`exercises/team-project/pages/activities.md`）を開きます。
2. 「TODO」の部分を書き換えます。目安は見出し2〜3個、合計10行程度です。
3. `Ctrl+Shift+V` でプレビューを開き、表示が崩れていないか確かめます。
4. `Ctrl+S` で保存します。
5. ステージしてコミットします。

**Git Bash で**

```bash
git add exercises/team-project/pages/
```

```bash
git commit -m "活動紹介ページを書く"
```

（コミットメッセージは自分の担当に合わせて変えてください。例：「年間行事ページを書く」）

```text
[hydr4/write-page 3f2a1c9] 活動紹介ページを書く
 1 file changed, 12 insertions(+), 4 deletions(-)
```

（ハッシュ値や数字は人によって違います）

**VS Code で**：ソース管理ビューで、変更したファイルの「+」（変更をステージ）を押し、メッセージ欄に入力して「✓ コミット（Commit）」を押します。

### push して PR を作る

1. ブランチを push します。

   **Git Bash で**

   `<...>` の部分は、かっこごと置き換えてから実行します。

   ```bash
   git push -u origin <GitHubユーザー名>/write-page
   ```

   **VS Code で**：ソース管理ビューの「ブランチの発行（Publish Branch）」を押します。

2. ブラウザでチームリポジトリを開き、表示される **Compare & pull request** ボタンを押します（執筆時点の表示です）。
3. PR テンプレートを埋めます。「関連 Issue」には、自分の Issue 番号を書きます。

   ```text
   Closes #<Issue番号>
   ```

4. 右側の **Reviewers** で、レビューの組の相手を指定します（4人：A→B、B→C、C→D、D→A／3人：A→B、B→C、C→A）。
5. **Create pull request** を押します。

PR の作り方の詳細は [10日目](day10-pull-request.md) と [レシピ github-05](../recipes/github.md#github-05) を見てください。

---

## 3. レビューする

ここからは **レビュアー（レビューする人）** としての作業です。組の相手の PR を開きます。自分がレビューを頼まれた PR は、GitHub 画面上部の **Pull requests** タブから探せます。

> [!NOTE]
> 執筆時点（2026年10月）では、GitHub の **Files changed** 画面は2026年1月から新しいデザインが標準になっています（[GitHub Changelog](https://github.blog/changelog/2026-01-22-improved-pull-request-files-changed-page-on-by-default)）。ボタンの位置や形が下の説明と少し違うことがありますが、操作の流れは同じです。

### Files changed で変更を読む

1. PR を開き、**Files changed** タブを押します。
2. 変更されたファイルが、差分（diff）の形で表示されます。緑（`+`）が追加された行、赤（`-`）が削除された行です。4日目の `git diff` と同じ見方です。
3. 差分だけでは読みにくいときは、ファイル名の右にある「…」メニューから **View file** を選ぶと、ファイル全体を表示できます。Markdown のファイルは、差分の上部にある表示切り替え（**Rich diff** / ソース表示のアイコン）で、プレビュー表示に切り替えられることがあります。
4. 読み終えたファイルは、ファイル名の右の **Viewed** にチェックを入れると、折りたたまれて「読んだ印」になります。

読むときの観点は [review-checklist.md](../exercises/day11-review/review-checklist.md) にまとめています。特に次の点を見てください。

- ページの目的（活動紹介、行事、FAQ、新入生へ）に合っているか
- 誤字・脱字、表記のゆれ
- 見出しや箇条書きが正しく表示されるか
- 個人情報が書かれていないか
- 言葉づかいが読む人（新入生）に合っているか

### 行にコメントする

特定の行について意見を書くには、**行コメント** を使います。

1. **Files changed** で、コメントしたい行の行番号にマウスを乗せます。
2. 行番号の横に出る青い **+** アイコンを押します。
   - 複数行にまとめてコメントしたいときは、最初の行の行番号をクリックし、`Shift` を押しながら最後の行の行番号をクリックしてから、**+** を押します。
3. コメント欄に意見を書きます。例：「『毎週水曜』の後に時間も書くと、新入生が来やすいと思います」
4. **Start a review**（レビューを開始）を押します。
   - 2つ目以降のコメントでは **Add review comment** を押します。

> [!WARNING]
> **Start a review** で書いたコメントは、まだ **自分にしか見えません**（Pending＝保留中の状態）。最後に「レビューを提出」するまで相手には届きません。複数のコメントをまとめて1回で届けるためのしくみです。

### 修正を提案する（Suggested changes）

「こう直したらどう？」を、**そのまま取り込める形** で伝えられるのが **修正提案（Suggested changes）** です。誤字の修正など、直し方がはっきりしているときに便利です。

1. 直してほしい行の **+** を押して、コメント欄を開きます。
2. コメント欄の上にあるツールバーから、**Add a suggestion**（ファイルに ± が付いたようなアイコン）を押します。
3. コメント欄に、次のようなブロックが入ります。中身は、今の行の内容です。

   ````markdown
   ```suggestion
   - 活働日：毎週水曜
   ```
   ````

4. ブロックの中を、直した後の内容に書き換えます。ブロックの外（前後）に、理由を書き添えてもかまいません。

   ````markdown
   「活働」→「活動」の誤字だと思います。

   ```suggestion
   - 活動日：毎週水曜
   ```
   ````

5. **Start a review**（または **Add review comment**）を押します。

> [!TIP]
> コメント欄の **Preview** タブを押すと、提案が「赤い行 → 緑の行」の差分として表示されます。意図どおりか確認してから送りましょう。

### Approve・Request changes・Comment の使い分け

コメントを書き終えたら、レビューを **提出** します。

1. 画面右上の **Review changes**（表示によっては **Submit review**）ボタンを押します。
2. 全体へのまとめのコメントを書きます。例：「読みやすいページでした！ 誤字を1か所提案しています」
3. 次の3つから1つを選びます。
4. **Submit review** を押します。

| 種類                | 意味                                     | 使う場面                                         |
| ------------------- | ---------------------------------------- | ------------------------------------------------ |
| **Comment**         | 意見だけ伝える（承認も差し戻しもしない） | 質問がある、小さな感想だけ、など                 |
| **Approve**（承認） | このままマージしてよい                   | 問題がない、または残りの指摘が「任意」だけ       |
| **Request changes** | マージする前に直してほしい               | 誤字、個人情報、表示の崩れなど、直すべき点がある |

**今日のおすすめ**：誤字などを修正提案で指摘した場合は **Request changes** を選び、作者が対応した後の再レビューで **Approve** します。こうすると「指摘 → 対応 → 再レビュー → 承認」の流れを一通り体験できます。

> [!NOTE]
> 書きかけのレビューをやめたいときは、**Review changes**（表示によっては **Submit review**）のメニューから **Abandon review** を選ぶと、保留中のコメントがすべて削除されます。

操作の詳細：[GitHub Docs「Reviewing proposed changes in a pull request」](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-proposed-changes-in-a-pull-request)、[レシピ github-07](../recipes/github.md#github-07)

---

## 4. レビューに対応する

ここからは **作者（PR を出した人）** としての作業です。レビューが届くと、GitHub の通知（右上のベルのアイコン）やメールで知らせが来ます。PR の **Conversation** タブを開くと、レビューのコメントが時系列に並んでいます。

対応のしかたは2通りあります。

- **手元で直して push する**：直し方を自分で考える指摘や、複数の箇所にまたがる修正のとき
- **修正提案をそのまま取り込む（Commit suggestion）**：修正提案の内容でよいとき

どちらでも、**同じブランチにコミットが追加されれば、PR は自動で更新されます**。PR を作り直す必要はありません。

### 指摘を直して push する

**Git Bash で**

1. 自分の作業ブランチにいることを確かめます。

   ```bash
   git status
   ```

   ```text
   On branch hydr4/write-page
   Your branch is up to date with 'origin/hydr4/write-page'.

   nothing to commit, working tree clean
   ```

   （1行目のブランチ名が `<GitHubユーザー名>/write-page` になっていれば OK です。違うときは `git switch <GitHubユーザー名>/write-page` で切り替えます）

2. VS Code でファイルを開き、指摘された箇所を直して保存します。
3. ステージします。

   ```bash
   git add exercises/team-project/pages/
   ```

4. コミットします。

   ```bash
   git commit -m "レビューの指摘を反映"
   ```

5. push します（このブランチを最初に push したとき（上の手順）に `-u` を付けたので、2回目以降は `git push` だけで送れます）。

   ```bash
   git push
   ```

**VS Code で**：ファイルを直して保存 → ソース管理ビューで「+」→ メッセージを入力して「✓ コミット」→「変更の同期（Sync Changes）」を押します。

PR の **Commits** タブを見ると、コミットが増えていることを確認できます。**Files changed** にも新しい内容が反映されます。

> [!TIP]
> 直した指摘のコメントには、「直しました！」と返信しておくと、レビュアーが確認しやすくなります。対応が終わった会話は、コメントの下の **Resolve conversation** を押すと折りたためます。

### 提案をそのまま取り込む（Commit suggestion）

修正提案（Suggested changes）は、GitHub 上でボタンを押すだけで取り込めます。

1. PR の **Conversation** タブ（または **Files changed** タブ）で、修正提案のコメントを探します。
2. 提案の下にある **Commit suggestion** を押します。
   - 提案が複数あるときは、それぞれ **Add suggestion to batch** を押してから、最後に **Commit suggestions** を押すと、1つのコミットにまとめられます。
3. コミットメッセージの欄に、短いメッセージを入力します（例：「誤字を修正」）。最初から英語のメッセージが入っていることもあり、そのままでもかまいません。
4. **Commit changes** を押します。

> [!WARNING]
> **Commit suggestion を使うと、GitHub 上のブランチにだけ新しいコミットが追加されます。** 手元のブランチは古いままです。続けて手元で作業する前に、必ず `git pull` で取り込んでください。
>
> ```bash
> git pull
> ```
>
> これを忘れて手元でコミットし、`git push` すると `! [rejected]` で拒否されます（8日目で体験したのと同じ状況です）。そのときも `git pull` してから `git push` し直せば解決します（[レシピ trouble-04](../recipes/troubleshooting.md#trouble-04)）。

出典：[GitHub Docs「Incorporating feedback in your pull request」](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/incorporating-feedback-in-your-pull-request)

### 再レビューを依頼する（Re-request review）

指摘への対応が終わったら、レビュアーにもう一度見てもらいます。

1. PR の **Conversation** タブを開きます。
2. 右側のサイドバーの **Reviewers** に、レビュアーの名前が表示されています。
3. 名前の右にある、矢印が回転したような **Re-request review**（再リクエスト）のアイコンを押します。
4. 念のため、コメント欄に「指摘を反映しました。再レビューをお願いします！」と書いて **Comment** を押しておくと親切です。

レビュアーは、もう一度 **Files changed** を開いて確認します。**Viewed** にチェックしたファイルでも、変更があればチェックが外れて「Changed since last view」のように表示されるので、どこが変わったかわかります。問題がなければ、今度は **Approve** を選んで提出します。

出典：[GitHub Docs「Requesting a pull request review」](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/requesting-a-pull-request-review)、[レシピ github-08](../recipes/github.md#github-08)

---

## 5. マージする

承認（Approve）されたら、**作者が** マージします（チームのルール3）。手順は10日目と同じです。

1. PR の **Conversation** タブの下のほうで、**Merge pull request** を押します（ボタンの右の ▼ で「Create a merge commit」が選ばれていることを確認します）。
2. **Confirm merge** を押します。
3. **Delete branch** を押して、GitHub 上のブランチを削除します。
4. 手元を後片付けします。

**Git Bash で**

`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
git switch main
```

```bash
git pull
```

```bash
git branch -d <GitHubユーザー名>/write-page
```

```text
Deleted branch hydr4/write-page (was 8c4e2b1).
```

**VS Code で**：ステータスバーのブランチ名から `main` に切り替え →「変更の同期」（または「…」→「プル」）→ コマンドパレット（`Ctrl+Shift+P`）で「Git: ブランチの削除（Git: Delete Branch）」を選び、`<GitHubユーザー名>/write-page` を選びます。

5. Issue が自動で閉じた（Closed になった）ことを確認します。

チーム全員の PR がマージされたら、`exercises/team-project/pages/` の担当ページがそろいます。GitHub 上でそれぞれのページを開き、表示を確かめてみましょう。

---

## 6. 他の人のブランチを手元で確かめる（任意）

GitHub の画面だけでは確認しにくいとき（VS Code のプレビューで見たい、など）は、相手のブランチを手元に持ってきて確かめられます。レビュアーとして、相手の PR がまだマージされていない間に試してください。

1. まず、自分の作業をコミットしておきます（`git status` で `nothing to commit, working tree clean` と出る状態にします）。
2. GitHub の最新の情報を取ってきます。

   ```bash
   git fetch
   ```

   ```text
   From https://github.com/<運営者のアカウント>/gitlearn-team-a
    * [new branch]      hanako/write-page -> origin/hanako/write-page
   ```

3. 相手のブランチに切り替えます。ブランチ名は、PR の画面のタイトルの下（`wants to merge 1 commit into main from hanako/write-page` の部分）に書かれています。下の例の `hanako/write-page` を、**PR に書かれた相手のブランチ名に置き換えて** 実行してください。

   ```bash
   git switch hanako/write-page
   ```

   ```text
   Switched to a new branch 'hanako/write-page'
   branch 'hanako/write-page' set up to track 'origin/hanako/write-page'.
   ```

   `origin/hanako/write-page` と同じ名前のブランチが自動で作られ、切り替わります。

4. VS Code でファイルを開き、`Ctrl+Shift+V` でプレビューを確かめます。
5. 確認が終わったら、自分のブランチ（または `main`）に戻ります。

   ```bash
   git switch main
   ```

> [!WARNING]
> 相手のブランチで勝手にコミットして push しないでください。意見は PR のレビューで伝えます。

**VS Code で**：ソース管理ビューの「…」→「フェッチ（Fetch）」を押してから、ステータスバーのブランチ名をクリックし、一覧から `origin/hanako/write-page` のようなリモートのブランチを選ぶと、同じことができます。

詳しくは [レシピ remote-07](../recipes/remote.md#remote-07) を見てください。

---

## 確認チェックリスト

- [ ] 自分の担当ページを書き、`<GitHubユーザー名>/write-page` ブランチから PR を出した（PR 本文に `Closes #<Issue番号>` がある）
- [ ] 組の相手の PR に、行コメントか修正提案を **最低1つ** 付けてレビューを提出した
- [ ] Approve・Request changes・Comment の違いを説明できる
- [ ] 自分の PR への指摘に対応し（手元で直して push、または Commit suggestion）、PR の **Commits** タブでコミットが増えたことを確認した
- [ ] Re-request review で再レビューを依頼した
- [ ] 承認（Approve）された自分の PR をマージし、GitHub 上と手元のブランチを削除した
- [ ] `git switch main` → `git pull` の後、`git log --oneline --graph --all` で自分の PR のマージコミットが見える

## よくあるつまずき

**症状：コメントを書いたのに、相手に「何も届いていない」と言われる**
- 原因：**Start a review** で書いたコメントは、レビューを提出するまで保留中（Pending）です。
- 対処：**Review changes**（表示によっては **Submit review**）を押して、種類を選んで提出します。

**症状：修正提案のボタン（Add a suggestion）が見つからない**
- 原因：修正提案は、**Files changed** の行コメントでしか使えません。**Conversation** タブの一番下のコメント欄には出ません。
- 対処：**Files changed** で行番号の **+** を押してから、ツールバーを探します。ツールバーの記号が見つからない場合は、上の例のように ```` ```suggestion ```` で始まるブロックを手で書いても同じです。

**症状：Commit suggestion を押した後、`git push` が `! [rejected]` で拒否された**
- 原因：GitHub 上のブランチに提案のコミットが増えたのに、手元に取り込んでいません。
- 対処：`git pull` してから `git push` し直します。→ [レシピ trouble-04](../recipes/troubleshooting.md#trouble-04)

**症状：`git pull` すると `Need to specify how to reconcile divergent branches` と出る**
- 原因：1日目の `pull.rebase` の設定が入っていません。
- 対処：→ [レシピ trouble-08](../recipes/troubleshooting.md#trouble-08)

**症状：Re-request review のアイコンが出ない**
- 原因：まだ相手がレビューを提出していない、または **Reviewers** に相手が指定されていません。
- 対処：**Reviewers** の歯車（または **Reviewers** の文字）を押して相手を指定します。指定済みでアイコンがなければ、コメントで「再レビューお願いします」と書けば十分です。

**症状：push したのに PR に反映されない**
- 原因：別のブランチ（`main` など）でコミットした可能性があります。
- 対処：`git status` で今いるブランチを確認します。`main` でコミットしてしまった場合は [レシピ branch-07](../recipes/branch.md#branch-07) を見てください。

## もっと知りたい人へ

- [Appendix：よいコミットとレビューしやすい PR](../appendix/commit-best-practices.md)：PR の大きさの目安、コミットメッセージの書き方
- [Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)：権限、マージ方法の違い、Issue と PR の自動リンク
- レシピ
  - [github-07 PR をレビューしたい（行コメント・修正提案・承認）](../recipes/github.md#github-07)
  - [github-08 レビューの指摘を反映して PR を更新したい](../recipes/github.md#github-08)
  - [remote-07 他の人のブランチ（PR）を手元で確かめたい](../recipes/remote.md#remote-07)

---
[← 10日目](day10-pull-request.md) ｜ [README](../README.md) ｜ [12日目 →](day12-team-conflict.md)
