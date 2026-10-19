# GitHub の認証のしくみ

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)

> **この解説の対象**：[2日目](../docs/day02-github-account.md)を読んだ人（[8日目](../docs/day08-remote-github.md)まで進めているとよりわかりやすくなります）
>
> **読む時間の目安**：30分

2日目では、VS Code からクローンしたときにブラウザが開き、GitHub で承認するだけで認証が終わりました。それ以降は push や pull のたびにパスワードを聞かれることはありません。このページでは、その裏で何が起きているのかを説明します。

## このページでわかること

- GitHub がパスワードでの Git 操作をやめた経緯
- HTTPS と SSH という2つの接続方法の違い
- Git Credential Manager（GCM）が、認証情報を取得・保存・削除する流れ
- 認証情報が Windows のどこに保存されているか
- 2要素認証（2FA）とリカバリーコード
- 個人アクセストークン（PAT）
- アカウントの切り替えと、保存された認証情報の削除
- 発展：SSH 鍵による認証

---

<a id="two-kinds"></a>
## 1. 「GitHub にログインする」には2種類ある

GitHub で「自分であること」を証明する場面は、大きく分けて2つあります。

| 場面                             | 例                                                                                                               | 証明のしかた                                              |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| ブラウザで GitHub のサイトを使う | Issue（イシュー：課題やタスクを書き込むチケット） を書く、プルリクエスト（Pull Request、略して PR） をマージする | ユーザー名（またはメール）＋パスワード＋2FA。パスキーも可 |
| **Git が GitHub と通信する**     | `clone`（Private リポジトリ）、`push`、`pull`、`fetch`                                                           | **トークン** または **SSH 鍵**（パスワードは使えない）    |

このページで扱うのは主に2つ目です。

