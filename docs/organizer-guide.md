# 運営者向けガイド

[README（全体の地図）](../README.md)

このページは、勉強会を運営する人（運営者）向けの手順書です。この教材フォルダを GitHub に公開してメンバーに配り、チーム開発編（9〜14日目）の準備をして、終わったら片付けるまでを順番に書いています。

> [!NOTE]
> **このガイドを読む前に、[1日目](day01-install-git.md) と [2日目](day02-github-account.md) の手順を自分で済ませておいてください。** Git for Windows のインストール、`git config` の初期設定（noreply アドレスを含む）、GitHubアカウントと 2FA、VS Code のターミナル（Git Bash）の準備ができている前提で書いています。2日目の「教材を自分用にコピーする」以降は、テンプレートを公開した後に、メンバーと同じ立場で試してみるのがおすすめです。

- GitHub の画面は英語表示で、ボタン名などを英語のまま書いています（画面の説明は執筆時点の表示です）。
- コマンドの `<運営者のアカウント>` は、テンプレートリポジトリを置く **自分の GitHubユーザー名、または Organization 名** に、`<チーム記号>` は `a`、`b`、`c` … に、かっこごと置き換えてから実行します。

---

## 1. 全体のスケジュール

勉強会の1日目を「1日目」として、運営者がやることを時系列でまとめます。

