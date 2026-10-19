# 2日目の演習：GitHub の準備と教材のクローン

説明ページ：[2日目：GitHub アカウントと認証](../../docs/day02-github-account.md)

## 目的

GitHub アカウントを安全に使える状態にし、教材の自分用コピーを手元にクローンして、認証が通ることを確かめます。

## 所要時間の目安

30〜40分（アカウント作成を含めると60分程度）

## 手順

1. GitHub アカウントを作り、2要素認証（2FA）を有効にします。リカバリーコードは安全な場所に保管します。
2. GitHub の **Settings** → **Emails** で、メールアドレスを公開しない設定（**Keep my email addresses private**）にします。
3. noreply アドレス（`ID+ユーザー名@users.noreply.github.com` の形）を確認し、Git の設定に反映します。GitHub の **Emails** 画面に表示されたアドレスをコピーし、`"ここにnoreplyアドレスを貼り付け"` の部分に貼り付けてから実行します（`"` は残します）。

   ```bash
   git config --global user.email "ここにnoreplyアドレスを貼り付け"
   ```

4. 運営者のテンプレートリポジトリで **Use this template** → **Create a new repository** を選び、名前を `gitlearn`、公開範囲を **Private** にして作成します。
5. 自分の `gitlearn` を `~/git-practice` にクローンします（クローンの意味は8日目で学びます）。説明ページの手順で VS Code からクローン済みなら、この手順は不要です（`fatal: destination path 'gitlearn' already exists and is not an empty directory.` と出たら、クローン済みです）。

   `<...>` の部分は、かっこごと置き換えてから実行します。

   ```bash
   cd ~/git-practice
   git clone https://github.com/<GitHubユーザー名>/gitlearn.git
   ```

   初回はブラウザが開いてサインインを求められます。画面の指示に従って承認します。

6. クローンしたフォルダがあることを確認します。

   ```bash
   ls ~/git-practice/gitlearn
   ```

7. VS Code で `~/git-practice/gitlearn` を開き、`README.md` をプレビュー（`Ctrl+Shift+V`）します。

## 完了条件

- [ ] GitHub アカウントで 2FA が有効になっている
- [ ] リカバリーコードを保管した（このリポジトリや Issue には貼らない）
- [ ] 次のコマンドの結果が `noreply.github.com` を含むアドレスになっている

  ```bash
  git config --global user.email
  ```

- [ ] 自分のアカウントに Private の `gitlearn` リポジトリがある
- [ ] `~/git-practice/gitlearn` がある（クローンで認証が通った）
- [ ] VS Code で `README.md` をプレビューできた

## ヒント

- 認証のウィンドウが出ないときは、[レシピ集のトラブル対応](../../recipes/troubleshooting.md) を見てください。
- ユーザー名やメールアドレスのつづりに注意してください。`git clone` の URL の `<GitHubユーザー名>` は、大文字小文字も含めて正確に入力します。
- Private のリポジトリは、他の人からは見えません。それで正常です。
