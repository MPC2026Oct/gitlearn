# 14日目：完成・リリース・ふりかえり

[← 13日目](day13-final-project.md) ｜ [README（全体の地図）](../README.md)

## この日のゴール

- 最後の PR をマージして、ガイドブックを完成させる
- 完成版の `main` に `v1.0` のタグと Release を作れる
- KPT でふりかえりができる
- これから Git と GitHub をどう学び続けるかがわかる

## 所要時間の目安

合計 **60〜90分**（**チーム全員で集まる日** です。オンライン通話＋画面共有でかまいません）

| セクション | 目安 |
|---|---|
| 1. 仕上げ：最後の PR をマージする | 10〜20分 |
| 2. 完成版にタグを付けて Release を作る | 15分 |
| 3. ふりかえり（KPT） | 25〜35分 |
| 4. 2週間でできるようになったこと | 5分 |
| 5. これから先へ | 5〜10分 |

> [!TIP]
> 今日の進行役は **B**（3人チームは **C**）です。進行役は、Release の作成と、ふりかえりのまとめ（`retrospective.md` の PR）を担当します。

## 前提

- 13日目の作業を進めている（Issue のほとんどが Closed になっている）
- チームリポジトリが `~/git-practice/gitlearn-team-<チーム記号>` にクローンされている

今日の演習：[exercises/day14-retrospective/README.md](../exercises/day14-retrospective/README.md)
今日使うファイル：チームリポジトリの `exercises/team-project/retrospective.md`

---

## 1. 仕上げ：最後の PR をマージする

まず、13日目の作業をすべて終わらせます。

1. 進行役が、チームリポジトリの **Pull requests** タブを開き、まだ開いている PR を読み上げます。
2. 各 PR について、レビュアーがその場で **Files changed** を確認して **Approve** し、作者がマージします（**Delete branch** も押します）。
3. コンフリクトが出た PR は、作者が12日目の方法（手元で `git merge origin/main`、または **Resolve conflicts**）で解決します。
4. **Issues** タブで、13日目の Issue がすべて **Closed** になっていることを確認します。開いたままの Issue があれば、残りの作業を片付けるか、PR の `Closes #` 忘れなら手動で **Close issue** を押します。
5. 全員で、GitHub 上の `exercises/team-project/README.md`（表紙）を開き、目次から全ページへたどれること、表示が崩れていないことを確かめます。

全員が手元の `main` を最新にします。

**Git Bash で**

`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
cd ~/git-practice/gitlearn-team-<チーム記号>
```

```bash
git switch main
```

```bash
git pull
```

```bash
git status
```

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

**VS Code で**：ステータスバーのブランチ名から `main` を選び、ソース管理ビューの「…」→「プル（Pull）」を選びます。

