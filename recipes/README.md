# 逆引きレシピ集

[README（全体の地図）](../README.md) ｜ [Appendix（詳しい解説）](../appendix/README.md) ｜ [演習の一覧](../exercises/README.md)

「〜したいときは？」「このエラーが出たら？」から引ける、逆引きのレシピ集です。1つのレシピに、次の項目をまとめています。

- **こんなとき**：どんな状況で使うレシピか（エラーのレシピでは、表示されるメッセージと原因）
- **Git Bash**：VS Code のターミナル（Git Bash）で実行するコマンドと、出力の例
- **VS Code** ／ **GitHub**：画面での操作（GUI の操作がないときは、その旨を書いています）
- **注意点**：やってはいけないこと、つまずきやすい点
- **関連**：説明ページ（日別）、Appendix、ほかのレシピへのリンク

> [!TIP]
> エラーメッセージが出たときは、まず [エラーメッセージ別](troubleshooting.md) のページを開き、`Ctrl+F` でメッセージの一部（`rejected`、`fatal: not a git repository` など）を検索してください。

> [!NOTE]
> コマンド例の `<GitHubユーザー名>` のような `<...>` の部分は、かっこごと自分の内容に置き換えてから実行します。画面の説明は執筆時点の表示です。

## ファイルの一覧

| ファイル | 内容 | 件数 |
|---|---|---|
| [初期設定・環境](setup.md) | Git のインストール後の設定、ターミナル、認証情報など | 7件 |
| [記録する・確かめる](basics.md) | コミットして記録する、状態・差分・履歴を確かめる | 8件 |
| [取り消し・やり直し](undo.md) | 変更やコミットを取り消す・やり直す | 8件 |
| [ブランチ・マージ・コンフリクト](branch.md) | ブランチの作成・切り替え・マージ・コンフリクト | 8件 |
| [GitHub とのやりとり](remote.md) | clone・push・pull・fetch | 7件 |
| [Issue・PR・レビュー](github.md) | GitHub の画面での操作 | 12件 |
| [エラーメッセージ別](troubleshooting.md) | 表示されたエラーメッセージから探す | 12件 |

全 62 件です。

## 日ごとに関係するレシピ

その日の説明ページで扱う内容に関係するレシピです。

