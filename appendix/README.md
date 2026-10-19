# Appendix（詳しい解説）

[README（全体の地図）](../README.md) ｜ [レシピ集](../recipes/README.md)

本編（`docs/` の各日のページ）では、まず「使えるようになる」ことを優先して、しくみの説明をかなり省略しています。この Appendix は、**本編を読んで「どうしてこうなるんだろう？」と気になった人** のための詳しい解説です。

- 本編を進めるために、Appendix を読む必要はありません。気になったときに、気になったページだけ読んでください。
- 各ページの冒頭に「この解説の対象（何日目を読んだ人向けか）」と「読む時間の目安」を書いています。対象の日より前に読むと、まだ学んでいない言葉が出てくることがあります。
- 本編の各ページの末尾「もっと知りたい人へ」から、関係する Appendix にリンクしています。

---

## ページの一覧

### 環境と準備（セットアップ編の後に）

| ページ | 内容 | 読むとよい時期 |
|---|---|---|
| [Git Bash とターミナルの基本](git-bash-basics.md) | ターミナルとシェルの関係、Git Bash・PowerShell・コマンドプロンプトの違い、パスの書き方（`~`、`/c/Users/...`）、よく使うコマンド、Tab 補完・履歴・コピー＆ペースト、`Ctrl+C`、ページャー（`less`）の操作 | 1日目の後 |
| [Git の設定（git config）のしくみ](git-config.md) | 設定の3階層（system / global / local）と優先順位、`--show-origin` で出どころを調べる方法、1日目に入れた6つの設定の意味、便利な追加設定、設定の消し方 | 1日目の後 |
| [改行コードと文字コード](line-endings-and-encoding.md) | CRLF と LF、`core.autocrlf` とインストーラーの選択肢、この教材の `.gitattributes` の意味、`LF will be replaced by CRLF` 警告、UTF-8 と BOM、`core.quotepath` と日本語のファイル名 | 1日目の後（4日目の後に読み直すとさらによくわかります） |
| [GitHub の認証のしくみ](authentication.md) | パスワード認証の廃止、HTTPS と SSH、Git Credential Manager（GCM）が資格情報を取得・保存する流れ、2FA とリカバリーコード、個人アクセストークン（PAT）、アカウントの切り替え | 2日目の後（8日目の後にも） |

### Git のしくみ（ひとりで練習編の後に）

| ページ | 内容 | 読むとよい時期 |
|---|---|---|
| [3つの場所：ワーキングツリー・ステージ・リポジトリ](three-areas.md) | 3つの場所の役割、ファイルの4つの状態と移り変わり、`git status -s` の読み方、ステージがある理由、`git diff` / `--staged` / `HEAD` の違い | 3日目の後（4日目の後にも） |
| [Git の内部構造：.git フォルダとオブジェクト](git-internals.md) | `.git` フォルダの中身、blob・tree・commit、ハッシュ値（SHA-1／SHA-256）、`git cat-file` で中身を見る、スナップショット、ブランチと HEAD の正体 | 3日目の後（6日目の後に読み直すとさらによくわかります） |
| [よいコミットとレビューしやすい PR](commit-best-practices.md) | よいコミットの単位、メッセージの書き方（日本語の例）、Conventional Commits、レビューしやすい PR の大きさ | 4日目の後（11日目の後にも） |
| [取り消しの詳細：reset・revert・restore・reflog・stash・clean](undo-in-depth.md) | `reset` の3つのモードと3つの場所の関係、`revert` との違い、`restore` と `switch`（`checkout` が分かれた経緯）、`reflog`、`stash`、`clean`、push 後に履歴を書き換えてはいけない理由 | 5日目の後 |
| [ブランチとマージのしくみ](branches-and-merge.md) | ブランチ＝コミットを指すポインタ、HEAD と detached HEAD、マージベース、fast-forward と 3-way マージ、コンフリクトが起きる条件、`zdiff3`、VS Code のマージエディター | 6日目・7日目の後（12日目の後にも） |
| [リモートとリモート追跡ブランチ：fetch・pull・push のしくみ](remote-tracking.md) | `origin` と `origin/main`、上流ブランチ（`-u`）、`fetch` と `pull` の違い、`pull.rebase`、push が拒否される理由、`--force-with-lease`、`fetch --prune` | 8日目の後（10日目・12日目の後にも） |

### チーム開発（チーム開発編の後に）