| いつ | 運営者がやること | このガイドの節 |
|---|---|---|
| 開始7日前まで | 教材づくり用ファイルの削除、README の記入、GitHub へ公開、テンプレートリポジトリに設定 | [2.](#2-配布前の準備)・[3.](#3-このフォルダを-github-のテンプレートリポジトリとして公開する) |
| 開始7日前まで | （おすすめ）Organization を作る。テンプレートもここに置く | [5.](#organization-を作るおすすめ) |
| 開始3日前まで | メンバーに README の URL と、勉強会の進め方・連絡先を案内する | [4.](#4-メンバーに自分用のコピーを作ってもらう) |
| 1〜2日目 | セットアップの質問に答える（つまずきが一番多い時期です） | [6.](#6-期間中の運営) |
| 3〜8日目 | 進み具合を確認する。チーム分けを決め、9日目の集まる時間を調整する | [6.](#6-期間中の運営) |
| 8日目まで | チームリポジトリを作り、メンバーを招待し、`main` を保護する | [5.](#5-チーム開発編の準備8日目まで) |
| 9日目 | キックオフ（各チームで集まる）。招待の承認とクローンを手伝う | [6.](#6-期間中の運営) |
| 12日目 | コンフリクト練習（各チームで集まる）。困ったチームを手伝う | [6.](#6-期間中の運営) |
| 14日目 | リリースとふりかえり（各チームで集まる） | [6.](#6-期間中の運営) |
| 終了後 | チームリポジトリのアーカイブ、Organization・成果物の扱いを決める | [8.](#8-終了後の片付け) |

---

## 2. 配布前の準備

### 教材づくり用のファイルを削除する

この教材フォルダには、教材を作るときにだけ使ったファイルが入っています。メンバーには不要なので、**公開する前に** 削除します。

| 削除するもの | 中身 |
|---|---|
| `CLAUDE.md` | 教材づくり用の共通ルール |
| `PROGRESS.md` | 教材づくりの進捗メモ |
| `.claude/` フォルダ（中身ごと） | 教材づくり用のエージェント設定 |
| `docs/DESIGN.md` | 教材の設計メモ |
| `claude-agents/` フォルダ（もしあれば） | 教材づくり用のエージェント設定 |

**Git Bash で削除する場合**

1. VS Code で、教材フォルダ（`README.md` があるフォルダ）を **ファイル → フォルダーを開く** で開きます。
2. **ターミナル → 新しいターミナル** で Git Bash を開きます。ターミナルは、開いたフォルダの中にいる状態で始まります。
3. 正しいフォルダにいるか確認します。`README.md`、`docs`、`exercises` などが表示されれば OK です。

```bash
ls -a
```

4. ファイルを削除します。

```bash
rm CLAUDE.md PROGRESS.md docs/DESIGN.md
```

5. `.claude` フォルダを中身ごと削除します。`-r` は「フォルダの中身ごと」という意味です。

```bash
rm -r .claude
```

6. `claude-agents` フォルダがある場合だけ、同じように削除します（ない場合は `No such file or directory` と表示されるだけなので、気にしなくて大丈夫です）。

```bash
rm -r claude-agents
```

7. 消えたことを確認します。

```bash
ls -a
```

> [!WARNING]
> `rm` で削除したファイルはごみ箱に入りません。ファイル名をよく確かめてから実行してください。`.gitignore`、`.gitattributes`、`.github` は **削除しません**（教材の一部です）。

**エクスプローラーで削除する場合**

1. エクスプローラーで教材フォルダを開きます。
2. 上部の **表示** → **表示** → **隠しファイル** をクリックしてチェックを入れます（`.claude` など `.` で始まるフォルダが見えるようになります）。
3. `CLAUDE.md`、`PROGRESS.md`、`.claude` フォルダ（あれば `claude-agents` フォルダも）を選んで削除します。
4. `docs` フォルダを開き、`DESIGN.md` を削除します。

### README の【運営者が記入】を埋める

`README.md` の「困ったときは」の節に、運営者が書き込む欄が2つあります。VS Code で `README.md` を開き、`【運営者が記入` で検索（`Ctrl+F`）して書き換えます。

| 欄 | 書く内容 | 例 |
|---|---|---|
| サークルのグループチャット | 質問を受け付けるチャットの場所 | 「LINE グループ『Git 勉強会』」「Discord の #git-study チャンネル」 |
| 質問 Issue の URL | テンプレートリポジトリの Issue 一覧の URL | `https://github.com/<運営者のアカウント>/gitlearn/issues` の `<運営者のアカウント>` を実際の名前にしたもの |

> [!CAUTION]
> テンプレートリポジトリは **Public（誰でも見られる）** にします。README やほかのファイルに、メンバーの本名・電話番号・メールアドレスなどの個人情報や、チャットの招待リンクを書かないでください。チャットは「サークルの LINE グループ」のように、場所の名前だけを書きます。

---

## 3. このフォルダを GitHub のテンプレートリポジトリとして公開する

> [!TIP]
> **Organization（組織用のアカウント）を使う場合は、先に [5. の「Organization を作る」](#organization-を作るおすすめ) を済ませ、テンプレートも Organization に置くのがおすすめです。** その場合は、下の方法Bで Organization の中にリポジトリを作ります。

### 方法A：VS Code の「GitHub に公開（Publish to GitHub）」を使う（おすすめ）

この方法では、**自分の個人アカウント** に `gitlearn` リポジトリが作られます。

1. VS Code で、教材フォルダを **ファイル → フォルダーを開く** で開きます。
2. 左端の **ソース管理** アイコンをクリックします。
3. **GitHub に公開（Publish to GitHub）** ボタンをクリックします。
   - VS Code の GitHub サインインを求められたら **許可（Allow）** をクリックし、ブラウザでサインイン・承認します。
4. 画面上部にリポジトリ名の入力欄が出ます。`gitlearn` になっていることを確認し、**public**（パブリック）と書かれた方を選びます。
5. 「どのファイルをリポジトリに含めるかを選択します。」と表示されたら、**すべてにチェックが入っていることを確認** して **OK** をクリックします。
6. 右下に「GitHub に "gitlearn" リポジトリが正常に発行されました。」と表示されたら完了です。**GitHub 上で開く（Open on GitHub）** をクリックすると、ブラウザでリポジトリが開きます。

> 出典：VS Code Docs「Repositories and remotes」 <https://code.visualstudio.com/docs/sourcecontrol/repos-remotes>

### 方法B：Git Bash で公開する

**GitHub で空のリポジトリを作る**

1. ブラウザで GitHub を開き、右上の **+** → **New repository** をクリックします。
2. 次のように入力・選択します。

| 項目 | 内容 |
|---|---|
| **Owner** | 自分のアカウント、または作った Organization |
| **Repository name** | `gitlearn` |
| 公開範囲 | **Public** |
| **Add README** / **Add .gitignore** / **Add license** | **すべて付けない（オフ・None のまま）**。空のリポジトリにします |

3. **Create repository** をクリックします。

**フォルダを Git で管理して push する**

1. VS Code で教材フォルダを開き、**ターミナル → 新しいターミナル** で Git Bash を開きます。
2. `ls` で、`README.md` などが表示される（教材フォルダにいる）ことを確認します。

```bash
ls
```

3. このフォルダを Git で管理し始めます。

```bash
git init
```

4. すべてのファイルをステージします。

```bash
git add .
```

5. 最初のコミットをします。

```bash
git commit -m "教材の初版"
```

6. GitHub のリポジトリを登録します。`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
git remote add origin https://github.com/<運営者のアカウント>/gitlearn.git
```

7. GitHub に送ります。初めての場合は、2日目と同じブラウザでのサインインが求められます。

```bash
git push -u origin main
```

8. ブラウザで `https://github.com/<運営者のアカウント>/gitlearn` を開き、ファイルが表示されていれば完了です。

> [!NOTE]
> `git add .` のときに `LF will be replaced by CRLF` という警告が出ることがありますが、問題ありません（[レシピ trouble-11](../recipes/troubleshooting.md#trouble-11)）。各コマンドの意味は、メンバーと同じく [3日目](day03-first-commit.md) と [8日目](day08-remote-github.md) で学べます。

### テンプレートリポジトリに設定する

1. GitHub で `gitlearn` リポジトリを開きます。
2. リポジトリ名の下の **Settings** をクリックします。
3. **General** のページの上のほうにある **Template repository** にチェックを入れます（自動で保存されます）。
4. リポジトリのトップページに戻り、緑色の **Use this template** ボタンが表示されていることを確認します。

> 出典：GitHub Docs「Creating a template repository」 <https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository>

### Issues を有効にしておく

メンバーからの質問や、教材の修正依頼を Issue で受け付けるため、Issues を有効にします（新しいリポジトリでは最初から有効になっていることが多いです）。

1. **Settings** → **General** を開きます。
2. 下のほうの **Features** の欄で、**Issues** にチェックが入っていることを確認します。
3. リポジトリの上部に **Issues** タブが表示されていれば OK です。**Issues** → **New issue** で、「質問」「教材の修正依頼」などのテンプレートが選べることも確認しておきましょう。

### Public にする理由

- **Private のテンプレートリポジトリは、アクセス権のある人しか使えません。** メンバー全員が **Use this template** を押せるように、Public にします。
- Public なので、**誰でも中身を見られます。** 個人情報や、チャットの招待リンクなどは書かないでください。
- メンバーがコピーした自分用の `gitlearn` は、2日目の手順で Private にするので、メンバーの書き込みは公開されません。

---

## 4. メンバーに自分用のコピーを作ってもらう

1. メンバーに、テンプレートリポジトリの URL `https://github.com/<運営者のアカウント>/gitlearn` を送ります（`<運営者のアカウント>` を実際の名前にして送ります）。あわせて次のことを伝えます。
   - 1日目は、この URL をブラウザで開いて README と1日目のページを読みながら進めること
   - 必要なもの（README の「必要なもの（前提）」の表）
   - 質問の場所（チャット、テンプレートリポジトリの Issue）
   - 9・12・14日目はチームで集まる日であること
2. メンバーは [2日目](day02-github-account.md) の手順で、**Use this template** → **Create a new repository** から、自分のアカウントに Private の `gitlearn` を作ります。運営者が何かを操作する必要はありません。

> [!NOTE]
> テンプレートから作ったリポジトリは、**作った時点のコピー** です。後でテンプレートを修正しても、メンバーのコピーには自動で反映されません（[7. 教材を直したいとき](#7-教材を直したいとき)）。

---

## 5. チーム開発編の準備（8日目まで）

9日目からは、チームで1つのリポジトリ（チームリポジトリ）を使って作業します。チームリポジトリの名前は `gitlearn-team-<チーム記号>`（例：`gitlearn-team-a`）で、テンプレートから作ります。ガイドブックの素材は、チームリポジトリの中の `exercises/team-project/` にあります。

### チーム分けと役割記号を決める

- 1チーム **3〜4人** にします。5人以上になる場合は2チームに分けます。運営者もメンバーとして1チームに入ってかまいません。
- チームごとに記号 `a`、`b`、`c` … を決めます（リポジトリ名に使います）。
- チーム内の役割記号 A〜D は、**メンバー自身が9日目に** 決めます（GitHubユーザー名のアルファベット順。[9日目](day09-team-kickoff.md) に書いてあります）。運営者が決める必要はありません。
- 各メンバーの **GitHubユーザー名** を集めておきます（招待に使います）。

### Organization を作る（おすすめ）

**Organization**（組織用のアカウント）を作ると、サークルのリポジトリをまとめて管理でき、メンバーの権限もまとめて付けられます。無料（Free プラン）で作れます。

1. GitHub の右上の自分のアイコン → **Settings** をクリックします。
2. 左側のメニューの「Access」の欄にある **Organizations** をクリックします。
3. **New organization** をクリックします。
4. プランを選ぶ画面では、無料の **Free** を選びます。
5. Organization の名前（例：サークル名をもとにした英数字）、連絡用メールアドレスを入力し、「My personal account」（個人の持ち物）を選んで次に進みます。
6. メンバーを招待する画面が出たら、集めた GitHubユーザー名を入力して招待します（後からでも、Organization の **People** → **Invite member** で招待できます）。

> 出典：GitHub Docs「Creating a new organization from scratch」 <https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch>

> [!TIP]
> テンプレートリポジトリも Organization に置くと、URL が `https://github.com/<運営者のアカウント>/gitlearn` の `<運営者のアカウント>` が Organization 名になります。すでに個人アカウントで公開した場合は、`gitlearn` の **Settings** → 一番下の **Danger Zone** → **Transfer** で Organization に移すこともできます（移す前にメンバーへ URL を案内していた場合は、新しい URL を案内し直してください）。

### チームリポジトリを作る

チームの数だけ、次の手順を繰り返します。

1. ブラウザでテンプレートリポジトリ `https://github.com/<運営者のアカウント>/gitlearn` を開きます。
2. **Use this template** → **Create a new repository** をクリックします。
3. 次のように入力・選択します。

| 項目 | 内容 |
|---|---|
| **Owner** | Organization（Organization を使わない場合は [後述](#organization-を使わない場合)） |
| **Repository name** | `gitlearn-team-a`（チームごとに `a`、`b`、`c` …） |
| 公開範囲 | **Public** をおすすめします（理由は下の「main を保護する」を参照）。個人情報を書かないルールは9日目に全員で確認します |
| **Include all branches** | **オフ**（チェックしない） |

4. **Create repository**（表示によっては **Create repository from template**）をクリックします。
5. 作ったリポジトリの中に `exercises/team-project/README.md`、`exercises/team-project/members/_template.md`、`exercises/team-project/schedule.md` などがあることを確認します。

> 出典：GitHub Docs「Creating a repository from a template」 <https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template>

### メンバーに権限を付ける

チームのメンバーが push や PR のマージをできるように、チームリポジトリに **Write**（書き込み）権限を付けます。

**Organization の場合**

1. メンバーを Organization に招待済みであることを確認します（Organization の **People**）。
2. チームリポジトリの **Settings** → 左側の **Collaborators and teams** をクリックします。
3. **Add people** をクリックし、そのチームのメンバーの GitHubユーザー名を入力して選びます。
4. 役割（role）で **Write** を選び、追加します。
5. チームのメンバー全員について繰り返します。

> [!TIP]
> Organization の **Teams** で「team-a」のようなチームを作り、チームごとリポジトリに **Write** を付ける方法もあります。人数が多いときに便利です。

メンバーには、メールまたは `https://github.com/<運営者のアカウント>/gitlearn-team-<チーム記号>/invitations` から招待を承認してもらいます（[9日目](day09-team-kickoff.md)）。Organization の招待の場合は、Organization への招待も承認が必要です。

### main を保護する

チームのルール「`main` に直接 push しない。作業は必ずブランチ → PR」を GitHub 側でも守らせるため、**ルールセット**（rulesets）で `main` を保護します。

> [!WARNING]
> 執筆時点で、ルールセットは **GitHub Free（個人・Organization とも）では Public リポジトリでのみ** 使えます。Private のリポジトリでは設定しても効きません（有料プランなら Private でも使えます）。チームリポジトリを Private にした場合は、この設定を省略し、9日目の「チームのルール」をメンバーが守る運用にしてください。
> 出典：GitHub Docs「About rulesets」 <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets>

1. チームリポジトリの **Settings** をクリックします。
2. 左側のメニューの **Rules** → **Rulesets** をクリックします（表示によっては **Rulesets** だけの場合もあります）。
3. **New ruleset** → **New branch ruleset** をクリックします。
4. **Ruleset name** に `protect-main` と入力します。
5. **Enforcement status** を **Active** にします。
6. 「Target branches」の **Add target** → **Include default branch** を選びます（`main` が対象になります）。
7. 「Branch rules」（Branch protections）の中で、**Require a pull request before merging** にチェックを入れます。
   - その下の **Required approvals**（必要な承認の数）を **1** にします。
   - **Restrict deletions** と **Block force pushes** は、チェックが入ったままにします。
8. 一番下の **Create** をクリックします。

これで、`main` への直接の push は拒否され、PR で1人以上の承認（Approve）がないとマージできなくなります。

> 出典：GitHub Docs「Creating rulesets for a repository」 <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository>

> [!NOTE]
> 9日目の「チームのルール」では、PR は **作成者以外の1人が承認（Approve）したら、作成者がマージする** と決めています。ルールセットの Required approvals を 1 にしておくと、このルールと一致します。

### マージ方法をそろえる

この勉強会では、PR のマージ方法を **Create a merge commit** に統一します。

1. チームリポジトリの **Settings** → **General** を開きます。
2. 下のほうの **Pull Requests** の欄で、**Allow merge commits** にチェックが入っていることを確認します（**外さないでください**）。
3. （任意）**Allow squash merging** と **Allow rebase merging** のチェックを外すと、マージボタンが「Create a merge commit」だけになり、メンバーが迷いません。
4. （任意）**Automatically delete head branches** にチェックを入れると、PR をマージしたときに GitHub 上のブランチが自動で削除されます。10日目では手動で **Delete branch** を押す手順を学ぶので、オフのままでもかまいません。

### Organization を使わない場合

Organization を作らない場合は、運営者が8日目までに指名した **各チームの「リポジトリ作成担当」** が、自分の個人アカウントにチームリポジトリを作ります。運営者は担当者に次の手順を伝えます。

1. 担当者は、テンプレートリポジトリで **Use this template** → **Create a new repository** を選び、**Owner** を自分、名前を `gitlearn-team-<チーム記号>`、公開範囲を **Public**、**Include all branches** をオフにして作ります。
2. チームリポジトリの **Settings** → 左側の **Collaborators** → **Add people** で、チームのメンバー全員の GitHubユーザー名を入力して招待します（個人アカウントのリポジトリでは、招待された人は自動的に書き込み権限を持ちます）。
3. 運営者も同じ手順で招待してもらうと、進み具合を確認できます。
4. 「main を保護する」「マージ方法をそろえる」も、担当者が同じ手順で設定します。

> [!NOTE]
> この場合、チームリポジトリの URL は `https://github.com/` の後ろが **担当者のユーザー名** になります（本編の `<運営者のアカウント>` の部分を、担当者のユーザー名に読み替えます）。メンバーには、9日目の前に正しい URL を案内してください。

### フォーク方式という選択肢

GitHub でのチーム開発には、もう1つ **フォーク方式**（fork：他人のリポジトリを自分のアカウントにコピーし、そこから元のリポジトリに PR を送る方法）があります。オープンソースのプロジェクトでよく使われます。

今回は次の理由で、**コラボレーター方式**（全員が同じリポジトリに書き込み権限を持つ方法）を使います。

- リポジトリが1つだけなので、`clone` → ブランチ → `push` → PR の流れがシンプル
- フォーク方式では「自分のフォーク」と「元のリポジトリ」の2つのリモートを扱う必要があり、初心者には難しい
- 小さなチームで、お互いを信頼して作業するため

フォーク方式を使いたい場合は、メンバーに Write 権限を付けず、各自がチームリポジトリを **Fork** して、そこから PR を送る流れになります。違いの詳細は [Appendix：GitHub でのチーム開発](../appendix/github-collaboration.md) と [レシピ github-03](../recipes/github.md#github-03) を見てください。

---

## 6. 期間中の運営

### 集まる日の進行例

**9日目：キックオフ（30分〜）**

| 時間 | 内容 |
|---|---|
| 5分 | あいさつ、チーム開発編の流れの説明（[9日目](day09-team-kickoff.md) の「1.」） |
| 10分 | 招待の承認とクローン（画面共有で、つまずいた人を手伝う） |
| 10分 | 役割（A〜D、進行役、レビューの組）を決めて、「チームのルール」Issue に合意コメント |
| 5分 | 次回（12日目）の日時の確認 |

**12日目：コンフリクト練習（60〜90分）**

| 時間 | 内容 |
|---|---|
| 5分 | 全員が `main` を最新にする |
| 30〜40分 | ラウンド1（手元の VS Code で解決）。進行役が A → B → C → D の順にマージを声かけ |
| 20〜30分 | ラウンド2（GitHub の Resolve conflicts で解決）。逆の順番でマージ |
| 10分 | 感想と、コンフリクトを減らす習慣の確認 |

ガイドブックの `exercises/team-project/schedule.md` を全員で同時に編集するので、**全員の PR がそろうまで誰もマージしない** ことを、最初にしっかり伝えてください。

**14日目：ふりかえり（30分〜）**

| 時間 | 内容 |
|---|---|
| 10分 | 最後の PR のマージ、`v1.0` の Release 作成（進行役） |
| 15分 | KPT（Keep / Problem / Try）のふりかえり。「ふりかえり」Issue に各自コメント |
| 5分 | まとめ（`exercises/team-project/retrospective.md` の PR）と、これからの学び方の紹介 |

### 質問の受け方

- **すぐ答えてほしい質問**：サークルのチャットで受け付けます。
- **記録に残したい質問・教材の誤り**：テンプレートリポジトリの Issue で、「質問」「教材の修正依頼」テンプレートを使って受け付けます。
- 質問には、「何日目のどの手順か」「実行したコマンドと表示されたメッセージの全文」「`git status` の結果」を添えてもらうと、解決が早くなります。
- **パスワード、リカバリーコード、トークンを貼らないよう、繰り返し伝えてください。** 誤って貼られた場合は、すぐに削除を依頼し、パスワードの変更やトークンの削除を勧めます。

### 進み具合の確認方法

- **1〜8日目**：チャットで「今日の確認チェックリストが終わったらひとこと」と声をかける方法が手軽です。8日目以降は、各自の GitHub の `my-profile` リポジトリ（Public にしている人のみ）でコミットを確認できます。
- **9〜14日目**：各チームリポジトリの **Issues** タブ（Open / Closed の数）と **Pull requests** タブを見ると、どこまで進んだかがわかります。**Insights** → **Network** では、ブランチとマージの様子を図で見られます。

### 遅れた人への対応

- セットアップ（1〜2日目）でつまずいた人は、画面共有で一緒に進めるのが一番早いです。
- ひとりで練習編（3〜8日目）が終わっていなくても、**8日目（GitHub とつなぐ）だけは9日目までに終えてもらう** ようにしてください。チーム開発編では `clone`・`push`・`pull` を使います。
- チーム開発編で遅れた人がいても、チームの作業は止めずに進めてかまいません。レビューの組の相手が、PR の出し方を手伝うよう声をかけてください。

---

## 7. 教材を直したいとき

1. テンプレートリポジトリ（公開した教材フォルダ）でファイルを修正し、コミットして push します。

```bash
git add .
```

```bash
git commit -m "2日目の手順を修正"
```

```bash
git push
```

2. メンバーにチャットで「どのページのどこを直したか」を告知します。
3. **メンバーがすでに作った自分用のコピー（`gitlearn`）や、チームリポジトリには、自動では反映されません。** 最新版はテンプレートリポジトリ `https://github.com/<運営者のアカウント>/gitlearn` をブラウザで見るよう案内してください。

> [!TIP]
> GitHub 上でファイルを直接編集することもできます（ファイルを開いて鉛筆アイコン → 編集 → **Commit changes**）。その場合は、手元の教材フォルダで `git pull` してから次の修正をしてください（[レシピ github-12](../recipes/github.md#github-12)）。

---

## 8. 終了後の片付け

### チームリポジトリをアーカイブする

**アーカイブ**（archive）すると、リポジトリは読み取り専用になり、成果物を残したまま変更できなくなります。

1. チームリポジトリの **Settings** をクリックします。
2. **General** のページの一番下の **Danger Zone** にある **Archive this repository** をクリックします。
3. 注意書きを読み、確認欄にリポジトリ名（例：`<運営者のアカウント>/gitlearn-team-a` の形で表示されたもの）を入力します。
4. **I understand the consequences, archive this repository** をクリックします。

> 出典：GitHub Docs「Archiving repositories」 <https://docs.github.com/en/repositories/archiving-a-github-repository/archiving-repositories>

アーカイブはいつでも解除（Unarchive）できます。

### Organization の扱い

- 次回の勉強会でも使うなら、Organization とテンプレートリポジトリはそのまま残しておきます。
- メンバーをそのまま残すか、**People** から外すかを決めます（外しても、各自の個人アカウントや自分用の `gitlearn` には影響しません）。

### 成果の公開範囲

- チームで作った「サークル紹介ガイドブック」を外部に公開してよいか、メンバー全員に確認します。
- 公開しない場合は、チームリポジトリを **Settings** → **Danger Zone** → **Change repository visibility** で **Private** にするか、削除（**Delete this repository**）します。削除は元に戻せないので、メンバーの合意を取ってから行ってください。
- 公開する場合も、個人情報が含まれていないかを最後にもう一度確認してください。

### メンバーの手元の練習フォルダ

メンバーのパソコンには、練習用の親フォルダ `~/git-practice/`（エクスプローラーでは `C:\Users\<Windowsのユーザー名>\git-practice`）の下に、次のフォルダができています。勉強会が終わったら、残すか削除するかは各自に任せてかまいません。削除する場合はエクスプローラーでフォルダごと削除するよう伝えてください。

| フォルダ | 中身 |
|---|---|
| `gitlearn/` | 教材の自分用コピーのクローン（2日目） |
| `my-profile/`、`my-profile-clone/` | ひとり練習用のリポジトリ（3日目・8日目） |
| `conflict-lab/` | コンフリクト練習用のリポジトリ（7日目） |
| `gitlearn-team-<チーム記号>/` | チームリポジトリのクローン（9日目） |
| `appendix-lab/` | Appendix を読みながら試した人だけにある、実験用の使い捨てリポジトリ（`appendix-lab/undo` のようにページごとのフォルダ） |

`appendix-lab/` の中身は実験専用なので、いつ削除しても本編の練習には影響しません。GitHub 上の `my-profile` や自分用の `gitlearn` は、手元のフォルダを削除しても消えません。

---

## 9. 運営者用チェックリスト

**開始前**

- [ ] 1日目・2日目の手順を自分で済ませた（Git、初期設定、GitHubアカウント、2FA、noreply アドレス）
- [ ] `CLAUDE.md`、`PROGRESS.md`、`.claude/`、`docs/DESIGN.md` を削除した
- [ ] `README.md` の【運営者が記入】を2か所とも埋めた
- [ ] （おすすめ）Organization を作った
- [ ] `gitlearn` を **Public** で公開し、**Template repository** にチェックを入れた
- [ ] **Issues** が有効で、Issue テンプレートが選べることを確認した
- [ ] 自分で **Use this template** を試し、2日目の手順どおりにコピー・クローンできることを確認した
- [ ] メンバーに README の URL、必要なもの、質問の場所、集まる日を案内した

**8日目まで**

- [ ] チーム分け（3〜4人）とチーム記号を決め、メンバーの GitHubユーザー名を集めた
- [ ] 各チームの `gitlearn-team-<チーム記号>` を、テンプレートから作った（**Include all branches** はオフ）
- [ ] チームのメンバー全員に **Write** 権限を付けた（招待した）
- [ ] （Public の場合）ルールセットで `main` を保護した（Require a pull request before merging、Required approvals 1）
- [ ] **Allow merge commits** が有効になっている
- [ ] 9・12・14日目に集まる日時を、各チームと決めた

**期間中**

- [ ] 9日目：全員が招待を承認し、チームリポジトリをクローンできた
- [ ] 12日目：全員が最低1回コンフリクトを解決した
- [ ] 14日目：各チームの `main` に `v1.0` の Release ができた

**終了後**

- [ ] 成果の公開範囲をメンバーと決めた
- [ ] チームリポジトリをアーカイブした（または Private にした・削除した）
- [ ] Organization とメンバーの扱いを決めた

---
[README（全体の地図）](../README.md)
