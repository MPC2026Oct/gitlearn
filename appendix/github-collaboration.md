# GitHub でのチーム開発：権限・ブランチ保護・マージ方法・Release

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[9日目](../docs/day09-team-kickoff.md)〜[11日目](../docs/day11-code-review.md) を読んだ人（Release とタグ・次の一歩の節は [14日目](../docs/day14-release-retrospective.md) の後に）
>
> **読む時間の目安**：約35分

チーム開発編では、運営者が用意したチームリポジトリにメンバーとして招待され、ブランチ → プルリクエスト（Pull Request、略して PR） → レビュー → マージの流れを回しました。このページでは、その裏側にある GitHub のしくみ（誰が何をできるのか、`main` をどう守るのか、マージボタンの選択肢の違い、Issue（イシュー：課題やタスクを書き込むチケット） が自動で閉じるしくみ、Release とタグ）を説明します。オープンソースでよく使われる **フォーク方式** との違いも紹介します。

GitHub の画面やプランの内容は変わることがあります。このページの画面の説明とプランごとの制限は **執筆時点** のものです。最新の情報は、各節の出典（GitHub Docs）で確認してください。

## このページでわかること

- クローン・テンプレート・フォークの違い
- コラボレーター方式（共有リポジトリ）とフォーク方式の比較、フォーク方式の手順
- 個人アカウントと Organization のリポジトリの権限（Read / Triage / Write / Maintain / Admin）
- ブランチ保護とルールセットの違い、無料プランでの制限、チームリポジトリでのおすすめ設定
- PR のマージ方法3種（merge commit / squash / rebase）の違い
- `Closes #番号` で Issue が自動で閉じるしくみと条件
- タグと Release の関係
- 次の一歩：GitHub Pages・GitHub Actions・Projects

---

<a id="copies"></a>

## 1. クローン・テンプレート・フォーク：3つの「コピー」

この教材では、3種類の「コピー」を使い分けてきました。