手元に残っている作業ブランチがあれば、`git branch` で確認して削除しておきます（[レシピ branch-04](../recipes/branch.md#branch-04)）。

---

## 2. 完成版にタグを付けて Release を作る

### タグとは

**タグ**（tag）は、特定のコミットに付ける **名前の付いた目印** です。

- ブランチは、コミットするたびに先へ進む「付箋」でした（6日目）。
- タグは、**一度付けたら動かない「記念のしおり」** です。

ソフトウェアの世界では、「このコミットがバージョン 1.0 です」のように、**完成した版や公開した版** にタグを付けます。名前は `v1.0`、`v1.1`、`v2.0` のように、`v` ＋バージョン番号にするのが一般的です。

**Release**（リリース）は、GitHub の機能で、タグに **タイトルと説明（リリースノート）** を付けて、リポジトリのページから見つけやすくしたものです。タグは Git の機能、Release は GitHub の機能、と覚えておきましょう。

今日は、完成したガイドブックの `main` に、`v1.0` のタグと Release を付けます。

### GitHub で Release を作る

**進行役** が、画面を共有しながら行います（ほかの人は見ながら、手順を確認してください）。

1. チームリポジトリのトップページ（**Code** タブ）を開きます。
2. ファイル一覧の右側にある **Releases** を押します（執筆時点の表示です）。まだ Release が1つもないときは、**Create a new release** というリンクが表示されることがあります。その場合はそれを押して、手順4に進みます。
3. **Draft a new release** を押します。
4. **Choose a tag**（またはタグの選択欄）を押し、`v1.0` と入力して、**Create new tag: v1.0 on publish** のような表示を選びます（「公開するときに新しいタグを作る」という意味です）。
5. **Target**（タグを付ける対象）が **main** になっていることを確認します。
6. **Release title** に、タイトルを入力します。例：

   ```text
   v1.0 サークル紹介ガイドブック 完成版
   ```

7. **Describe this release**（説明欄）に、内容を書きます。**Generate release notes** を押すと、`v1.0` までにマージされた PR の一覧が自動で入ります。その上に、ひとこと書き足しましょう。例：

   ```text
   2週間の Git/GitHub 勉強会で、チーム全員で作ったサークル紹介ガイドブックの完成版です。
   表紙：exercises/team-project/README.md
   ```

8. **Set as latest release**（最新の Release にする）にチェックが入っていることを確認します（**This is a pre-release** にはチェックを入れません）。
9. **Publish release** を押します。

Release のページに `v1.0` が表示されれば完成です。リポジトリのトップページの右側の **Releases** にも `v1.0` が表示されます。Release のページには **Source code (zip)** のリンクもあり、その時点のファイル一式をダウンロードできます。

> [!NOTE]
> 書きかけで止めたいときは **Save draft**（下書きを保存）を押せます。下書きのうちは、タグはまだ作られません。

出典：[GitHub Docs「Managing releases in a repository」](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)、[レシピ github-11](../recipes/github.md#github-11)

### 手元でタグを確かめる

GitHub 上で作ったタグは、手元に取り込むまで見えません。**全員で** 次の手順を行います。

**Git Bash で**

1. `main` に切り替えます。

   ```bash
   git switch main
   ```

2. 最新にします。

   ```bash
   git pull
   ```

3. タグを取ってきます（`git pull` で取り込まれている場合もありますが、念のため実行します）。

   ```bash
   git fetch --tags
   ```

   ```text
   From https://github.com/<運営者のアカウント>/gitlearn-team-a
    * [new tag]         v1.0       -> v1.0
   ```

   （`git pull` のときにすでにタグを取り込んでいた場合は、何も表示されません）

4. タグの一覧を表示します。

   ```bash
   git tag
   ```

   ```text
   v1.0
   ```

5. 履歴のどこにタグが付いたかを見ます。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   *   4f7c2d9 (HEAD -> main, tag: v1.0, origin/main, origin/HEAD) Merge pull request #38 from zen/back-links
   ...
   ```

   （ハッシュ値や番号、名前は人によって違います）

   `tag: v1.0` が、最新の `main` のコミットに付いていることがわかります。

**VS Code で**：タグの取り込みと一覧の表示は、ターミナルで行います（VS Code の「プル」でもタグは取り込まれますが、一覧を見るにはターミナルが手軽です）。

> [!TIP]
> タグは動かない目印なので、この後 `main` にコミットが増えても、`v1.0` は今日のコミットを指したままです。将来「完成版はどうだったっけ？」と思ったら、GitHub の Release ページの **Source code (zip)** や、タグの一覧から、いつでも `v1.0` の状態を見られます。

---

## 3. ふりかえり（KPT）

2週間の活動を、チームでふりかえります。今回は **KPT**（ケプト）という方法を使います。

| 項目 | 意味 | 例 |
|---|---|---|
| **K**eep（続けたいこと） | うまくいった、これからも続けたいこと | 「作業前に `git pull` する習慣がついた」 |
| **P**roblem（困ったこと・課題） | うまくいかなかった、困ったこと | 「レビュー依頼に気づくのが遅れた」 |
| **T**ry（次に試したいこと） | Problem を解決するため、Keep をもっと良くするために、次に試すこと | 「通知をスマホで受け取るようにする」 |

> [!NOTE]
> Problem は「誰が悪い」ではなく、「何が・なぜ困ったか」を書きます。11日目のレビューと同じく、**人ではなく、ことがら** を見ましょう。

### 自分のふりかえりを書く

1. 進行役が、「ふりかえり」Issue を作ります（タイトル例：「2週間のふりかえり（KPT）」、本文に KPT の説明と「各自コメントで書いてください」と書く）。
2. 全員が、その Issue に **コメント** で自分の KPT を書きます。書式の例です。

   ```markdown
   ### Keep
   - コンフリクトが起きても、マーカーを読めば落ち着いて直せるようになった
   - PR の説明に「確認したこと」を書くようにした

   ### Problem
   - 自分の PR がマージされた後、手元の main を更新し忘れることがあった

   ### Try
   - ブランチを作る前に `git switch main` → `git pull` を声に出して確認する
   ```

3. **Comment** を押して投稿します。
4. 全員の書き込みがそろったら、ほかの人のコメントを読み、共感したものに 👍（リアクション）を付けます。
5. 通話で、1人2〜3分ずつ、自分の KPT を紹介します。

### チームのまとめを書く

進行役が、全員のコメントをまとめて `exercises/team-project/retrospective.md` に書き、**PR で** 更新します。最後まで、いつもの流れで行いましょう。

**Git Bash で（進行役）**

`<...>` の部分は、かっこごと置き換えてから実行します。

1. `main` を最新にします。

   ```bash
   git switch main
   ```

   ```bash
   git pull
   ```

2. ブランチを作ります。

   ```bash
   git switch -c <GitHubユーザー名>/retrospective
   ```

3. VS Code で `exercises/team-project/retrospective.md` を開き、Keep / Problem / Try の見出しの下に、チームの意見をまとめて書きます。似た意見はまとめ、Try は「次にチームで何かするとき」に使える形にします。個人情報は書きません。
4. ステージしてコミットします。

   ```bash
   git add exercises/team-project/retrospective.md
   ```

   ```bash
   git commit -m "チームのふりかえりをまとめる"
   ```

5. push します。

   ```bash
   git push -u origin <GitHubユーザー名>/retrospective
   ```

6. GitHub で PR を作り、本文に「ふりかえり」Issue の番号を `Closes #<Issue番号>` で書きます。レビュアーにはいつもの組の相手を指定します。
7. レビュアーが内容を確認して **Approve** し、進行役がマージして **Delete branch** を押します。
8. 全員が手元を最新にします。

   ```bash
   git switch main
   ```

   ```bash
   git pull
   ```

**VS Code で**：ステータスバーで `main` に切り替え →「…」→「プル」→「+ 新しいブランチの作成」→ 編集・保存 → ソース管理ビューで「+」→「✓ コミット」→「ブランチの発行（Publish Branch）」。

> [!NOTE]
> この PR は `v1.0` の後のコミットになるので、`v1.0` の Release には含まれません。「ガイドブック本体が `v1.0`、その後にふりかえりを追記した」という履歴になります。`git log --oneline --graph --all` で、`tag: v1.0` より上に新しいコミットが増えたことを確かめてみましょう。

---

## 4. 2週間でできるようになったこと

最後に、2週間をふりかえるチェックリストです。できるものにチェックを入れてみましょう。あいまいなものがあれば、その日の説明ページやレシピ集を見直してください。

**セットアップ編**
- [ ] Git for Windows をインストールし、VS Code のターミナルで Git Bash を使える（[1日目](day01-install-git.md)）
- [ ] 2FA 付きの GitHubアカウントで、HTTPS（Git Credential Manager）の認証を通せる（[2日目](day02-github-account.md)）

**ひとりで練習編**
- [ ] `git status` → `git add` → `git commit` → `git log` で変更を記録できる（[3日目](day03-first-commit.md)）
- [ ] `git diff` で差分を確かめ、`.gitignore` で管理したくないファイルを除外できる（[4日目](day04-diff-log-ignore.md)）
- [ ] 「どこにある変更を戻したいか」で、`restore`・`commit --amend`・`revert`・`reset` を使い分けられる（[5日目](day05-undo.md)）
- [ ] ブランチを作って切り替え、マージして、削除できる（[6日目](day06-branch.md)）
- [ ] コンフリクトマーカーを読み、VS Code で解決できる（[7日目](day07-merge-conflict.md)）
- [ ] `push`・`pull`・`fetch`・`clone` の違いを説明でき、push が拒否されても対処できる（[8日目](day08-remote-github.md)）

**チーム開発編**
- [ ] Issue を作り、担当者とラベルを付けて、コメントでやりとりできる（[9日目](day09-team-kickoff.md)）
- [ ] Issue → ブランチ → PR → レビュー → マージ → 後片付け の流れを1人で回せる（[10日目](day10-pull-request.md)）
- [ ] 行コメントや修正提案でレビューし、指摘に対応して PR を更新できる（[11日目](day11-code-review.md)）
- [ ] PR のコンフリクトを、手元でも GitHub 上でも解決できる（[12日目](day12-team-conflict.md)）
- [ ] 作業を Issue に分けて、チームで並行して PR を回せる（[13日目](day13-final-project.md)）
- [ ] タグと Release を作り、KPT でふりかえりができる（今日）

おつかれさまでした！ 2週間前には「コミット」という言葉も知らなかったかもしれませんが、今はチームで1つの成果物を作り上げられるようになっています。

---

## 5. これから先へ

### 自分のレポートや作品で Git を使う

いちばんの練習は、**ふだんの作業で使い続けること** です。

- レポート、卒業研究のメモ、プログラミングの課題、小説やイラストの設定資料など、テキストで書くものなら何でも Git で管理できます。
- `~/git-practice` の外（例：`~/projects/report-2026`）に新しいフォルダを作り、3日目と同じように `git init` から始めます。OneDrive と同期されているフォルダは避けてください（[レシピ setup-07](../recipes/setup.md#setup-07)）。
- GitHub に Private リポジトリを作って push しておけば、パソコンが壊れても安心です（[レシピ remote-02](../recipes/remote.md#remote-02)）。

> [!CAUTION]
> パスワード、トークン、個人情報の入ったファイルは、Public のリポジトリに push しないでください。一度 push すると、削除しても履歴に残ります。心配なファイルは `.gitignore` で除外しましょう（4日目）。

### Appendix とレシピ集の使い方

- **困ったとき** は [レシピ集](../recipes/README.md)。「〜したいときは？」やエラーメッセージの英語の原文から探せます。
- **しくみを知りたくなったとき** は [Appendix](../appendix/README.md)。Git の内部構造、認証のしくみ、rebase など、本編で省略したことを詳しく解説しています。どのページを何日目の後に読むとよいかは、Appendix の目次に書いてあります。
- この教材は、2日目に作った自分用のコピー（`~/git-practice/gitlearn`）にずっと残っています。必要なときに見返してください。最新版は、運営者のテンプレートリポジトリ（`https://github.com/<運営者のアカウント>/gitlearn`）で確認できます。

### 次の一歩

興味があるものから試してみましょう。

| やってみたいこと | キーワード | 参考 |
|---|---|---|
| パスワードなしで安全に GitHub とやりとりしたい | **SSH 鍵** | [Appendix：認証のしくみ](../appendix/authentication.md)、[GitHub Docs「Connecting to GitHub with SSH」](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) |
| Markdown や HTML をウェブサイトとして公開したい | **GitHub Pages** | [GitHub Docs「GitHub Pages」](https://docs.github.com/en/pages) |
| push したら自動でチェックや処理を動かしたい | **GitHub Actions** | [GitHub Docs「GitHub Actions」](https://docs.github.com/en/actions) |
| ほかの人のプロジェクトに貢献したい | **フォーク**、オープンソース | [Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)、[レシピ github-03](../recipes/github.md#github-03) |
| 履歴をきれいに整えたい | **rebase**、対話的 rebase | [Appendix：rebase](../appendix/rebase.md) |
| もっと体系的に学びたい | **Pro Git**（無料の公式の本、日本語版あり） | [Pro Git（日本語）](https://git-scm.com/book/ja/v2) |

---

## 確認チェックリスト

- [ ] 13日目の Issue がすべて Closed になり、表紙から全ページへたどれることを確認した
- [ ] チームリポジトリの **Releases** に `v1.0` が表示されている
- [ ] 手元で `git fetch --tags` → `git tag` を実行し、`v1.0` が表示された
- [ ] `git log --oneline --graph --all` で、`tag: v1.0` が付いたコミットを確認した
- [ ] 「ふりかえり」Issue に、自分の KPT をコメントした
- [ ] `exercises/team-project/retrospective.md` を更新する PR がマージされ、手元の `main` にも反映した（`git pull`）
- [ ] 「4. 2週間でできるようになったこと」のチェックリストを見直した

## よくあるつまずき

**症状：Release の作成画面で、`v1.0` を入力しても作れない**
- 原因：タグ名の入力後に、「新しいタグを作る」の選択肢（**Create new tag**）を選んでいません。
- 対処：タグ名を入力した後、下に出る **Create new tag: v1.0 on publish** を押してから、残りを入力します。

**症状：`v1.0` を間違ったコミットに付けてしまった（最後の PR をマージする前に作った、など）**
- 原因：Release を作るのが早すぎました。
- 対処：
  1. Release ページで該当の Release を開き、**Delete**（ゴミ箱のアイコン）で Release を削除します。**Release を削除しても、タグ `v1.0` は GitHub に残ります。**
  2. GitHub のタグは、チームリポジトリのフォルダで次のコマンドを実行して消します（リポジトリへの書き込み権限があれば実行できます）。

     ```bash
     git push origin --delete v1.0
     ```

     （画面の **Tags** タブにタグを削除するメニューがあれば、そこから消してもかまいません。）
  3. 手元に取り込んでいた場合は、手元のタグも消します。

     ```bash
     git tag -d v1.0
     ```

  4. 正しい状態で Release を作り直してから、`git fetch --tags` します。詳しくは [レシピ github-11](../recipes/github.md#github-11) を見てください。

**症状：`git tag` を実行しても何も表示されない**
- 原因：タグをまだ手元に取り込んでいません。または、別のリポジトリ（`my-profile` など）のフォルダにいます。
- 対処：`pwd` で `gitlearn-team-<チーム記号>` にいるか確かめ、`git fetch --tags` を実行します。

**症状：`git pull` が `! [rejected]` や `would clobber existing tag` で失敗する**
- 原因：手元に同じ名前で別のコミットを指すタグがあります（自分で `git tag v1.0` を試した、など）。
- 対処：`git tag -d v1.0` で手元のタグを消してから、`git fetch --tags` をやり直します。

**症状：`retrospective.md` の PR を出したら、コンフリクトした**
- 原因：ほかの人が同じファイルを編集する PR をマージしました。
- 対処：12日目の方法で解決します（[レシピ branch-08](../recipes/branch.md#branch-08)、[レシピ github-09](../recipes/github.md#github-09)）。

## もっと知りたい人へ

- [Appendix の目次](../appendix/README.md)：すべての解説ページの一覧と、読むとよいタイミング
- [Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)：Release とタグ、GitHub Pages・Actions の紹介
- レシピ
  - [github-11 タグを付けて Release を作りたい](../recipes/github.md#github-11)
  - [branch-04 ブランチを削除したい（手元・GitHub・追跡ブランチ）](../recipes/branch.md#branch-04)

---
[← 13日目](day13-final-project.md) ｜ [README](../README.md)