> [!NOTE]
> `git config` の `user.name` と `user.email` は、どちらの認証にも使われません。これはコミットに書き込まれる「署名」です（[Git の設定のしくみ](git-config.md#day1-settings)）。

---

<a id="password-removal"></a>
## 2. パスワード認証の廃止

以前は、`git push` のときに GitHub のユーザー名とパスワードを入力して認証できました。しかし GitHub は、**2021年8月13日から、Git の操作でアカウントのパスワードを受け付けなくなりました**（出典：[GitHub Blog - Token authentication requirements for Git operations](https://github.blog/security/application-security/token-authentication-requirements-for-git-operations/)）。現在の GitHub Docs にも「Password-based authentication for Git has been removed in favor of more secure authentication methods.」とあります（出典：[GitHub Docs - About authentication to GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github)）。

パスワードの代わりに使われるのが **トークン（token）** です。トークンは、GitHub が発行する長いランダムな文字列で、パスワードと比べて次の利点があります。

|              | パスワード                    | トークン                           |
| ------------ | ----------------------------- | ---------------------------------- |
| 使える範囲   | アカウントのすべて            | 必要な権限だけに絞れる             |
| 有効期限     | なし（変えるまで有効）        | 設定できる                         |
| 漏れたとき   | アカウントを乗っ取られる      | そのトークンだけを無効にすればよい |
| 2FA との関係 | Git の操作では 2FA を通せない | 発行するときに 2FA を通している    |

ネット上の古い記事に「push のときにパスワードを入力する」と書かれていても、今の GitHub ではその方法は使えません。

---

<a id="https-ssh"></a>
## 3. HTTPS と SSH

Git が GitHub と通信する方法（プロトコル）には、主に HTTPS と SSH の2つがあります。どちらを使うかは、**リモートの URL の形** で決まります。

|                | HTTPS（この教材で使う方法）                                            | SSH                                                |
| -------------- | ---------------------------------------------------------------------- | -------------------------------------------------- |
| URL の形       | `https://github.com/<GitHubユーザー名>/my-profile.git`                 | `git@github.com:<GitHubユーザー名>/my-profile.git` |
| 認証に使うもの | トークン（GCM が自動で取得・保存）                                     | SSH 鍵（自分で作って GitHub に登録）               |
| 最初の準備     | ほぼ不要（初回にブラウザで承認するだけ）                               | 鍵の作成・登録が必要                               |
| ネットワーク   | 通常の Web と同じ 443 番ポート。学校や会社のネットワークでも通りやすい | 22 番ポート。ネットワークによっては制限されている  |

今使っている URL は次のコマンドで確かめられます。

```bash
cd ~/git-practice/my-profile
git remote -v
```

```text
origin  https://github.com/<GitHubユーザー名>/my-profile.git (fetch)
origin  https://github.com/<GitHubユーザー名>/my-profile.git (push)
```

`https://` で始まっていれば HTTPS です。GitHub Docs は、HTTPS で使う場合は GCM などに資格情報を覚えさせる方法を案内しており、GCM を使えばトークンを自分で作って保存する必要がないと説明しています（出典：[GitHub Docs - Caching your GitHub credentials in Git](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git)）。

---

<a id="gcm"></a>
## 4. Git Credential Manager（GCM）のしくみ

### 資格情報ヘルパーという考え方

Git 本体は、認証情報（ユーザー名とトークンなど。**資格情報（credential）** と呼びます）を自分で保存しません。代わりに、**資格情報ヘルパー（credential helper）** と呼ばれる外部のプログラムに「この接続先の資格情報をちょうだい」と頼みます（出典：[gitcredentials](https://git-scm.com/docs/gitcredentials)）。

Git for Windows のインストーラーで「Git Credential Manager」を選ぶと、system の設定に `credential.helper=manager` が書き込まれ、GCM がヘルパーとして使われるようになります。

```bash
git config --show-origin --get-all credential.helper
```

```text
file:C:/Program Files/Git/etc/gitconfig	manager
```

GCM のバージョンは次のコマンドで確かめられます。

```bash
git credential-manager --version
```

### 初めて GitHub と通信するとき

2日目のクローンで起きていたことを図にすると、次のようになります。

```text
 あなた          Git                GCM                Windows の          ブラウザ／GitHub
                                                       資格情報マネージャー
   │ git clone     │                  │                     │                    │
   ├──────────────▶│ 「github.com の  │                     │                    │
   │               │  資格情報を」(get)│                     │                    │
   │               ├─────────────────▶│ 保存されている？     │                    │
   │               │                  ├────────────────────▶│                    │
   │               │                  │◀──── ない ──────────┤                    │
   │               │                  │ 「Connect to GitHub」の画面を表示         │
   │ Sign in with your browser を押す  │                     │                    │
   ├─────────────────────────────────▶│ ブラウザで GitHub の承認ページを開く ─────▶│
   │ ブラウザでサインイン（2FA）して承認 ─────────────────────────────────────────▶│
   │               │                  │◀──────── トークンを発行（OAuth）─────────┤
   │               │◀── ユーザー名と ─┤                     │                    │
   │               │    トークン       │                     │                    │
   │               │ GitHub に接続して clone ─────────────────────────────────────▶│
   │               │ 成功したので保存を依頼(store)           │                    │
   │               ├─────────────────▶│ 保存する ──────────▶│                    │
   │◀── 完了 ───────┤                  │                     │                    │
```

ポイントは次のとおりです。

1. **パスワードを Git に入力していない**：サインインと 2FA はブラウザの中で、GitHub のサイトに対して行っています。
2. **GCM が受け取るのはトークン**：GitHub は GCM という「アプリ」に対して、あなたの代わりに Git の操作をする許可（OAuth：アプリに権限を委ねるしくみ）を与え、トークンを発行します。
3. **トークンは Windows の資格情報マネージャーに保存される**：GCM は Windows では「Windows 資格情報マネージャー（Windows Credential Manager）」を既定の保存場所として使います（出典：[GCM Docs - Credential stores](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md)）。ここは Windows が暗号化して管理する場所で、ファイルとしてそのまま読める場所ではありません。

画面の「Connect to GitHub」「Sign in with your browser」（執筆時点の表示です）のほかに、「Sign in with a code」（別の端末でコードを入力する方法）や「Token」タブ（PAT を貼り付ける方法）も選べます。

### 2回目以降

```text
 Git ──「github.com の資格情報を」──▶ GCM ──▶ 資格情報マネージャー
 Git ◀──── 保存済みのトークン ──────── GCM ◀──┘
 Git ── トークンを付けて GitHub に接続 ──▶ 成功
```

保存済みのトークンがあるので、画面は何も出ずに push や pull が終わります。

### 認証に失敗したとき

GitHub から「このトークンは使えない」と返されると（GitHub 側でトークンが取り消された場合など）、Git は GCM に **その資格情報を消すよう依頼（erase）** します。そのため、次の操作では再びブラウザでの承認画面が出ます。

Git と資格情報ヘルパーのやりとりは、`get`（ちょうだい）・`store`（保存して）・`erase`（消して）の3種類だけです。GCM のドキュメントにも「これらは Git とのやりとり用で、自分で実行する必要はない」と書かれています（出典：[GCM Docs - Command-line usage](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/usage.md)）。

---

<a id="windows-credential-manager"></a>
## 5. 保存された資格情報を見る

### Windows の資格情報マネージャーで見る

1. Windows のスタートメニューで「資格情報マネージャー」と入力して開きます。
2. 「Windows 資格情報」を選びます。
3. 「汎用資格情報」の一覧に、**`git:https://github.com`** という項目があります（執筆時点の表示です）。

この項目を開くと、ユーザー名（GitHub ユーザー名）が表示されます。トークンそのものは表示されません。

### GCM のコマンドで見る

GCM には、GitHub のアカウントを管理するコマンドがあります（出典：[GCM Docs - Multiple users](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/multiple-users.md)）。

```bash
git credential-manager github list
```

```text
hydr4
```

（保存されている GitHub アカウントのユーザー名が表示されます。人によって違います）

### GitHub 側で見る

GCM に与えた許可は、GitHub のサイトでも確認できます。右上のアイコン → **Settings** → 左のメニューの **Applications** → **Authorized OAuth Apps** タブに **Git Credential Manager** が表示されます（執筆時点の表示です）。ここで **Revoke**（取り消し）すると、GCM が受け取ったトークンはすべて使えなくなり、次に Git で GitHub と通信するときに再び承認画面が出ます（出典：[GCM Docs - FAQ](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/faq.md)）。

> [!TIP]
> パソコンをなくした、人に貸していた、など「このパソコンからの push を止めたい」ときは、GitHub 側で Revoke するのがいちばん確実です。

---

<a id="2fa"></a>
## 6. 2要素認証（2FA）とリカバリーコード

### なぜ 2FA が必要なのか

2要素認証（2FA：Two-Factor Authentication）は、パスワード（知っているもの）に加えて、スマートフォンの認証アプリが表示する6桁のコード（持っているもの）でも本人確認する方法です。パスワードが漏れても、スマートフォンがなければログインできません。

GitHub は 2023年3月から、コードを投稿するユーザーに順次 2FA を必須にしています（出典：[GitHub Docs - About mandatory two-factor authentication](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-mandatory-two-factor-authentication)）。同じページでは、主な方法として認証アプリ（TOTP アプリ）をすすめ、パスキー・セキュリティキー・GitHub Mobile は予備の方法として位置づけています。

### 2FA と Git の操作の関係

2FA を設定しても、**push や pull のたびに6桁のコードを入力する必要はありません**。2FA が求められるのは、ブラウザでサインインするとき（GCM の初回承認を含む）だけです。GCM が受け取ったトークンは、2FA を通ったあとに発行されたものなので、そのまま Git の操作に使えます。

### リカバリーコード

リカバリーコード（recovery codes）は、スマートフォンをなくしたり壊したりして 2FA のコードを受け取れなくなったときに、**代わりに1回だけ使えるコード** です。GitHub では16個発行され、1つのコードは1回しか使えません。新しく発行し直すと古いコードは無効になります（出典：[GitHub Docs - Configuring two-factor authentication recovery methods](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication-recovery-methods)）。

保管のしかたの注意です。

- パスワードマネージャーに保存するか、印刷して安全な場所にしまいます。
- **Git のリポジトリの中に保存しない**（コミットすると履歴に残り続けます）。
- チャットや Issue に貼らない。

> [!CAUTION]
> 2FA の手段とリカバリーコードの両方を失うと、アカウントを取り戻せなくなることがあります。スマートフォンの機種変更の前には、認証アプリのデータを引き継ぐ設定を確認してください。

---

<a id="pat"></a>
## 7. 個人アクセストークン（PAT）

個人アクセストークン（PAT：Personal Access Token）は、**自分で発行して、パスワードの代わりに使うトークン** です。GCM を使っていれば普段は必要ありませんが、次のような場面で使います。

- GCM が使えない環境（ブラウザを開けないサーバーなど）で HTTPS の Git 操作をするとき
- プログラムやツールから GitHub の API を使うとき

### 2種類の PAT

| 種類                                                       | 特徴                                                                 |
| ---------------------------------------------------------- | -------------------------------------------------------------------- |
| Fine-grained personal access token（細かい権限のトークン） | 対象のリポジトリと権限を細かく指定できる。GitHub が推奨              |
| Personal access token (classic)                            | 自分がアクセスできるすべてのリポジトリに効く、大まかな権限。古い方式 |

作成する場所は、右上のアイコン → **Settings** → **Developer settings** → **Personal access tokens** です（執筆時点の表示です。出典：[GitHub Docs - Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)）。

使うときは、Git がパスワードを聞いてきたところにトークンを貼り付けます。GCM を使っている場合は、「Connect to GitHub」画面の「Token」タブに貼り付けます。

### トークンの種類は先頭の文字でわかる

GitHub のトークンは、種類ごとに決まった文字で始まります（出典：[GitHub Docs - About authentication to GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github)）。

| 先頭          | 種類                                                 |
| ------------- | ---------------------------------------------------- |
| `github_pat_` | Fine-grained personal access token                   |
| `ghp_`        | Personal access token (classic)                      |
| `gho_`        | OAuth アクセストークン（GCM が受け取るのはこの種類） |

> [!CAUTION]
> トークンはパスワードと同じです。ファイルに書いてコミットしたり、チャットや Issue に貼ったりしないでください。万一漏れたら、すぐに GitHub の設定画面でそのトークンを削除（無効化）します。作るときは必ず有効期限（Expiration）を設定しましょう。

---

<a id="switch-account"></a>
## 8. アカウントの切り替えと、資格情報の削除

「別の GitHub アカウントで push したい」「間違ったアカウントで承認してしまった」「`Authentication failed` が出続ける」といったときは、保存された資格情報を消して、承認し直します。

### 方法1：GCM のコマンドで消す

`<GitHubユーザー名>` の部分は、かっこごと置き換えてから実行します（消したいアカウントのユーザー名を指定します）。

```bash
git credential-manager github logout <GitHubユーザー名>
```

### 方法2：Windows の資格情報マネージャーで消す

1. スタートメニューで「資格情報マネージャー」を開きます。
2. 「Windows 資格情報」→「汎用資格情報」の `git:https://github.com` を開きます。
3. 「削除」を選びます。

GitHub Docs でも、間違った資格情報が保存されていると Git が GitHub にアクセスできなくなるので、この項目を削除するよう案内しています（出典：[GitHub Docs - Caching your GitHub credentials in Git](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git)）。

どちらの方法でも、次に `git push` などをすると、もう一度「Connect to GitHub」の画面が出ます。**ブラウザで正しいアカウントにサインインしていることを確かめてから** 承認してください（ブラウザ側で別のアカウントにログインしたままだと、そのアカウントで承認されてしまいます）。

### 発展：複数のアカウントを使い分ける

個人用と学校用など、1台のパソコンで複数の GitHub アカウントを使う場合、GCM は複数のアカウントを保存でき、どれを使うか選ぶ画面を出します。リポジトリごとに使うアカウントを固定したいときは、URL にユーザー名を入れます（出典：[GCM Docs - Multiple users](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/multiple-users.md)）。

`<GitHubユーザー名>` の部分は、かっこごと置き換えてから実行します。

```bash
git remote set-url origin https://<GitHubユーザー名>@github.com/<GitHubユーザー名>/my-profile.git
```

1つ目の `<GitHubユーザー名>` が「どのアカウントで認証するか」、2つ目が「どのアカウントのリポジトリか」です（この例ではどちらも自分）。この勉強会では、1つのアカウントだけを使うので必要ありません。

関連レシピ：[setup-05 保存された GitHub の認証情報を消して入れ直したい](../recipes/setup.md#setup-05)、[trouble-06 `Authentication failed` や `403` で clone・push できない](../recipes/troubleshooting.md#trouble-06)

### 403 エラーの読み方

`Authentication failed`（認証に失敗）と `403`（権限がない）は、似ていますが意味が違います。

| メッセージ                              | 意味                                                             | よくある原因                                                             |
| --------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `Authentication failed`                 | 「あなたが誰か」を確認できなかった                               | トークンが無効になった、承認を途中でやめた                               |
| `403`（`Permission ... denied to ...`） | 「あなたが誰か」はわかったが、そのリポジトリに書き込む権限がない | 別のアカウントで承認している、チームリポジトリの招待をまだ承認していない |

403 のメッセージにはユーザー名が含まれるので、**そこに表示されたユーザー名が自分の意図したアカウントか** を確認するのが解決の近道です。

---

<a id="ssh"></a>
## 9. 発展：SSH 鍵による認証（紹介のみ）

この教材では扱いませんが、SSH という方法もあります。簡単な流れだけ紹介します（詳しくは [GitHub Docs - Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)）。

```text
 自分のパソコン                                GitHub
 ┌──────────────────────┐                     ┌──────────────────────┐
 │ 秘密鍵 id_ed25519     │                     │ 登録した公開鍵        │
 │ （絶対に人に渡さない） │ ── 鍵で署名して接続 ─▶│ id_ed25519.pub        │
 │ 公開鍵 id_ed25519.pub │                     │ （Settings → SSH and  │
 └──────────────────────┘                     │   GPG keys に登録）   │
                                               └──────────────────────┘
```

1. `ssh-keygen -t ed25519 -C "メールアドレス"` で、鍵のペア（秘密鍵と公開鍵）を作ります。
2. 公開鍵（`.pub` の付いたファイル）の中身を、GitHub の Settings → **SSH and GPG keys** に登録します。
3. リモートの URL を `git@github.com:...` の形にします。

SSH の利点は、トークンの期限切れを気にしなくてよいことや、GCM を使えない環境でも使えることです。一方で、鍵の管理（バックアップ、パスフレーズ、パソコンごとの登録）が必要で、ネットワークによっては 22 番ポートが使えないこともあります。HTTPS と GCM で困っていなければ、無理に切り替える必要はありません。

---

## まとめ

- Git の操作では、2021年8月からパスワードが使えない。代わりにトークンか SSH 鍵を使う。
- この教材は HTTPS ＋ GCM。初回だけブラウザで承認すると、GCM が OAuth のトークンを受け取り、Windows の資格情報マネージャーに保存する。
- Git と GCM のやりとりは `get` / `store` / `erase` の3種類。失敗すると自動で消され、次回また承認画面が出る。
- 2FA はブラウザでのサインインのときだけ。リカバリーコードはリポジトリやチャットに置かない。
- アカウントを切り替えたいときは `git credential-manager github logout` か、資格情報マネージャーで `git:https://github.com` を削除する。

## 関連ページ

- [2日目：GitHub アカウントと認証](../docs/day02-github-account.md)（「2要素認証（2FA）を設定する」「HTTPS と Git Credential Manager のしくみ（ざっくり）」）
- [8日目：GitHub とつなぐ](../docs/day08-remote-github.md)（push するとき）
- [9日目：チームの準備と Issue](../docs/day09-team-kickoff.md)（チームリポジトリへの招待）
- [レシピ setup-05 保存された GitHub の認証情報を消して入れ直したい](../recipes/setup.md#setup-05)
- [レシピ trouble-06 `Authentication failed` や `403` で clone・push できない](../recipes/troubleshooting.md#trouble-06)
- [レシピ trouble-12 `GH007: Your push would publish a private email address` と出る](../recipes/troubleshooting.md#trouble-12)

## 参考資料

- GitHub Blog - Token authentication requirements for Git operations：<https://github.blog/security/application-security/token-authentication-requirements-for-git-operations/>
- GitHub Docs - About authentication to GitHub：<https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github>
- GitHub Docs - Caching your GitHub credentials in Git：<https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git>
- GitHub Docs - About mandatory two-factor authentication：<https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-mandatory-two-factor-authentication>
- GitHub Docs - Configuring two-factor authentication recovery methods：<https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication-recovery-methods>
- GitHub Docs - Managing your personal access tokens：<https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens>
- GitHub Docs - Connecting to GitHub with SSH：<https://docs.github.com/en/authentication/connecting-to-github-with-ssh>
- Git Credential Manager（リポジトリ）：<https://github.com/git-ecosystem/git-credential-manager>
  - Credential stores：<https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md>
  - Command-line usage：<https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/usage.md>
  - Multiple users：<https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/multiple-users.md>
  - FAQ：<https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/faq.md>
- gitcredentials（Git の資格情報ヘルパーのしくみ）：<https://git-scm.com/docs/gitcredentials>

---

[Appendix の目次](README.md) ｜ [README（全体の地図）](../README.md)
