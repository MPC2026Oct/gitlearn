# 2日目：GitHubアカウントと認証

[← 1日目](day01-install-git.md) ｜ [README（全体の地図）](../README.md) ｜ [3日目 →](day03-first-commit.md)

## この日のゴール

- 2要素認証（2FA）付きの GitHubアカウントを作れる
- メールアドレスを公開しない設定にし、Git の `user.email` を noreply アドレスに変更できる
- テンプレートから自分用の `gitlearn`（Private）を作れる
- VS Code でクローンし、ブラウザでの認証（Git Credential Manager）を通せる

## 所要時間の目安

合計 **60分**

| セクション                              | 目安 |
| --------------------------------------- | ---- |
| 1. GitHubアカウントを作る（2FA まで）   | 20分 |
| 2. メールアドレスを公開しない設定にする | 5分  |
| 3. 教材を自分用にコピーする             | 5分  |
| 4. VS Code でクローンして認証する       | 15分 |
| 5. VS Code で教材を読む                 | 5分  |
| 演習・確認                              | 10分 |

## 前提

- [1日目](day01-install-git.md) が終わっている（Git のインストール、初期設定、`~/git-practice` フォルダの作成）
- スマートフォンに **認証アプリ**（Google Authenticator、Microsoft Authenticator など、30秒ごとに6桁の数字が変わる「TOTP」方式のアプリなら何でも可）をインストールできること
- 受信できるメールアドレス
- 運営者から教わった、テンプレートリポジトリの URL（`https://github.com/<運営者のアカウント>/gitlearn`）

---

## 1. GitHubアカウントを作る

**GitHub（ギットハブ）** は、Git で記録した履歴をインターネット上に置いて、ほかの人と共有するための Web サービスです。まずアカウント（利用者登録）を作ります。

GitHub の画面は英語で表示されます。この教材では、ボタンなどの名前を英語のまま書きます（画面の説明は執筆時点の表示です）。

