# 1日目の演習：セットアップ確認

説明ページ：[1日目：Git のインストールと初期設定](../../docs/day01-install-git.md)

## 目的

Git と VS Code の準備ができているかを、コマンドの結果で自分で確かめます。

## 所要時間の目安

10〜15分

## 手順

VS Code のターミナル（Git Bash）で、次の順に実行します。

1. ターミナルが Git Bash であることを確認します。

   ```bash
   echo $SHELL
   ```

   ```text
   /usr/bin/bash
   ```

   > 表示は環境によって少し違うことがあります。ターミナル右上のタブに `bash` や `Git Bash` と出ていればOKです。

2. Git のバージョンを確認します。

   ```bash
   git --version
   ```

   ```text
   git version 2.xx.x.windows.x
   ```

   > バージョン番号は人によって違います。

3. 初期設定を確認します。

   ```bash
   git config --global --list
   ```

4. 練習用フォルダがあることを確認します。

   ```bash
   ls -d ~/git-practice
   ```

   ```text
   /c/Users/<Windowsのユーザー名>/git-practice
   ```

## 完了条件

- [ ] `git --version` で `git version 2.` から始まる表示が出る
- [ ] VS Code のターミナルが Git Bash（`bash`）である
- [ ] `git config --global --list` の結果に、次の6項目が入っている
  - `user.name`
  - `user.email`
  - `init.defaultbranch=main`
  - `core.editor=code --wait`
  - `core.quotepath=false`
  - `pull.rebase=false`
- [ ] `ls -d ~/git-practice` でフォルダが表示される（OneDrive 配下ではない）

## ヒント

- `git` が見つからない（`command not found`）ときは、VS Code を一度閉じて開き直してください。それでもだめなら、Git のインストールをやり直します。
- 設定が足りないときは、1日目のページの「Git の初期設定をする」のコマンドをもう一度実行すれば上書きされます。
- `~/git-practice` がないときは `mkdir ~/git-practice` で作ります。