| 日 | レシピ |
|---|---|
| [1日目：Git のインストールと初期設定](../docs/day01-install-git.md) | [setup-01](setup.md#setup-01)、[setup-02](setup.md#setup-02)、[setup-03](setup.md#setup-03)、[setup-04](setup.md#setup-04)、[setup-07](setup.md#setup-07)、[trouble-01](troubleshooting.md#trouble-01) |
| [2日目：GitHub アカウントと認証](../docs/day02-github-account.md) | [github-01](github.md#github-01)、[remote-01](remote.md#remote-01)、[setup-05](setup.md#setup-05)、[trouble-06](troubleshooting.md#trouble-06)、[trouble-12](troubleshooting.md#trouble-12) |
| [3日目：はじめてのコミット](../docs/day03-first-commit.md) | [basics-01](basics.md#basics-01)、[basics-02](basics.md#basics-02)、[basics-03](basics.md#basics-03)、[basics-05](basics.md#basics-05)、[trouble-02](troubleshooting.md#trouble-02)、[trouble-03](troubleshooting.md#trouble-03)、[trouble-09](troubleshooting.md#trouble-09) |
| [4日目：差分・履歴・.gitignore](../docs/day04-diff-log-ignore.md) | [basics-04](basics.md#basics-04)、[basics-05](basics.md#basics-05)、[basics-06](basics.md#basics-06)、[basics-07](basics.md#basics-07)、[basics-08](basics.md#basics-08)、[trouble-11](troubleshooting.md#trouble-11) |
| [5日目：取り消しとやり直し](../docs/day05-undo.md) | [undo-01](undo.md#undo-01)、[undo-02](undo.md#undo-02)、[undo-03](undo.md#undo-03)、[undo-04](undo.md#undo-04)、[undo-05](undo.md#undo-05)、[undo-06](undo.md#undo-06)、[undo-07](undo.md#undo-07)、[undo-08](undo.md#undo-08) |
| [6日目：ブランチ](../docs/day06-branch.md) | [branch-01](branch.md#branch-01)、[branch-02](branch.md#branch-02)、[branch-03](branch.md#branch-03)、[branch-04](branch.md#branch-04)、[branch-05](branch.md#branch-05)、[branch-07](branch.md#branch-07) |
| [7日目：マージとコンフリクト](../docs/day07-merge-conflict.md) | [branch-05](branch.md#branch-05)、[branch-06](branch.md#branch-06)、[trouble-10](troubleshooting.md#trouble-10) |
| [8日目：GitHub とつなぐ](../docs/day08-remote-github.md) | [remote-01](remote.md#remote-01)、[remote-02](remote.md#remote-02)、[remote-03](remote.md#remote-03)、[remote-04](remote.md#remote-04)、[remote-05](remote.md#remote-05)、[remote-06](remote.md#remote-06)、[trouble-04](troubleshooting.md#trouble-04)、[trouble-07](troubleshooting.md#trouble-07)、[trouble-08](troubleshooting.md#trouble-08) |
| [9日目：チームの準備と Issue](../docs/day09-team-kickoff.md) | [github-02](github.md#github-02)、[github-04](github.md#github-04)、[remote-01](remote.md#remote-01) |
| [10日目：はじめてのプルリクエスト](../docs/day10-pull-request.md) | [remote-04](remote.md#remote-04)、[github-05](github.md#github-05)、[github-06](github.md#github-06)、[github-10](github.md#github-10)、[branch-04](branch.md#branch-04) |
| [11日目：コードレビュー](../docs/day11-code-review.md) | [github-07](github.md#github-07)、[github-08](github.md#github-08)、[remote-07](remote.md#remote-07) |
| [12日目：チームでのコンフリクト](../docs/day12-team-conflict.md) | [branch-06](branch.md#branch-06)、[branch-08](branch.md#branch-08)、[github-09](github.md#github-09)、[trouble-05](troubleshooting.md#trouble-05) |
| [13日目：最終課題に取り組む](../docs/day13-final-project.md) | [branch-08](branch.md#branch-08)、[github-04](github.md#github-04)、[github-05](github.md#github-05)、[github-12](github.md#github-12) |
| [14日目：完成・リリース・ふりかえり](../docs/day14-release-retrospective.md) | [github-11](github.md#github-11)、[branch-04](branch.md#branch-04) |

---

## 全レシピの一覧

### 初期設定・環境（7件）

ファイル：[setup.md](setup.md)

| ID | やりたいこと |
|---|---|
| [setup-01](setup.md#setup-01) | Git のバージョンを確かめたい・最新版に更新したい |
| [setup-02](setup.md#setup-02) | 名前とメールアドレスの設定を確認・変更したい（どこで設定されたかも調べる） |
| [setup-03](setup.md#setup-03) | コミットメッセージを書くエディタを VS Code にしたい |
| [setup-04](setup.md#setup-04) | VS Code のターミナルを Git Bash にしたい |
| [setup-05](setup.md#setup-05) | 保存された GitHub の認証情報を消して入れ直したい（アカウントの切り替え） |
| [setup-06](setup.md#setup-06) | 日本語のファイル名が `"\343\201..."` のように表示されるのを直したい |
| [setup-07](setup.md#setup-07) | 練習用・作業用のフォルダはどこに作ればいい？（OneDrive を避ける） |

### 記録する・確かめる（8件）

ファイル：[basics.md](basics.md)

| ID | やりたいこと |
|---|---|
| [basics-01](basics.md#basics-01) | フォルダを Git で管理し始めたい |
| [basics-02](basics.md#basics-02) | 今の状態（何が変わったか）を確認したい |
| [basics-03](basics.md#basics-03) | 変更をステージしてコミットしたい（全部／一部のファイルだけ） |
| [basics-04](basics.md#basics-04) | 変更内容（差分）を見たい |
| [basics-05](basics.md#basics-05) | コミット履歴を見やすく表示したい（1行表示・グラフ・ファイルで絞り込み） |
| [basics-06](basics.md#basics-06) | あるコミットで何を変えたかを見たい |
| [basics-07](basics.md#basics-07) | 管理したくないファイルを無視したい（.gitignore） |
| [basics-08](basics.md#basics-08) | コミット済みのファイルを、手元に残したまま管理対象から外したい |

### 取り消し・やり直し（8件）

ファイル：[undo.md](undo.md)

| ID | やりたいこと |
|---|---|
| [undo-01](undo.md#undo-01) | 編集中のファイルを最後のコミットの状態に戻したい |
| [undo-02](undo.md#undo-02) | ステージを取り消したい |
| [undo-03](undo.md#undo-03) | 直前のコミットを直したい（メッセージの修正・ファイルの入れ忘れ） |
| [undo-04](undo.md#undo-04) | 直前のコミットを取り消したい（まだ push していない） |
| [undo-05](undo.md#undo-05) | push 済みのコミットを打ち消したい |
| [undo-06](undo.md#undo-06) | ファイルを過去のコミットの状態に戻したい |
| [undo-07](undo.md#undo-07) | 作業途中の変更を一時的に退避したい（stash） |
| [undo-08](undo.md#undo-08) | 消してしまったコミットやブランチを取り戻したい（reflog） |

### ブランチ・マージ・コンフリクト（8件）

ファイル：[branch.md](branch.md)

| ID | やりたいこと |
|---|---|
| [branch-01](branch.md#branch-01) | ブランチの一覧と、今いるブランチを確認したい |
| [branch-02](branch.md#branch-02) | 新しいブランチを作って切り替えたい |
| [branch-03](branch.md#branch-03) | 未コミットの変更があってブランチを切り替えられない |
| [branch-04](branch.md#branch-04) | ブランチを削除したい（手元・GitHub・追跡ブランチ） |
| [branch-05](branch.md#branch-05) | ブランチを取り込みたい（マージ） |
| [branch-06](branch.md#branch-06) | コンフリクトを解決したい／マージをやめたい |
| [branch-07](branch.md#branch-07) | 間違えて main で作業してしまった変更を、新しいブランチに移したい |
| [branch-08](branch.md#branch-08) | 作業中のブランチに main の最新を取り込みたい |

### GitHub とのやりとり（7件）

ファイル：[remote.md](remote.md)

| ID | やりたいこと |
|---|---|
| [remote-01](remote.md#remote-01) | GitHub のリポジトリを手元にコピーしたい（clone） |
| [remote-02](remote.md#remote-02) | 手元で作ったリポジトリを GitHub に上げたい |
| [remote-03](remote.md#remote-03) | 登録されているリモートを確認・変更したい |
| [remote-04](remote.md#remote-04) | 変更を GitHub に送りたい（push）／新しいブランチを初めて送りたい |
| [remote-05](remote.md#remote-05) | GitHub の最新を取り込みたい（pull） |
| [remote-06](remote.md#remote-06) | 取り込む前に、何が変わったかを確認したい（fetch） |
| [remote-07](remote.md#remote-07) | 他の人のブランチ（PR）を手元で確かめたい |

### Issue・PR・レビュー（12件）

ファイル：[github.md](github.md)

| ID | やりたいこと |
|---|---|
| [github-01](github.md#github-01) | テンプレートから自分のリポジトリを作りたい |
| [github-02](github.md#github-02) | リポジトリにメンバーを招待したい・招待を承認したい |
| [github-03](github.md#github-03) | フォークして、元のリポジトリに PR を送りたい |
| [github-04](github.md#github-04) | Issue を作って、担当者とラベルを付けたい |
| [github-05](github.md#github-05) | プルリクエストを作りたい |
| [github-06](github.md#github-06) | PR と Issue を紐づけて、マージ時に Issue を自動で閉じたい |
| [github-07](github.md#github-07) | PR をレビューしたい（行コメント・修正提案・承認） |
| [github-08](github.md#github-08) | レビューの指摘を反映して PR を更新したい |
| [github-09](github.md#github-09) | PR のコンフリクトを GitHub 上で解決したい |
| [github-10](github.md#github-10) | PR をマージしたい（マージ方法の違い） |
| [github-11](github.md#github-11) | タグを付けて Release を作りたい |
| [github-12](github.md#github-12) | GitHub 上でファイルを直接編集したい |

### エラーメッセージ別（12件）

ファイル：[troubleshooting.md](troubleshooting.md)

見出しにはエラーメッセージの英語の原文を含めています。

| ID | やりたいこと |
|---|---|
| [trouble-01](troubleshooting.md#trouble-01) | `git: command not found`（または「'git' は…認識されていません」）と出る |
| [trouble-02](troubleshooting.md#trouble-02) | `Author identity unknown` と出てコミットできない |
| [trouble-03](troubleshooting.md#trouble-03) | `fatal: not a git repository` と出る |
| [trouble-04](troubleshooting.md#trouble-04) | push すると `! [rejected]`（`fetch first` / `non-fast-forward`）と出る |
| [trouble-05](troubleshooting.md#trouble-05) | `Your local changes to the following files would be overwritten` と出る |
| [trouble-06](troubleshooting.md#trouble-06) | `Authentication failed` や `403` で clone・push できない |
| [trouble-07](troubleshooting.md#trouble-07) | `error: src refspec main does not match any` と出る |
| [trouble-08](troubleshooting.md#trouble-08) | `Need to specify how to reconcile divergent branches` と出る |
| [trouble-09](troubleshooting.md#trouble-09) | `git log` などの画面から抜けられない（`:` や `(END)` が出ている） |
| [trouble-10](troubleshooting.md#trouble-10) | コミットや pull の途中で見慣れないエディタ（Vim）が開いた |
| [trouble-11](troubleshooting.md#trouble-11) | `LF will be replaced by CRLF` という警告が出る |
| [trouble-12](troubleshooting.md#trouble-12) | `GH007: Your push would publish a private email address` と出る |

---

[README（全体の地図）](../README.md) ｜ [Appendix（詳しい解説）](../appendix/README.md)