> [!TIP]
> すでに GitHubアカウントを持っている人は、新しく作る必要はありません。[2要素認証（2FA）を設定する](#2要素認証2faを設定する) に進み、2FA が有効になっているか確認してください。

### ユーザー名の決め方

アカウントを作る前に、**ユーザー名**（Username）を決めておきましょう。ユーザー名は次のような性質があります。

- **公開されます。** リポジトリの URL（`https://github.com/ユーザー名/...`）や、チームでの作業の記録に表示されます。本名を避けたい人は、ニックネームをもとにしましょう。
- **使える文字は半角英数字とハイフン（`-`）だけ** です。先頭と末尾にハイフンは使えず、ハイフンを2つ続けることもできません。最大39文字です。
- **後から変えると面倒です。** 変更はできますが、古い URL が使えなくなるなど影響があります。長く使える名前にしましょう。
- この勉強会では、チームでの作業のブランチ名にもユーザー名を使います（例：`hydr4/add-member-page`）。**短くて打ちやすい名前** がおすすめです。

### アカウントを作成する

1. ブラウザで <https://github.com/> を開きます。
2. 右上の **Sign up** をクリックします。
3. 画面の案内に従って、**メールアドレス**（Email）、**パスワード**（Password）、**ユーザー名**（Username）、国・地域（Your Country/Region）を入力し、**Create account**（または **Continue**）をクリックします。
   - パスワードは、ほかのサービスと使い回さない、長いものにしましょう。
4. 人間であることの確認（パズルなど）が表示されたら、指示に従って答えます。
5. 入力したメールアドレスに、GitHub から確認コード（数字）が届きます。画面にそのコードを入力します。
6. 好みのアンケートなどが表示された場合は、答えても、スキップ（**Skip** など）してもかまいません。
7. 料金プランを聞かれた場合は、無料の **Free** を選びます。

> [!NOTE]
> メールアドレスの確認が終わっていないと、リポジトリを作るなどの基本的な操作ができません。確認メールが届かないときは、迷惑メールフォルダも見てください。
> 出典：GitHub Docs「Creating an account on GitHub」 <https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github>

### 2要素認証（2FA）を設定する

**2要素認証（2FA）** とは、ログインのときに **パスワード** に加えて **スマートフォンの認証アプリに表示される6桁の数字** も入力するしくみです。パスワードが漏れても、他人がログインしにくくなります。

執筆時点で GitHub は、コードを公開するなどの活動をしたアカウントに 2FA を **必須** にしています（対象になると、45日以内に設定するよう案内されます）。この勉強会でもリポジトリを作って活動するので、**最初に設定しておきます**。GitHub が最初の方式としておすすめしているのは、**TOTP アプリ**（認証アプリ）です。

> 出典：GitHub Docs「About mandatory two-factor authentication」 <https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-mandatory-two-factor-authentication>

1. スマートフォンに認証アプリをインストールしておきます。
2. GitHub の画面の右上にある、自分のアイコン（プロフィール画像）をクリックし、**Settings** をクリックします。
3. 左側のメニューの「Access」の欄にある **Password and authentication** をクリックします。
4. 「Two-factor authentication」の欄にある **Enable two-factor authentication** をクリックします（パスワードの再入力などを求められたら入力します）。
5. 画面に QR コードが表示されます。スマートフォンの認証アプリで「QR コードをスキャン」を選び、この QR コードを読み取ります。
6. 認証アプリに **GitHub** の項目が追加され、6桁の数字が表示されます。その数字を GitHub の画面の「Verify the code from the app」の欄に入力します。
7. 次の画面で **リカバリーコード**（recovery codes）が表示されます。次の「リカバリーコードを保管する」の手順で保存します。
8. 保存できたら **I have saved my recovery codes** をクリックします。これで 2FA が有効になります。

> [!TIP]
> 予備の方法として、GitHub Mobile（GitHub のスマートフォンアプリ）やパスキーを追加しておくこともできます。必須ではありません。
> 出典：GitHub Docs「Configuring two-factor authentication」 <https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication>

### リカバリーコードを保管する

**リカバリーコード** は、スマートフォンをなくしたり、機種変更で認証アプリが消えたりしたときに、GitHub に入るための **最後の鍵** です。これがないと、アカウントに二度と入れなくなることがあります。

1. リカバリーコードの画面で **Download** をクリックします。`github-recovery-codes.txt` というファイルが保存されます。
2. そのファイルを、**自分だけが見られる安全な場所** に保管します。たとえば次のような方法です。
   - パスワード管理アプリに保存する
   - 紙に印刷して、大切な書類と一緒にしまう
   - USB メモリなどにコピーして保管する

> [!CAUTION]
> リカバリーコードは、**チャット、Issue、リポジトリのファイルには絶対に書かないでください。** `~/git-practice` の中にも置かないでください（うっかり記録して公開してしまう危険があります）。

---

## 2. メールアドレスを公開しない設定にする

1日目に、Git の `user.email` に自分のメールアドレスを設定しました。このメールアドレスは、Git の記録（コミット）に含まれて、GitHub に送ると **誰でも見られる** ようになります。

そこで、GitHub が用意している **noreply アドレス**（ノーリプライ：公開用の、メールが届かない代わりのアドレス）を使うように変更します。noreply アドレスを使っても、記録は自分のアカウントにきちんと結びつきます。

### noreply アドレスを確認する

1. GitHub の右上の自分のアイコン → **Settings** をクリックします。
2. 左側のメニューの「Access」の欄にある **Emails** をクリックします。
3. **Keep my email addresses private** にチェックを入れます。
4. チェックの下の説明文の中に、次のような形のアドレスが表示されます。これが **noreply アドレス** です。

```text
12345678+hydr4@users.noreply.github.com
```

（数字の部分はアカウントごとに決まった番号、`+` の後ろはユーザー名です。人によって違います。）

5. （おすすめ）その下の **Block command line pushes that expose my email** にもチェックを入れます。うっかり自分のメールアドレスのまま GitHub に送ろうとしたときに、止めてくれます（そのときに出るメッセージは [レシピ trouble-12](../recipes/troubleshooting.md#trouble-12) を見てください）。

> 出典：GitHub Docs「Setting your commit email address」 <https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address>、「Email addresses reference」 <https://docs.github.com/en/account-and-profile/reference/email-addresses-reference>

### Git のメールアドレスを変更する

1. GitHub の画面に表示された noreply アドレスを、マウスで選択してコピーします。
2. VS Code を開き、ターミナル（Git Bash）を開きます（メニューの **ターミナル → 新しいターミナル**）。
3. 次のコマンドを入力します。`"ここにnoreplyアドレスを貼り付け"` の部分を、コピーした noreply アドレスに書き換えてから実行します（`"` は残します）。

```bash
git config --global user.email "ここにnoreplyアドレスを貼り付け"
```

例：

```bash
git config --global user.email "12345678+hydr4@users.noreply.github.com"
```

4. 変更できたか確認します。

```bash
git config --global user.email
```

コピーした noreply アドレスが表示されれば成功です。

```text
12345678+hydr4@users.noreply.github.com
```

> [!WARNING]
> 数字と `+` を含めて、**全部を正確に** コピーしてください。数字が抜けていると、記録が自分のアカウントに結びつきません。

> [!NOTE]
> **VS Code で行う場合**：この設定には VS Code の画面での操作はありません。ターミナルで実行してください。

---

## 3. 教材を自分用にコピーする

この教材は、運営者が GitHub に **テンプレートリポジトリ** として置いています。テンプレートリポジトリとは、「ひな形」として、中身をそのまま自分のリポジトリにコピーして使えるリポジトリのことです。

> **リポジトリ**（repository）は、変更履歴ごと保存されたフォルダのことです。3日目にくわしく学びます。

1. ブラウザで、運営者から教わったテンプレートリポジトリ（`https://github.com/<運営者のアカウント>/gitlearn`）を開きます。
2. ファイル一覧の上にある緑色の **Use this template** ボタンをクリックし、**Create a new repository** を選びます。
3. 次のように入力・選択します。

| 項目                     | 入力・選択する内容                            |
| ------------------------ | --------------------------------------------- |
| **Owner**                | 自分のユーザー名                              |
| **Repository name**      | `gitlearn`                                    |
| **Description**          | 空欄でかまいません                            |
| 公開範囲                 | **Private**（自分と招待した人だけが見られる） |
| **Include all branches** | チェックしない                                |

4. **Create repository**（表示によっては **Create repository from template**）をクリックします。
5. しばらくすると、`https://github.com/<GitHubユーザー名>/gitlearn` という自分のリポジトリが表示されます。左上に自分のユーザー名と `gitlearn`、その横に **Private** と表示されていれば成功です。

> [!NOTE]
> なぜ Private にするの？　この後の練習で、メモや自己紹介を書き込むことがあるからです。Private にしておけば、自分だけが見られます。
> 出典：GitHub Docs「Creating a repository from a template」 <https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template>

詳しくは [レシピ github-01](../recipes/github.md#github-01) も見てください。

---

## 4. VS Code でクローンして認証する

いま GitHub 上に作った自分の `gitlearn` を、自分のパソコンにコピーします。GitHub のリポジトリを手元にコピーすることを **クローン**（clone）といいます。**クローンの意味やしくみは8日目でくわしく学びます。** 今日は「教材を手元にダウンロードする操作」と考えてください。

### HTTPS と Git Credential Manager のしくみ（ざっくり）

Private のリポジトリは、本人であることを確かめないとクローンできません。この勉強会では、次のしくみで確かめます。

```text
 Git（自分のパソコン）                         GitHub
   │  ① https://github.com/... にアクセス  ─────▶ │
   │  ◀───── ② 「あなたは誰？」               │
   │
   ├─ Git Credential Manager（GCM）が起動
   │   ③ ブラウザを開いて GitHub にサインイン・承認
   │   ④ 受け取った「通行証」を Windows に安全に保存
   │
   │  ⑤ 通行証を見せてアクセス ─────────────────▶ │  OK！
```

- **HTTPS**：Web サイトと同じ、暗号化された通信の方式です。URL は `https://github.com/...` の形です。
- **Git Credential Manager（GCM）**：1日目に Git for Windows と一緒に入った、ログイン情報を管理するソフトです。ブラウザでのサインインを手伝い、受け取った通行証を **Windows 資格情報マネージャー** に安全に保存します。
- 一度保存されると、**次からは自動で使われます**。毎回サインインする必要はありません。

> [!NOTE]
> GitHub では、Git の操作で GitHub のパスワードを直接入力する方法は使えなくなっています。そのため、GCM のようなしくみを使います。くわしくは [Appendix：認証のしくみ](../appendix/authentication.md) を見てください。

### VS Code からクローンする

1. VS Code を開きます。ほかのフォルダを開いている場合は、メニューの **ファイル（File）→ フォルダーを閉じる（Close Folder）** で閉じておきます。
2. `Ctrl+Shift+P` を押してコマンドパレットを開きます。
3. `クローン`（英語表示の人は `clone`）と入力し、**Git: クローン（Git: Clone）** を選びます。
4. 入力欄に、自分の `gitlearn` の URL を入力して `Enter` を押します。`<GitHubユーザー名>` の部分は、かっこごと自分のユーザー名に置き換えてください。

```text
https://github.com/<GitHubユーザー名>/gitlearn.git
```

5. 保存先のフォルダを選ぶ画面が開きます。`C:\Users\<Windowsのユーザー名>\git-practice` を開いて、**リポジトリの宛先として選択（Select as Repository Destination）** をクリックします。
6. ここで、初めての場合は **サインインの画面** が表示されます。次の「ブラウザでサインインする」に進んでください。

### ブラウザでサインインする

（画面は執筆時点の表示です。バージョンによって文言が少し違うことがあります。）

1. 「Connect to GitHub」などと書かれた **Git Credential Manager のウィンドウ** が表示されます。**Sign in with your browser** をクリックします。
2. ブラウザが開き、GitHub のページが表示されます。GitHub にサインインしていない場合は、ユーザー名（またはメールアドレス）、パスワード、2FA の6桁の数字を入力してサインインします。
3. 「Git Credential Manager」がアクセスを求めるページが表示されます。緑色の **Authorize git-ecosystem** などのボタンをクリックして承認します。
4. ブラウザに「Authentication Succeeded」（認証に成功しました）のような表示が出たら、ブラウザのタブは閉じてかまいません。
5. VS Code に戻ると、クローンが始まります。終わると「複製したリポジトリを開きますか？」のような通知が右下に出ます。**開く（Open）** をクリックします。
6. 「このフォルダー内のファイルの作成者を信頼しますか?」と聞かれたら、自分のリポジトリなので **はい、作成者を信頼します（Yes, I trust the authors）** をクリックします。

> [!NOTE]
> 先に VS Code 自身の画面で「拡張機能 'GitHub' が GitHub を使用してサインインしようとしています」のように聞かれることもあります。その場合も **許可（Allow）** をクリックし、ブラウザでサインイン・承認すれば同じように進めます。
> 出典：Git Credential Manager <https://github.com/git-ecosystem/git-credential-manager>、VS Code Docs「Repositories and remotes」 <https://code.visualstudio.com/docs/sourcecontrol/repos-remotes>

> [!CAUTION]
> サインインの画面に **パスワードを直接入力する欄** しかない、別のアカウントでサインインされてしまった、`Authentication failed` と表示された、などのときは、[レシピ trouble-06](../recipes/troubleshooting.md#trouble-06) と [レシピ setup-05](../recipes/setup.md#setup-05) を見てください。

**Private のリポジトリをクローンできた＝認証がきちんと動いている** ということです。この認証は8日目以降の GitHub とのやりとりでもそのまま使われます。

### Git Bash でクローンする場合

VS Code の画面からではなく、ターミナルでクローンすることもできます。**VS Code でクローンできた人は、この手順は不要です**（同じ場所に2回クローンすることはできません）。

1. VS Code のターミナル（Git Bash）で、練習用フォルダに移動します。

```bash
cd ~/git-practice
```

2. クローンします。`<...>` の部分は、かっこごと置き換えてから実行します。

```bash
git clone https://github.com/<GitHubユーザー名>/gitlearn.git
```

3. 初めての場合は、上の「ブラウザでサインインする」と同じ画面が表示されるので、同じように承認します。
4. 次のように表示されれば成功です（数字は人によって違います）。

```text
Cloning into 'gitlearn'...
remote: Enumerating objects: 120, done.
remote: Counting objects: 100% (120/120), done.
remote: Compressing objects: 100% (95/95), done.
remote: Total 120 (delta 10), reused 100 (delta 5), pack-reused 0
Receiving objects: 100% (120/120), 80.00 KiB | 2.00 MiB/s, done.
Resolving deltas: 100% (10/10), done.
```

5. フォルダができたか確認します。

```bash
ls ~/git-practice/gitlearn
```

```text
appendix  docs  exercises  README.md  recipes
```

（並び順は環境によって違うことがあります。この5つが表示されていれば OK です。）

> [!TIP]
> `fatal: destination path 'gitlearn' already exists and is not an empty directory.` と出た場合は、すでにクローンできています（VS Code でクローン済みなど）。そのまま次に進んでください。

詳しくは [レシピ remote-01](../recipes/remote.md#remote-01) も見てください。

---

## 5. VS Code で教材を読む

今日からは、教材を自分のパソコンの VS Code で読めます。

### フォルダーを開く

クローンの直後に **開く** をクリックした人は、すでに開いています。開いていない人や、次の日からは次の手順で開きます。

1. VS Code のメニューの **ファイル（File）→ フォルダーを開く（Open Folder）** をクリックします。
2. `C:\Users\<Windowsのユーザー名>\git-practice\gitlearn` を選び、**フォルダーの選択（Select Folder）** をクリックします。
3. 左側の **エクスプローラー**（Explorer）に、`docs`、`exercises` などのフォルダが表示されます。

> [!TIP]
> Git Bash から開くこともできます。ターミナルで次のコマンドを実行すると、`gitlearn` フォルダを開いた VS Code の新しいウィンドウが開きます。
>
> ```bash
> code ~/git-practice/gitlearn
> ```

### Markdown をプレビューする

教材のファイル（`.md`）は **Markdown**（マークダウン）という書き方で書かれています。そのまま開くと記号が多くて読みにくいので、プレビュー表示（見た目を整えた表示）で読みましょう。

1. 左のエクスプローラーで `docs` → `day02-github-account.md`（このページ）をクリックして開きます。
2. `Ctrl+Shift+V` を押します。見出しや表が整った状態で表示されます。
3. 編集画面とプレビューを横に並べたいときは、`Ctrl+K` を押してから `V` を押します。

### ソース管理ビューを眺めてみる

VS Code の左端に縦に並んだアイコンの中に、**ソース管理**（Source Control）のアイコン（枝分かれした線のような形）があります。`Ctrl+Shift+G` でも開けます。

- ここは、Git の操作を **マウスで** 行うための画面です。
- 使い方は **3日目** から学びます。今日は場所だけ確認しておきましょう。
- 画面左下（ステータスバー）に `main` と表示されているのも確認してください。これは今いるブランチの名前です（6日目に学びます）。

---

## 演習

[演習：2日目 GitHub の準備と教材のクローン](../exercises/day02-github-setup/README.md) に取り組んで、今日の設定がすべてできているか確かめましょう。

## 確認チェックリスト

- [ ] GitHub の **Settings → Password and authentication** で、Two-factor authentication が有効（Enabled）と表示される
- [ ] リカバリーコードを、リポジトリやチャット以外の安全な場所に保管した
- [ ] GitHub の **Settings → Emails** で **Keep my email addresses private** にチェックが入っている
- [ ] `git config --global user.email` の結果が `@users.noreply.github.com` で終わるアドレスになっている
- [ ] 自分のアカウントに `gitlearn` リポジトリがあり、**Private** と表示されている
- [ ] `ls ~/git-practice/gitlearn` で `README.md` や `docs` が表示される
- [ ] VS Code で `README.md` を開き、`Ctrl+Shift+V` でプレビューできた

## よくあるつまずき

**ユーザー名がすでに使われていると言われる**
- 原因：同じユーザー名の人がすでにいます。
- 対処：数字やハイフンを加えるなど、少し変えてみてください（例：`hydr4-git`）。

**2FA の6桁の数字を入れても通らない**
- 原因：数字が切り替わる直前に入力した、またはスマートフォンの時計がずれている可能性があります。
- 対処：数字が新しくなった直後に入力し直します。スマートフォンの日時設定を「自動」にします。

**Git Credential Manager の画面が出ずに、`Authentication failed` や `403` と表示される**
- 原因：別のアカウントの情報が保存されている、URL のユーザー名がまちがっている、などが考えられます。
- 対処：→ [レシピ trouble-06](../recipes/troubleshooting.md#trouble-06)、保存された情報を消して入れ直すには [レシピ setup-05](../recipes/setup.md#setup-05)

**`remote: Repository not found.` と表示される**
- 原因：URL の `<GitHubユーザー名>` のつづりがまちがっている、または別のアカウントでサインインしています。
- 対処：ブラウザで自分の `gitlearn` を開き、アドレスバーの URL と見比べてください。サインインしたアカウントがちがう場合は [レシピ setup-05](../recipes/setup.md#setup-05)。

**クローンしたフォルダが見つからない**
- 原因：保存先に `git-practice` 以外の場所を選んでしまった可能性があります。
- 対処：`ls ~/git-practice` で確認します。ほかの場所にできてしまった場合は、そのフォルダをエクスプローラーで削除し、もう一度クローンします。

**8日目以降に `GH007: Your push would publish a private email address` と表示される**
- 原因：`user.email` が noreply アドレスになっていない状態で記録したものを GitHub に送ろうとしています。
- 対処：→ [レシピ trouble-12](../recipes/troubleshooting.md#trouble-12)

## もっと知りたい人へ

- [Appendix：認証のしくみ](../appendix/authentication.md)：パスワード認証が廃止された経緯、HTTPS と SSH の違い、GCM の動き、個人アクセストークン
- レシピ
  - [github-01 テンプレートから自分のリポジトリを作りたい](../recipes/github.md#github-01)
  - [remote-01 GitHub のリポジトリを手元にコピーしたい（clone）](../recipes/remote.md#remote-01)
  - [setup-05 保存された GitHub の認証情報を消して入れ直したい（アカウントの切り替え）](../recipes/setup.md#setup-05)
  - [trouble-06 `Authentication failed` や `403` で clone・push できない](../recipes/troubleshooting.md#trouble-06)
  - [trouble-12 `GH007: Your push would publish a private email address` と出る](../recipes/troubleshooting.md#trouble-12)

---
[← 1日目](day01-install-git.md) ｜ [README](../README.md) ｜ [3日目 →](day03-first-commit.md)