| ページ | 内容 | 読むとよい時期 |
|---|---|---|
| [rebase：コミットを付け替えるしくみ](rebase.md) | rebase の動き（コミットの付け替え）、merge との比較、「共有したブランチは rebase しない」原則、rebase 中のコンフリクト、対話的 rebase、`pull --rebase` | 12日目・13日目の後 |
| [GitHub でのチーム開発：権限・ブランチ保護・マージ方法・Release](github-collaboration.md) | コラボレーター方式とフォーク方式、Organization と権限、ブランチ保護・ルールセット、PR のマージ方法3種、`Closes #` による自動リンク、Release とタグ、GitHub Pages・Actions の紹介 | 9〜11日目の後、14日目の後 |

---

## 何日目の後に、どのページを読むか

本編の各日から、次の Appendix にリンクしています。

| 日 | テーマ | 関連する Appendix |
|---|---|---|
| 1 | Git のインストールと初期設定 | [Git Bash とターミナル](git-bash-basics.md)、[git config](git-config.md)、[改行コードと文字コード](line-endings-and-encoding.md) |
| 2 | GitHub アカウントと認証 | [認証のしくみ](authentication.md) |
| 3 | はじめてのコミット | [3つの場所](three-areas.md)、[内部構造](git-internals.md) |
| 4 | 差分・履歴・.gitignore | [よいコミット](commit-best-practices.md)、[3つの場所](three-areas.md)、[改行コードと文字コード](line-endings-and-encoding.md) |
| 5 | 取り消しとやり直し | [取り消しの詳細](undo-in-depth.md) |
| 6 | ブランチ | [ブランチとマージ](branches-and-merge.md)、[内部構造](git-internals.md) |
| 7 | マージとコンフリクト | [ブランチとマージ](branches-and-merge.md) |
| 8 | GitHub とつなぐ | [リモート追跡ブランチ](remote-tracking.md)、[認証のしくみ](authentication.md) |
| 9 | チームの準備と Issue | [GitHub でのチーム開発](github-collaboration.md) |
| 10 | はじめてのプルリクエスト | [GitHub でのチーム開発](github-collaboration.md)、[リモート追跡ブランチ](remote-tracking.md) |
| 11 | コードレビュー | [よいコミット](commit-best-practices.md)、[GitHub でのチーム開発](github-collaboration.md) |
| 12 | チームでのコンフリクト | [ブランチとマージ](branches-and-merge.md)、[リモート追跡ブランチ](remote-tracking.md)、[rebase](rebase.md) |
| 13 | 最終課題に取り組む | [rebase](rebase.md)、[GitHub でのチーム開発](github-collaboration.md) |
| 14 | 完成・リリース・ふりかえり | このページ、[GitHub でのチーム開発](github-collaboration.md) |

---

## おすすめの読み方

目的に合わせて、次の順に読むと理解がつながります。

- **Git のしくみを根本から知りたい人**：[3つの場所](three-areas.md) → [内部構造](git-internals.md) → [ブランチとマージ](branches-and-merge.md) → [取り消しの詳細](undo-in-depth.md) → [リモート追跡ブランチ](remote-tracking.md) → [rebase](rebase.md)
- **自分のパソコンの環境で困ったことがある人**：[Git Bash とターミナル](git-bash-basics.md) → [git config](git-config.md) → [改行コードと文字コード](line-endings-and-encoding.md) → [認証のしくみ](authentication.md)
- **チームでの開発をもっとうまくやりたい人**：[よいコミット](commit-best-practices.md) → [GitHub でのチーム開発](github-collaboration.md) → [rebase](rebase.md)

すでに困っていることがあり、すぐに解決したいときは、Appendix より先に [レシピ集](../recipes/README.md) を見てください。レシピ集は「〜したい」「このエラーが出た」から引ける逆引きです。

---

## Appendix の読み方の約束

- **コマンドは Git Bash 用です**。本編と同じく、VS Code のターミナル（Git Bash）にコピー＆ペーストして実行できます。PowerShell との違いは [Git Bash とターミナルの基本](git-bash-basics.md) で説明しています。
- **実験は `~/git-practice/appendix-lab/` の下で行います**。ページごとに `appendix-lab/undo` のような専用のフォルダを作り、そこで使い捨てのリポジトリを作って試すので、`my-profile` などの練習用リポジトリを壊す心配はありません。作り直したいときや不要になったときは、エクスプローラーでそのフォルダを削除してください。
- `my-profile` などで実行する例は、**見るだけで何も変更しないコマンド** に限っています。
- 図はすべて文字（テキスト）で書いているので、VS Code のプレビュー（`Ctrl+Shift+V`）でも GitHub でも同じように見えます。
- 出力例のハッシュ値（`1d9c7f0` など）や名前、日時は人によって違います。
- 画面の表示やバージョンによる違いがある部分は「執筆時点」の情報です。各ページの末尾に、確認に使った公式ドキュメントへのリンク（参考資料）を載せています。

---

[README（全体の地図）](../README.md) ｜ [レシピ集](../recipes/README.md)
