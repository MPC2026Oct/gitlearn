# レシピ集：Issue・PR・レビュー

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

GitHub のブラウザ画面で行う操作（リポジトリの作成、Issue、プルリクエスト、レビュー、Release）のレシピです。GitHub の画面は英語表示なので、ボタン名は英語のまま書いています（執筆時点の表示です。GitHub の画面は予告なく変わることがあります）。権限やマージ方法の違いなどを詳しく知りたい人は [Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md) を読んでください。

| ID                      | やりたいこと                                              |
| ----------------------- | --------------------------------------------------------- |
| [github-01](#github-01) | テンプレートから自分のリポジトリを作りたい                |
| [github-02](#github-02) | リポジトリにメンバーを招待したい・招待を承認したい        |
| [github-03](#github-03) | フォークして、元のリポジトリに PR を送りたい              |
| [github-04](#github-04) | Issue を作って、担当者とラベルを付けたい                  |
| [github-05](#github-05) | プルリクエストを作りたい                                  |
| [github-06](#github-06) | PR と Issue を紐づけて、マージ時に Issue を自動で閉じたい |
| [github-07](#github-07) | PR をレビューしたい（行コメント・修正提案・承認）         |
| [github-08](#github-08) | レビューの指摘を反映して PR を更新したい                  |
| [github-09](#github-09) | PR のコンフリクトを GitHub 上で解決したい                 |
| [github-10](#github-10) | PR をマージしたい（マージ方法の違い）                     |
| [github-11](#github-11) | タグを付けて Release を作りたい                           |
| [github-12](#github-12) | GitHub 上でファイルを直接編集したい                       |

---

<a id="github-01"></a>
## github-01 テンプレートから自分のリポジトリを作りたい

**こんなとき**：テンプレートリポジトリ（template repository：コピーして使うためのひな形として設定されたリポジトリ）から、自分用のリポジトリを作りたいとき。2日目に、教材 `gitlearn` の自分用コピーを作るときに使います。

**GitHub**：

1. テンプレートリポジトリのページ（`https://github.com/<運営者のアカウント>/gitlearn`）を開きます。
2. ファイル一覧の上にある緑色の **Use this template** ボタンを押し、**Create a new repository** を選びます。
3. **Owner** が自分のアカウントになっていることを確かめます。
4. **Repository name** に `gitlearn` と入力します。
5. 公開範囲で **Private** を選びます。
6. **Include all branches** はチェックしないままにします。
7. **Create repository from template** を押します。
8. 自分のアカウントに `gitlearn` ができたら、[remote-01](remote.md#remote-01) の手順でクローンします。

**Git Bash**：テンプレートからの作成は GitHub の画面で行います（ターミナルでの操作はありません）。

**VS Code**：GUI での操作はありません。GitHub の画面で作成してから、VS Code でクローンします。

**注意点**：

- **Use this template** ボタンが見えないときは、テンプレートの設定がされていないか、ページが狭くて隠れています。ブラウザの幅を広げるか、運営者に確認してください。
- テンプレートから作ったリポジトリは、元のリポジトリと履歴がつながっていません（最初のコミットが1つだけの状態から始まります）。テンプレートがあとで更新されても、自分のコピーには **自動で反映されません**。
- フォーク（[github-03](#github-03)）とは別物です。この勉強会では、各自の練習にはテンプレートを使います。

**関連**：[2日目（教材を自分用にコピーする）](../docs/day02-github-account.md)、[GitHub Docs：テンプレートからリポジトリを作成する](https://docs.github.com/ja/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

---

<a id="github-02"></a>
## github-02 リポジトリにメンバーを招待したい・招待を承認したい

**こんなとき**：チームリポジトリにメンバーを招待して、push や PR のマージができるようにしたいとき（招待する側）。招待メールが届いたので参加したいとき（招待される側）。

**GitHub（招待する側：個人アカウントのリポジトリの場合）**：

1. リポジトリのページで **Settings** タブを開きます。
2. 左のメニューの **Collaborators** を開きます（パスワードや 2FA の確認を求められることがあります）。
3. **Add people** を押し、相手の GitHub ユーザー名を入力して選びます。
4. 招待を送ります。相手が承認するまで「Pending invite」と表示されます。

Organization（組織アカウント）のリポジトリでは、メニュー名が **Collaborators and teams** になり、権限（**Write** など）を選んで招待します。詳しい手順は [運営者向けガイド](../docs/organizer-guide.md) にあります。

**GitHub（招待される側）**：

1. GitHub に登録したメールアドレスに届く招待メールの **View invitation** を開くか、ブラウザで次の URL を開きます。`<...>` の部分は、かっこごと置き換えてから開きます。

   ```text
   https://github.com/<運営者のアカウント>/gitlearn-team-<チーム記号>/invitations
   ```

2. **Accept invitation** を押します。
3. Organization への招待の場合は、`https://github.com/orgs/<運営者のアカウント>/invitation` などに表示される Organization への参加（**Join**）を承認します。
4. リポジトリが開けたら、[remote-01](remote.md#remote-01) の手順でクローンします。

**Git Bash／VS Code**：GUI・ターミナルでの操作はありません。GitHub の画面で行います。

**注意点**：

- 招待には有効期限（執筆時点では7日間）があります。期限が切れたら、招待する側にもう一度送ってもらってください。
- 招待を承認する前に clone や push をすると、`Repository not found` や `403` のエラーになります → [trouble-06](troubleshooting.md#trouble-06)。
- 招待するときは、相手の **ユーザー名** を確認してから送りましょう（似た名前の別人に送らないため）。

**関連**：[9日目（チームリポジトリに参加する）](../docs/day09-team-kickoff.md)、[運営者向けガイド](../docs/organizer-guide.md)、[Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)

---

<a id="github-03"></a>
## github-03 フォークして、元のリポジトリに PR を送りたい

**こんなとき**：自分に書き込み権限のない他人のリポジトリ（例：オープンソースのプロジェクトや、この教材のテンプレートリポジトリ）に、修正を提案したいとき。この勉強会のチーム開発ではコラボレーター方式を使うので、フォークは使いません（発展の内容です）。

フォーク（fork）とは、他人のリポジトリを、元とのつながりを保ったまま自分のアカウントにコピーすることです。

**GitHub**：

1. 元のリポジトリのページで、右上の **Fork** を押します。
2. **Owner** が自分になっていることを確かめて **Create fork** を押します。自分のアカウントに `<GitHubユーザー名>/<リポジトリ名>` ができます。自分のアカウントに同じ名前のリポジトリがすでにあるとき（例：この教材の `gitlearn` は2日目に自分用コピーを作っています）は、**Repository name** を `gitlearn-fork` などに変えてから **Create fork** を押します。
3. 自分のフォークをクローンし、ブランチを作って修正・コミット・push します（下の Git Bash の手順）。
4. 自分のフォーク、または元のリポジトリのページに出る **Compare & pull request** を押します。
5. 「base repository（送り先＝元のリポジトリ）」と「head repository（送り元＝自分のフォーク）」、それぞれのブランチを確かめます。
6. タイトルと説明を書いて **Create pull request** を押します。

**Git Bash**：`<...>` の部分は、かっこごと置き換えてから実行します。ここでは、この教材をフォークして、フォークの名前を `gitlearn-fork` にした場合を例にしています。別のリポジトリなら、`gitlearn-fork` の部分を自分のフォークの名前に書き換えてください。

```bash
cd ~/git-practice
git clone https://github.com/<GitHubユーザー名>/gitlearn-fork.git
cd gitlearn-fork
git switch -c fix-typo
```

ファイルを修正して `git add` → `git commit` したら、次を実行します。

```bash
git push -u origin fix-typo
```

**VS Code**：クローン・コミット・push は通常どおり行えます（[remote-01](remote.md#remote-01)、[remote-04](remote.md#remote-04)）。フォークと PR の作成は GitHub の画面で行います。

**注意点**：

- フォークは、元のリポジトリが更新されても自動では追いつきません。自分のフォークのページの **Sync fork** → **Update branch** で最新にできます。
- PR を送る前に、元のリポジトリの README や `CONTRIBUTING.md` にある「貢献のしかた」を読みましょう。
- テンプレートから作る（[github-01](#github-01)）のは「新しく自分のものにする」、フォークは「元に変更を提案するためにコピーする」という違いがあります。

**関連**：[Appendix：GitHub でのチーム開発（コラボレーター方式とフォーク方式）](../appendix/github-collaboration.md)、[GitHub Docs：フォークからプルリクエストを作成する](https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork)

---

<a id="github-04"></a>
## github-04 Issue を作って、担当者とラベルを付けたい

**こんなとき**：「メンバー紹介ページを追加」のような作業（タスク）や質問を、チームで見える形に書き残したいとき。誰が担当するかをはっきりさせたいとき。

**GitHub**：

1. リポジトリの **Issues** タブを開き、**New issue** を押します。
2. テンプレートの一覧が出たら、作業なら「作業タスク」を選びます（質問なら「質問」）。
3. タイトルを入力します（例：「メンバー紹介ページを追加（hydr4）」）。
4. 本文のテンプレートの項目（やること、完了条件など）を埋めます。
5. 右側（または下側）の **Assignees** で担当者を選びます。自分が担当するなら **assign yourself** を押します。
6. **Labels** でラベルを選びます（例：`documentation`）。
7. **Create**（画面によっては **Submit new issue**）を押して作成します。

コメントでは次の書き方が使えます。

- `@ユーザー名`：その人に通知が届きます（メンション）。
- `#12`：同じリポジトリの Issue や PR の12番へのリンクになります。

**Git Bash／VS Code**：GUI・ターミナルでの操作はありません。GitHub の画面で行います。

**注意点**：

- 作ったあとでも、Issue の右側のメニューから担当者・ラベルを変更できます。
- 作業が終わったら Issue を閉じます。PR と紐づけておくと、マージ時に自動で閉じられます → [github-06](#github-06)。
- 1つの Issue には1つの作業を書きます（13日目の「1 Issue = 1 ブランチ = 1 PR」）。
- Issue は、リポジトリを見られる人全員が読めます。個人情報やパスワードは書かないでください。

**関連**：[9日目（Issue でタスクを管理する）](../docs/day09-team-kickoff.md)、[13日目（タスクを Issue に分ける）](../docs/day13-final-project.md)、[Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)

---

<a id="github-05"></a>
## github-05 プルリクエストを作りたい

**こんなとき**：作業用ブランチでの変更を `main` に取り込んでもらうために、チームに確認（レビュー）を依頼したいとき。

**Git Bash**（PR を作る前の準備）：`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
git switch main
git pull
git switch -c <GitHubユーザー名>/add-member-page
```

ファイルを編集して `git add` → `git commit` したら、次を実行します。

```bash
git push -u origin <GitHubユーザー名>/add-member-page
```

**GitHub**：

1. push の直後にリポジトリのページを開くと、黄色い帯に **Compare & pull request** ボタンが出ます。押します。
   - 帯が出ないときは、**Pull requests** タブ → **New pull request** を押し、**base** に `main`、**compare** に自分のブランチを選びます。
2. 「**base: main** ← **compare: 自分のブランチ**」になっていることを確かめます。
3. タイトルを入力します（例：「メンバー紹介ページを追加」）。
4. 本文に PR テンプレートの内容が入っているので、項目を埋めます。関連 Issue は `Closes #<Issue番号>` と書きます（[github-06](#github-06)）。
5. 右側の **Reviewers** で、レビューの組の相手を選びます。
6. **Create pull request** を押します。

**VS Code**：ブランチの push は「ブランチの発行（Publish Branch）」ボタンでできます（[remote-04](remote.md#remote-04)）。PR の作成は、この教材では GitHub の画面で行います（拡張機能「GitHub Pull Requests」を入れると VS Code からも作れますが、この勉強会では扱いません）。

**注意点**：

- base と compare を逆にしないでください。矢印「←」の向きのとおり、compare（自分のブランチ）の変更が base（`main`）に入ります。
- **Files changed** タブで、意図しないファイルが入っていないかを確かめましょう。
- PR を出したあとも、同じブランチに push すれば PR は自動で更新されます（[github-08](#github-08)）。PR を作り直す必要はありません。
- 作業途中で見てもらいたいときは、**Create pull request** の横の ▼ から **Create draft pull request** を選ぶと、下書き（Draft）の PR になります。

**関連**：[10日目（プルリクエストを作る）](../docs/day10-pull-request.md)、[13日目](../docs/day13-final-project.md)、[Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)

---

<a id="github-06"></a>
## github-06 PR と Issue を紐づけて、マージ時に Issue を自動で閉じたい

**こんなとき**：PR がどの Issue の作業なのかをはっきりさせ、マージしたら Issue も自動で閉じるようにしたいとき。

**GitHub**：PR の本文（説明欄）に、キーワードと Issue 番号を書きます。`<...>` の部分は、かっこごと置き換えてから書きます。

```text
Closes #<Issue番号>
```

例：`Closes #12`

使えるキーワードは `close` `closes` `closed` `fix` `fixes` `fixed` `resolve` `resolves` `resolved` です（大文字・小文字は区別しません）。複数の Issue を閉じたいときは `Closes #12, closes #13` のように、Issue ごとにキーワードを書きます。

PR を作ったあとで書き足すときは、PR の本文右上の「…」→ **Edit** で編集します。うまく紐づくと、PR の右側の **Development** 欄に Issue が表示されます。**Development** 欄から手動で Issue を選んで紐づけることもできます。

**Git Bash／VS Code**：GUI・ターミナルでの操作はありません（コミットメッセージにキーワードを書く方法もありますが、この教材では PR の本文に書きます）。

**注意点**：

- 自動で閉じるのは、PR が **デフォルトブランチ（`main`）にマージされたとき** だけです。`main` 以外に向けた PR では閉じません。
- PR の **タイトル** に書いても自動では閉じません。本文に書きます。
- `Closes` と `#` の間にはスペースを入れ、`#` と番号の間にはスペースを入れません。
- マージ後、Issue のページで「closed this as completed in #○○」のように表示されていれば成功です。

**関連**：[10日目（Issue と紐づける）](../docs/day10-pull-request.md)、[GitHub Docs：プルリクエストを Issue にリンクする](https://docs.github.com/ja/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)

---

<a id="github-07"></a>
## github-07 PR をレビューしたい（行コメント・修正提案・承認）

**こんなとき**：レビューを頼まれた PR を読んで、コメントや修正の提案をし、問題なければ承認（Approve）したいとき。

**GitHub**：

1. PR のページで **Files changed** タブを開きます。
2. コメントしたい行の行番号にマウスを乗せ、表示される青い **+** を押します（複数行にまたがるときは、行番号をドラッグして選びます）。
3. コメントを書きます。
4. 修正を具体的に提案したいときは、コメント欄のツールバーにある **Add a suggestion**（±のようなアイコン）を押します。次のようなブロックが入るので、中身を「こう直したらどうか」という文に書き換えます。

   ````text
   ```suggestion
   - 日時: 5月10日（土）13:00
   ```
   ````

5. **Start a review** を押します（すぐに1件だけ送りたいときは **Add single comment**）。続けて他の行にもコメントできます。
6. すべて書き終えたら、画面右上の **Submit review**（画面によっては **Review changes**）を押します。
7. 全体へのコメントを書き、次のどれかを選んで **Submit review** を押します。

| 選択肢              | 使うとき                                     |
| ------------------- | -------------------------------------------- |
| **Comment**         | 質問や感想だけで、承認も差し戻しもしないとき |
| **Approve**         | このままマージしてよいと判断したとき（承認） |
| **Request changes** | マージする前に直してほしい点があるとき       |

**Git Bash／VS Code**：GUI・ターミナルでの操作はありません。内容を手元で確かめたいときは [remote-07](remote.md#remote-07) を見てください。

**注意点**：

- 自分が作った PR は自分で Approve できません。
- この勉強会のルールでは、レビュアーは **最低1つ** 行コメントか修正提案を付けます（11日目）。
- 人ではなく変更内容について書き、良い点も伝えましょう。コメントの例文は [レビューのチェックリスト](../exercises/day11-review/review-checklist.md) にあります。
- **Start a review** で書いたコメントは、**Submit review** を押すまで相手には見えません（「Pending」と表示されます）。送り忘れに注意してください。

**関連**：[11日目（レビューする）](../docs/day11-code-review.md)、[Appendix：よいコミットと PR](../appendix/commit-best-practices.md)、[GitHub Docs：プルリクエストで提案された変更をレビューする](https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-proposed-changes-in-a-pull-request)

---

<a id="github-08"></a>
## github-08 レビューの指摘を反映して PR を更新したい

**こんなとき**：レビューでコメントや修正提案をもらったので、直して PR を更新したいとき。

**方法1：手元で直して push する（Git Bash）**

PR を作ったときと **同じブランチ** で直してコミットし、push します。新しい PR を作る必要はありません。`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
git switch <GitHubユーザー名>/add-member-page
git pull
```

指摘された箇所を直して保存したら、次を実行します。

```bash
git add .
git commit -m "レビューの指摘を反映"
git push
```

push すると、PR の **Commits** と **Files changed** に自動で反映されます。

**方法2：修正提案をそのまま取り込む（GitHub）**

1. PR の **Conversation** タブ（または **Files changed**）で、修正提案の下にある **Commit suggestion** を押します。
2. コミットメッセージを確かめて **Commit changes** を押します。
3. 提案が複数あるときは、それぞれ **Add suggestion to batch** を押してから、まとめて **Commit suggestions** を押すと1つのコミットになります。

**再レビューを依頼する（GitHub）**：PR の右側の **Reviewers** 欄で、レビュアーの名前の横にある矢印が回転したアイコン（Re-request review）を押します。コメントで「直しました」と返信しておくと親切です。

**VS Code**：方法1は、ソース管理ビューでコミット → 「変更の同期（Sync Changes）」でもできます。方法2は GitHub の画面で行います。

**注意点**：

- 方法2で GitHub 上でコミットしたあとは、GitHub のブランチのほうが手元より進んでいます。手元で続けて作業する前に、そのブランチで **`git pull`** してください。忘れると push が拒否されます（[trouble-04](troubleshooting.md#trouble-04)）。
- 対応したコメントには返信し、解決したら **Resolve conversation** を押すと、残りの指摘が見やすくなります。

**関連**：[11日目（レビューに対応する）](../docs/day11-code-review.md)、[GitHub Docs：プルリクエストへのフィードバックを取り込む](https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/incorporating-feedback-in-your-pull-request)

---

<a id="github-09"></a>
## github-09 PR のコンフリクトを GitHub 上で解決したい

**こんなとき**：PR のページに「This branch has conflicts that must be resolved」と表示され、マージできないとき。手元を使わずにブラウザで解決したいとき（12日目のラウンド2）。

**GitHub**：

1. PR のページ下部の **Resolve conflicts** を押します。
2. エディタにコンフリクトしたファイルが表示されます。次のような部分を探します。

   ```text
   <<<<<<< hydr4/round2
   - 場所: 部室
   =======
   - 場所: 図書館の会議室
   >>>>>>> main
   ```

   `<<<<<<<` から `=======` までが自分のブランチの内容、`=======` から `>>>>>>>` までが `main` の内容です（ブランチ名は例です）。
3. 残したい内容に書き換え、`<<<<<<<`、`=======`、`>>>>>>>` の行を **すべて消します**。12日目は両方の案を残します。

   ```text
   - 場所: 図書館の会議室 / 部室
   ```

   先にマージされた `main` の案を前に、自分の案を後ろに書きます（12日目と同じ）。

4. ファイル右上の **Mark as resolved** を押します。
5. コンフリクトしたファイルが複数あれば、左の一覧から次のファイルを選んで同じように解決します。
6. **Commit merge** を押します。
7. PR のページに戻り、レビューを受けてから **Merge pull request** でマージします。
8. 手元では `git switch main` → `git pull` で最新にします。

**Git Bash／VS Code**：GitHub 上で解決する方法なので、手元の操作は最後の `git pull` だけです。手元の VS Code で解決する方法は [branch-08](branch.md#branch-08)（`git fetch origin` → `git merge origin/main`）と [branch-06](branch.md#branch-06) を見てください。

**注意点**：

- GitHub 上で解決できるのは、「同じ行を両方が変えた」ような単純なコンフリクトだけです。**Resolve conflicts** ボタンが押せない（灰色）ときは、手元で解決してください（[branch-08](branch.md#branch-08)）。
- この操作は、`main` の内容を **自分のブランチにマージする** コミットを作ります。手元でそのブランチを使い続けるなら `git pull` してください。
- マーカーの消し忘れがないか、**Files changed** で確かめてからマージしましょう。

**関連**：[12日目（ラウンド2：GitHub 上で解決する）](../docs/day12-team-conflict.md)、[Appendix：ブランチとマージ](../appendix/branches-and-merge.md)、[GitHub Docs：GitHub でマージコンフリクトを解決する](https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github)

---

<a id="github-10"></a>
## github-10 PR をマージしたい（マージ方法の違い）

**こんなとき**：PR が Approve されたので、`main` に取り込みたいとき。

**GitHub**：

1. PR のページ下部で、承認済み（Approved）であること、コンフリクトがないことを確かめます。
2. **Merge pull request** ボタンの右の ▼ で、マージ方法が **Create a merge commit** になっていることを確かめます。
3. **Merge pull request** → **Confirm merge** を押します。
4. 「Pull request successfully merged and closed」と出たら、**Delete branch** を押して GitHub 上の作業ブランチを削除します。
5. 手元を最新にして、手元のブランチも削除します（下の Git Bash）。

マージ方法は3種類あります。この勉強会では **Create a merge commit** に統一します（9日目のチームのルール）。

| マージ方法                | 何が起きるか                                                                                            |
| ------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Create a merge commit** | ブランチのコミットをそのまま残し、マージコミットを1つ作る。履歴に「いつ・どの PR を取り込んだか」が残る |
| **Squash and merge**      | ブランチのコミットを1つにまとめてから `main` に追加する                                                 |
| **Rebase and merge**      | ブランチのコミットを `main` の先頭に付け替えて追加する（マージコミットは作らない）                      |

**Git Bash**（マージ後の後片付け）：`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
git switch main
git pull
git branch -d <GitHubユーザー名>/add-member-page
```

**VS Code**：マージは GitHub の画面で行います。後片付けは、ステータスバーのブランチ名から `main` に切り替え → 「変更の同期（Sync Changes）」→ コマンドパレット「Git: ブランチの削除（Git: Delete Branch）」でもできます。

**注意点**：

- チームのルールでは、PR は **作成者が** マージします（Approve した人ではありません）。
- **Squash and merge** や **Rebase and merge** を使うと、手元のブランチを `git branch -d` で削除するときに「not fully merged」と言われることがあります。統一したマージ方法を使いましょう。
- マージを取り消したいときは、PR ページの **Revert** ボタンで「打ち消す PR」を作れます（push 済みの取り消しは [undo-05](undo.md#undo-05) も参照）。
- ブランチの削除の詳細は [branch-04](branch.md#branch-04) を見てください。

**関連**：[10日目（かんたんなレビューとマージ）](../docs/day10-pull-request.md)、[Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)

---

<a id="github-11"></a>
## github-11 タグを付けて Release を作りたい

**こんなとき**：完成した状態に `v1.0` のような名前（タグ）を付けて、あとから見返せるようにしたいとき。14日目にガイドブックの完成版を公開するときに使います。

タグ（tag）は、特定のコミットに付ける「動かない名札」です。Release は、タグに説明文などを添えて GitHub 上で公開する機能です。

**GitHub**（14日目は進行役が行います）：

1. リポジトリのページの右側にある **Releases** を押します（または **Create a new release**）。
2. **Draft a new release** を押します。
3. **Choose a tag** を押し、`v1.0` と入力して **Create new tag** を選びます。
4. **Target** が `main` になっていることを確かめます。
5. **Release title** に `v1.0` などと入力します。
6. 説明欄に、完成した内容を書きます（**Generate release notes** を押すと、マージした PR の一覧が自動で入ります）。
7. **Publish release** を押します。

**Git Bash**（手元でタグを確かめる）：

```bash
git switch main
git pull
git fetch --tags
git tag
```

```text
v1.0
```

タグを手元で作って push することもできます（GitHub で作った場合は不要です）。

```bash
git tag v1.0
git push origin v1.0
```

**VS Code**：コマンドパレットで「タグ」と入力し、「Git: Create Tag」（日本語表示ではタグの作成）を選ぶと手元にタグを作れます。Release の作成は GitHub の画面で行います。

**注意点**：

- タグは `git push` だけでは送られません。手元で作ったタグは `git push origin v1.0` のように名前を指定して送ります。
- 一度公開したタグを付け直すと、他の人の手元とずれて混乱します。付け間違えたら、慌てずにチームで相談してください。
- Release を削除しても、タグは GitHub に残ります。タグを消すには、手元から `git push origin --delete v1.0` を実行します（リポジトリへの書き込み権限が必要です）。手元のタグは `git tag -d v1.0` で消せます。
- タグ名は `v1.0` のように「v＋数字」にするのが一般的です。

**関連**：[14日目（完成版にタグを付けて Release を作る）](../docs/day14-release-retrospective.md)、[Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)、[GitHub Docs：リポジトリのリリースを管理する](https://docs.github.com/ja/repositories/releasing-projects-on-github/managing-releases-in-a-repository)

---

<a id="github-12"></a>
## github-12 GitHub 上でファイルを直接編集したい

**こんなとき**：誤字を1文字直すだけなど、手元でクローンしなくてもよい小さな修正をしたいとき。

**GitHub**：

1. 直したいファイルを GitHub で開きます。
2. ファイル右上の鉛筆アイコン（**Edit this file**）を押します。
3. 内容を編集します。**Preview** タブで表示を確かめられます。
4. **Commit changes...** を押します。
5. コミットメッセージを入力します。
6. 次のどちらかを選びます。チーム開発では **必ず下を選びます**。
   - **Commit directly to the `main` branch**：`main` に直接コミットする
   - **Create a new branch for this commit and start a pull request**：新しいブランチを作って PR を出す（ブランチ名は `<GitHubユーザー名>/<内容>` にします）
7. **Propose changes**（または **Commit changes**）を押し、PR を作る場合は続けて [github-05](#github-05) の手順で PR を作成します。

**Git Bash／VS Code**：GitHub 上で行う操作です。編集後は、手元で `git pull` して最新にしてください。

**注意点**：

- チームのルールでは `main` に直接コミットしません（9日目）。GitHub 上で編集するときも、ブランチと PR を使います。
- GitHub 上でコミットすると、手元のリポジトリより GitHub のほうが進みます。手元で作業する前に `git pull` しないと、push が拒否されます（[trouble-04](troubleshooting.md#trouble-04)）。
- 大きな変更や複数ファイルにまたがる変更は、手元で行うほうが確実です。

**関連**：[13日目](../docs/day13-final-project.md)、[Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md)