|                            | クローン（clone）         | テンプレートから作成（Use this template）                  | フォーク（fork）                                                           |
| -------------------------- | ------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------- |
| 使った場面                 | 2日目・8日目・9日目       | 2日目（自分用の `gitlearn`）、運営者のチームリポジトリ作成 | この教材では使わない（[レシピ github-03](../recipes/github.md#github-03)） |
| どこにできるか             | 自分のパソコン            | GitHub 上の自分のアカウント                                | GitHub 上の自分のアカウント                                                |
| 履歴                       | 元と同じ履歴をすべて持つ  | **履歴は引き継がず**、最初のコミットから始まる             | 元と同じ履歴をすべて持つ                                                   |
| 元のリポジトリとのつながり | `origin` として登録される | **つながりはない**（元の更新は反映されない）               | GitHub 上でつながっていて、元へ PR を送れる                                |
| 主な用途                   | 手元で作業する            | ひな形をもとに、独立した新しいリポジトリを作る             | 書き込み権限のないリポジトリに変更を提案する                               |

テンプレートから作ったリポジトリが、元のテンプレートの更新を自動で受け取らないのはこのためです（出典：[Creating a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)）。

---

<a id="collaboration-models"></a>

## 2. コラボレーター方式とフォーク方式

GitHub Docs は、PR を使った共同作業のやり方を2つに分けて説明しています（出典：[About collaborative development models](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models)）。

```text
コラボレーター方式（共有リポジトリ方式）：この教材のチーム開発編

          ┌──────── gitlearn-team-a（GitHub）────────┐
          │  main   hydr4/add-page   hanako/add-faq   │  ← 全員が同じリポジトリに
          └────────────────────────────────────────┘     ブランチを push し、PR を出す
             ↑ push        ↑ push          ↑ push
          メンバーA      メンバーB       メンバーC

フォーク方式：オープンソースでよく使われる

   元のリポジトリ（upstream）                      ← PR はここに送る
          ↑ PR                 ↑ PR
   Aのフォーク（origin）     Bのフォーク（origin）   ← 各自が自分のフォークに push
          ↑ push                ↑ push
       Aの手元                Bの手元
```

| 観点           | コラボレーター方式                             | フォーク方式                                                   |
| -------------- | ---------------------------------------------- | -------------------------------------------------------------- |
| 書き込み権限   | メンバー全員に Write 権限を与える              | 元のリポジトリへの書き込み権限は不要（読めればよい）           |
| push 先        | 元のリポジトリ（ブランチを作って push）        | 自分のフォーク                                                 |
| PR             | 同じリポジトリの中で、ブランチ → `main`        | 自分のフォークのブランチ → 元のリポジトリの `main`             |
| リモートの数   | `origin` だけ                                  | `origin`（自分のフォーク）と `upstream`（元のリポジトリ）の2つ |
| 向いている場面 | 小さなチーム、メンバーが決まっている           | 誰でも参加できるオープンソース、メンバーを信頼しきれない場面   |
| 注意点         | 全員が `main` を壊せるので、ルールセットで守る | 元のリポジトリの更新を自分で取り込む（同期する）手間がある     |

この教材でコラボレーター方式を選んだのは、リモートが `origin` だけで済み、8日目までに学んだ `push` / `pull` がそのまま使えるからです。

<a id="fork"></a>

### フォーク方式の流れ

ここでは、チームリポジトリをフォークして使う場合を例に、全体の流れを示します（[レシピ github-03](../recipes/github.md#github-03) も参照）。

1. 元のリポジトリの GitHub ページ右上の **Fork** ボタン → **Create fork** で、自分のアカウントにフォークを作ります。
2. **自分のフォーク** をクローンします。9日目にクローンしたチームリポジトリとフォルダ名がぶつからないよう、末尾に `-fork` を付けたフォルダにクローンします。`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
cd ~/git-practice
git clone https://github.com/<GitHubユーザー名>/gitlearn-team-<チーム記号>.git gitlearn-team-<チーム記号>-fork
```

3. 元のリポジトリを `upstream` という名前で登録します（名前は慣習です）。

```bash
cd ~/git-practice/gitlearn-team-<チーム記号>-fork
git remote add upstream https://github.com/<運営者のアカウント>/gitlearn-team-<チーム記号>.git
git remote -v
```

```text
origin    https://github.com/<GitHubユーザー名>/gitlearn-team-<チーム記号>.git (fetch)
origin    https://github.com/<GitHubユーザー名>/gitlearn-team-<チーム記号>.git (push)
upstream  https://github.com/<運営者のアカウント>/gitlearn-team-<チーム記号>.git (fetch)
upstream  https://github.com/<運営者のアカウント>/gitlearn-team-<チーム記号>.git (push)
```

4. いつもどおりブランチを作ってコミットし、**自分のフォーク（origin）** に push します。
5. GitHub で PR を作ると、base（取り込み先）に元のリポジトリが自動で選ばれます。**base repository** が元のリポジトリ、**head repository** が自分のフォークになっていることを確かめてから作成します。
6. 元のリポジトリの `main` が進んだら、自分の `main` に取り込みます。

```bash
git switch main
git fetch upstream
git merge upstream/main
git push origin main
```

GitHub 上の自分のフォークのページにある **Sync fork** → **Update branch** でも、フォークの `main` を元に合わせられます。その場合は、手元では `git pull` するだけです（出典：[Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)）。

> [!NOTE]
> フォークから PR を出すとき、**Allow edits by maintainers** にチェックを入れておくと、元のリポジトリの管理者があなたの PR のブランチに直接コミットして手直しできます（出典：[Allowing changes to a pull request branch created from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/allowing-changes-to-a-pull-request-branch-created-from-a-fork)）。

---

<a id="permissions"></a>

## 3. リポジトリの権限

### 個人アカウントのリポジトリ

個人アカウントが持つリポジトリには、**オーナー（owner）** と **コラボレーター（collaborator）** の2段階しかありません。招待されたコラボレーターは、push、PR の作成・マージ・クローズ、Issue やラベルの管理、Release の編集などができます。一方、コラボレーターの招待、公開範囲の変更、リポジトリの削除などはオーナーだけができます（出典：[Permission levels for a personal account repository](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-personal-account-settings/permission-levels-for-a-personal-account-repository)）。Private リポジトリに「読むだけ」の人を招待することはできません。

「Organization を使わない場合」（[運営者向けガイド](../docs/organizer-guide.md)）に各チームの A がリポジトリを作る方式は、こちらに当たります。

### Organization のリポジトリ：5つのロール

Organization（組織アカウント）のリポジトリでは、人やチーム（Teams）ごとに5段階のロールを選べます（出典：[Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization)）。

| ロール       | 想定される人                                         | 主にできること                                                    |
| ------------ | ---------------------------------------------------- | ----------------------------------------------------------------- |
| **Read**     | コードを書かず、見たり議論したりする人               | 閲覧、クローン、Issue・PR の作成とコメント                        |
| **Triage**   | 書き込みはせず、Issue や PR を整理する人             | Read に加えて、ラベル付け、担当者の割り当て、Issue のクローズなど |
| **Write**    | 実際に push して開発する人（**この教材のメンバー**） | Triage に加えて、push、PR のマージ、Release の作成など            |
| **Maintain** | リポジトリを運営するが、危険な操作はしない人         | Write に加えて、一部の設定の管理                                  |
| **Admin**    | すべてを任せられる人                                 | すべての設定、セキュリティ、リポジトリの削除など                  |

権限は「必要な分だけ」与えるのが基本です。メンバーには Write、運営者だけが Admin、という分け方がおすすめです。

---

<a id="rulesets"></a>

## 4. ブランチ保護とルールセット

### なぜ必要か

9日目のチームのルールで「`main` に直接 push しない」と決めましたが、Write 権限があれば、うっかり `git push origin main` してしまうことは技術的に可能です。**ブランチ保護**（protected branches）や **ルールセット**（rulesets）を設定すると、GitHub 側でこうした操作を拒否できます。

### 2つのしくみの違い

|                               | ブランチ保護ルール（従来の方法）         | ルールセット（新しい方法）                               |
| ----------------------------- | ---------------------------------------- | -------------------------------------------------------- |
| 1つのブランチに効くルールの数 | 1つだけ                                  | 複数のルールセットを重ねられる（最も厳しいものが効く）   |
| 一時的に無効にする            | 削除するしかない                         | **Active / Disabled** を切り替えられる                   |
| 例外（バイパス）の指定        | 管理者は既定で例外（オプションで外せる） | **Bypass list** に入れた人・ロール・アプリだけが例外     |
| 誰が見られるか                | 管理者                                   | 読み取り権限のある人なら誰でも、有効なルールを確認できる |

（出典：[About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)、[About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)）

両方を設定した場合は、両方のルールがすべて適用されます。これから設定するならルールセットがおすすめです。

### 無料プランでの制限（執筆時点）

> [!WARNING]
> 執筆時点で、ルールセットとブランチ保護は、**GitHub Free（個人・Organization とも）では Public リポジトリでのみ** 使えます。Private リポジトリで使うには、GitHub Pro・GitHub Team などの有料プランが必要です（出典：[About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) の冒頭の対象プラン）。Private のチームリポジトリでは、9日目のチームのルールを全員で守る運用になります。

### チームリポジトリでのおすすめ設定

設定の手順は [運営者向けガイドの「main を保護する」](../docs/organizer-guide.md) にあります。ここでは、各ルールが何を防ぐのかを説明します。

| ルール（画面の表示）                                                                                         | 何を防ぐか                                                                                | このチームでの設定                                                            |
| ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **Restrict deletions**                                                                                       | `main` ブランチそのものの削除                                                             | オン                                                                          |
| **Block force pushes**                                                                                       | `main` への force push（他の人のコミットが消える。[理由](remote-tracking.md#force-push)） | オン                                                                          |
| **Require a pull request before merging**                                                                    | PR を通さない直接の push                                                                  | オン                                                                          |
| └ **Required approvals**                                                                                     | 承認なしのマージ                                                                          | 1                                                                             |
| └ Dismiss stale pull request approvals when new commits are pushed                                           | Approve の後に内容を変えてマージすること                                                  | 任意（オンにすると、修正のたびに再 Approve が必要）                           |
| └ **Require conversation resolution before merging**（レビューのコメントがすべて解決済みであることを求める） | 未解決のレビューコメントを残したままのマージ                                              | 任意                                                                          |
| **Require linear history**                                                                                   | マージコミットを含む履歴                                                                  | **オフ**（オンにすると、この教材で使う Create a merge commit が使えなくなる） |

（ルール名の一覧の出典：[Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)）

### 設定したときに起きること

- `main` に直接 push しようとすると、`remote: error: GH013: Repository rule violations found for refs/heads/main.` で始まり（次の行に `- Changes must be made through a pull request.` などの理由が出ます）、`! [remote rejected] main -> main (push declined due to repository rule violations)` で終わるようなエラーで拒否されます。調べるときは `GH013` が手がかりになります（表示は執筆時点のもので、変わることがあります）。手元のコミットは消えないので、ブランチを作って移し（[レシピ branch-07](../recipes/branch.md#branch-07)）、PR を出し直します。
- PR の作成者は、自分の PR を Approve できません。そのため、Required approvals を 1 にすると「作成者以外の1人の Approve が必要」になり、9日目のルールと一致します。
- Bypass list が空なら、リポジトリの管理者（運営者）もルールの対象になります。運営者が緊急時に直接直したい場合は、Bypass list に自分のロールを追加できますが、練習のためには空のままがおすすめです。
- GitHub 上の **Resolve conflicts** や **Commit suggestion** は、`main` ではなく PR のブランチにコミットするので、ルールセットの影響を受けません。

---

<a id="merge-methods"></a>

## 5. PR のマージ方法3種

PR の **Merge pull request** ボタンの右の ▼ を押すと、3つの方法を選べます（リポジトリの設定で許可されているものだけが表示されます）。

```text
PR のブランチ：      C1 ── C2   ← hydr4/add-page
                    /
main：         A ── B ── M      ← main（先に別の PR がマージされている）

① Create a merge commit（この教材の方法）

               A ── B ── M ── X   ← main      X はマージコミット（親が M と C2）
                     \       /
                      C1 ── C2                 C1, C2 は元のハッシュ値のまま残る

② Squash and merge

               A ── B ── M ── S   ← main      S は C1+C2 の変更を1つにまとめた新しいコミット

③ Rebase and merge

               A ── B ── M ── C1' ── C2'   ← main   C1, C2 を付け替えた新しいコミット
```

| 方法                      | `main` の履歴             | PR のコミット                                       | 向いている場面                                                             |
| ------------------------- | ------------------------- | --------------------------------------------------- | -------------------------------------------------------------------------- |
| **Create a merge commit** | 枝分かれと合流が残る      | そのまま残る（ハッシュ値も同じ）                    | 「どの PR で何が入ったか」を残したい。手元のブランチとの対応がわかりやすい |
| **Squash and merge**      | 1 PR = 1 コミットの一直線 | 1つにまとめられ、個々のコミットは `main` に残らない | 「誤字修正」のような細かいコミットが多い PR                                |
| **Rebase and merge**      | 一直線                    | 1つずつ残るが、**常に新しいハッシュ値** になる      | コミットが整理されていて、一直線の履歴にしたい                             |

（出典：[About merge methods on GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github)）

### この教材が Create a merge commit を使う理由

- 7日目に学んだマージコミットと同じしくみなので、`git log --oneline --graph --all` で見たときに理解しやすい。
- コミットのハッシュ値が変わらないので、マージ後に手元で `git switch main` → `git pull` → `git branch -d <ブランチ名>` がそのまま成功する。

### Squash / Rebase を使ったときの注意

Squash and merge や Rebase and merge では、`main` に入るのは **新しく作られたコミット** です。手元のブランチのコミット（C1、C2）は `main` の祖先にならないので、`git pull` した後に `git branch -d` で削除しようとすると、次のように拒否されます。

```text
error: the branch 'hydr4/add-page' is not fully merged
hint: If you are sure you want to delete it, run 'git branch -D hydr4/add-page'
```

（Git 2.56 の表示です。このあとに、hint を表示しないようにする方法を案内する行が続くことがあります。古い Git では `hint:` が付かない形で表示されます）

PR がマージ済みであることを GitHub で確かめてから、`-D`（強制削除）で消します。マージ前のブランチを `-D` で消すと作業が失われるので、確認を忘れないでください。

### 関連する設定（Settings → General → Pull Requests）

| 設定                                                                          | 意味                                                                                                                                                                                                                                                                                                                                                                                                              |
| ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Allow merge commits** / **Allow squash merging** / **Allow rebase merging** | それぞれのマージ方法を許可するか。この教材では merge commits だけを許可するのがおすすめ                                                                                                                                                                                                                                                                                                                           |
| **Automatically delete head branches**                                        | PR のマージ後に、GitHub 上のブランチを自動で削除する（出典：[Managing the automatic deletion of branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches)）。手元の `origin/...` は残るので、`git fetch --prune` で片付ける（[Appendix：リモート追跡ブランチ](remote-tracking.md#prune)） |

---

<a id="closing-keywords"></a>

## 6. Issue と PR の自動リンク（`Closes #番号`）

### しくみ

10日目では、PR の本文に `Closes #<Issue番号>` と書いて、マージ時に Issue を自動で閉じました。GitHub は PR の本文の中の決まった単語（**closing keywords**）を見つけると、その PR と Issue をリンクし、PR が **既定のブランチ（`main`）にマージされたとき** に Issue を閉じます。

使える単語は次の9つです（大文字・小文字は区別しません）。

```text
close   closes   closed
fix     fixes    fixed
resolve resolves resolved
```

（出典：[Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)）

### 条件と注意点

| ポイント                   | 説明                                                                                                                       |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 既定のブランチへの PR だけ | `main` 以外のブランチに向けた PR では、キーワードは無視される                                                              |
| 書く場所                   | PR の **本文**（説明欄）に書く。PR へのコメントに書いても閉じない                                                          |
| 複数の Issue               | `Closes #3, closes #5` のように、Issue ごとにキーワードを付ける                                                            |
| 別のリポジトリの Issue     | `Closes <運営者のアカウント>/gitlearn#7` のように `所有者/リポジトリ#番号` で書く                                          |
| コミットメッセージ         | コミットメッセージに書いても、そのコミットが既定のブランチに入ったときに閉じる（ただし PR とのリンクとしては表示されない） |
| `#番号` だけ               | `#3` とだけ書くと、Issue へのリンク（参照）になるが、閉じはしない                                                          |

キーワードを書き忘れた場合は、PR の右側の **Development** 欄から、手動で Issue をリンクすることもできます（執筆時点の表示です）。

> [!TIP]
> 「途中まで対応したが、まだ Issue は閉じたくない」ときは、`Closes` ではなく `#3` や「Issue #3 の一部です」のように書けば、リンクだけして閉じずに済みます。

---

<a id="releases"></a>

## 7. タグと Release

### タグはコミットに付ける「動かない名札」

ブランチはコミットするたびに進む名札でしたが、**タグ（tag）は特定のコミットに付けたまま動かない名札** です。「`v1.0` はこのコミット」のように、節目を記録するのに使います。

| 種類                      | 作り方                              | 中身                                                           |
| ------------------------- | ----------------------------------- | -------------------------------------------------------------- |
| 軽量タグ（lightweight）   | `git tag v1.0`                      | コミットを指す名前だけ                                         |
| 注釈付きタグ（annotated） | `git tag -a v1.0 -m "最初の完成版"` | 作成者・日時・メッセージを持つ（公開する節目にはこちらが推奨） |

14日目のように、GitHub の Release 画面で新しいタグ名を入力して作ったタグ（Create new tag on publish）は、軽量タグになります。注釈付きタグにしたいときは、手元で `git tag -a` を使って作り、push してから Release 画面で選びます（執筆時点の動作。`git cat-file -t v1.0` で確認できます。`commit` と表示されれば軽量タグ、`tag` と表示されれば注釈付きタグです。くわしくは [Appendix：Git の内部のしくみ](git-internals.md)）。

手元でタグを扱うときのポイントです（出典：[git-tag](https://git-scm.com/docs/git-tag)、[Pro Git（日本語版）2.6 Git の基本 - タグ](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E5%9F%BA%E6%9C%AC-%E3%82%BF%E3%82%B0)）。

- `git push` だけでは **タグは送られません**。手元で作ったタグを GitHub に送るには、`git push origin v1.0` のようにタグ名を指定します。
- GitHub で作られたタグを手元に取ってくるには、14日目と同じく `git fetch --tags` を使います。
- 公開したタグを付け替えたり消したりすると、すでに取ってきた人の手元とずれます。間違えたら、`v1.0.1` のように新しいタグを付けるのが安全です。

### Release は「タグ＋説明＋配布物」

GitHub の **Release** は、Git のタグをもとに、説明文（リリースノート）とダウンロード用のファイルを付けて公開するしくみです（出典：[About releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)）。

- Release はタグにもとづきます。14日目のように、Release を作る画面で新しいタグ名（`v1.0`）を入力すると、Release の公開と同時にタグも作られます。
- そのタグの時点のファイル一式が、**zip** と **tar.gz** のダウンロードリンクとして自動で付きます。
- **Generate release notes** ボタンで、前のリリースからマージされた PR の一覧をもとに、リリースノートを自動で作れます（執筆時点の表示です）。
- Release を作成・編集できるのは、Write 以上の権限がある人です。

### バージョン番号の付け方

`v1.0` のような番号には決まりはありませんが、ソフトウェアでは **セマンティック バージョニング**（`メジャー.マイナー.パッチ`。互換性が壊れる変更でメジャー、機能追加でマイナー、修正でパッチを上げる）がよく使われます（出典：[セマンティック バージョニング 2.0.0](https://semver.org/lang/ja/)）。

---

<a id="next-steps"></a>

## 8. 次の一歩：GitHub のその他の機能

14日目の「これから先へ」で紹介した機能を、もう少し詳しく説明します。

### GitHub Pages：Markdown や HTML をウェブサイトとして公開する

リポジトリの中の HTML や Markdown を、`https://<GitHubユーザー名>.github.io/...` のようなアドレスのウェブサイトとして公開できる機能です。たとえば、完成した「サークル紹介ガイドブック」をウェブページとして見せることもできます。

- 執筆時点で、GitHub Free では **Public リポジトリ** で使えます（Private で使うには有料プラン。出典：[What is GitHub Pages?](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages)）。
- 公開されたページは誰でも見られます。個人情報を書かないルールは、ここでも同じです。

### GitHub Actions：push や PR をきっかけに自動で処理を動かす

`.github/workflows/` に YAML ファイルを置くと、「PR が出されたら、Markdown のリンク切れを自動チェックする」「`main` にマージされたら、GitHub Pages に公開する」といった処理を、GitHub のサーバー上で自動実行できます。このような自動チェックのしくみを **CI**（継続的インテグレーション）と呼びます。

- 執筆時点で、Public リポジトリで GitHub が用意する標準の実行環境（ランナー）を使う場合は無料、Private リポジトリでは月ごとの無料枠があります（出典：[GitHub Actions billing](https://docs.github.com/en/billing/concepts/product-billing/github-actions)）。
- ルールセットの **Require status checks to pass before merging** と組み合わせると、「自動チェックが通らない PR はマージできない」ようにできます。
- 入門には [Understanding GitHub Actions](https://docs.github.com/en/actions/get-started/understand-github-actions) がおすすめです。

### Projects：Issue をボードや表で管理する

Issue や PR を、「未着手」「作業中」「完了」の列に並べたボード（カンバン）や表で管理できる機能です。チームの進み具合を一目で見たいときに便利です（出典：[About Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)）。

### そのほか、チーム開発で知っておくと便利なもの

| 機能                              | 説明                                                                                                                                        |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| ドラフト PR（Draft pull request） | 「まだ作業中」の印を付けた PR。マージできず、準備ができたら **Ready for review** で通常の PR にする。早めに方向性を見てもらいたいときに使う |
| Issue / PR テンプレート           | このリポジトリの `.github/` にあるもの。Issue や PR を作るときの本文のひな形                                                                |
| CODEOWNERS                        | ファイルやフォルダごとに「この部分のレビュー担当」を決めておき、PR が出たら自動でレビューを依頼するしくみ                                   |

---

## まとめ

- テンプレートは「履歴を引き継がない独立したコピー」、フォークは「元とつながったコピー」。
- この教材はコラボレーター方式（全員に Write 権限、同じリポジトリでブランチ → PR）。オープンソースではフォーク方式（自分のフォークに push し、元へ PR）が多い。
- ルールセットで `main` への直接 push・force push・削除を防げる。ただし執筆時点の無料プランでは Public リポジトリのみ。
- マージ方法は3種類。Squash と Rebase は新しいコミットを作るので、手元のブランチは `-d` で消せないことがある。
- `Closes #番号` は PR の本文に書き、既定のブランチにマージされたときに Issue を閉じる。
- Release はタグにもとづき、説明と配布物を付けて公開するしくみ。タグは `git push` だけでは送られない。

## 関連ページ

- 本編：[9日目 チームの準備と Issue](../docs/day09-team-kickoff.md)、[10日目 はじめてのプルリクエスト](../docs/day10-pull-request.md)、[11日目 コードレビュー](../docs/day11-code-review.md)、[13日目 最終課題に取り組む](../docs/day13-final-project.md)、[14日目 完成・リリース・ふりかえり](../docs/day14-release-retrospective.md)、[運営者向けガイド](../docs/organizer-guide.md)
- レシピ：[github-01](../recipes/github.md#github-01)〜[github-12](../recipes/github.md#github-12)、[branch-04](../recipes/branch.md#branch-04)、[branch-07](../recipes/branch.md#branch-07)
- Appendix：[よいコミットとレビューしやすい PR](commit-best-practices.md)、[リモート追跡ブランチ](remote-tracking.md)、[ブランチとマージ](branches-and-merge.md)、[rebase](rebase.md)、[認証のしくみ](authentication.md)

## 参考資料（公式ドキュメント）

- [About collaborative development models](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models)
- [Fork a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)、[Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)
- [Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization)
- [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)、[Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)
- [About merge methods on GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github)
- [Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
- [About releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
