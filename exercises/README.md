# 演習の一覧

各日の演習と完了条件の一覧です。くわしい手順は、各フォルダの `README.md` にあります。

- 各演習は「目的」「所要時間の目安」「手順」「完了条件」「ヒント」の順に書かれています。
- 練習素材はテキスト（Markdown）だけです。個人情報（本名のフルネーム、電話番号、住所、学籍番号、顔写真）は書かないでください。
- 全体の地図は [README（全体の地図）](../README.md) にあります。

## 1〜2日目：セットアップ編

| 日 | 演習 | 完了条件の要約 | 説明ページ |
|---|---|---|---|
| 1 | [セットアップ確認](day01-setup-check/README.md) | `git --version` が表示される／`git config --global --list` に6項目がそろう／`~/git-practice` がある | [1日目](../docs/day01-install-git.md) |
| 2 | [GitHub の準備とクローン](day02-github-setup/README.md) | 2FA 有効／`user.email` が noreply／Private の `gitlearn` を `~/git-practice/gitlearn` にクローン | [2日目](../docs/day02-github-account.md) |

## 3〜8日目：ひとりで練習編

| 日 | 演習 | 完了条件の要約 | 説明ページ |
|---|---|---|---|
| 3 | [はじめてのコミット](day03-first-commit/README.md)（素材：`profile.md`） | `my-profile` で3回以上コミットし、`git log --oneline` で確認できる | [3日目](../docs/day03-first-commit.md) |
| 4 | [差分・履歴・.gitignore](day04-diff-and-ignore/README.md)（素材：`hobbies.md`、`debug.log`、`private-memo.txt`） | `diff` と `diff --staged` の違いを説明でき、`debug.log` と `private-memo.txt` が無視される | [4日目](../docs/day04-diff-log-ignore.md) |
| 5 | [取り消しとやり直し](day05-undo/README.md) | 5つのシナリオを、`restore` / `restore --staged` / `amend` / `revert` / `reset --soft` で解決できる | [5日目](../docs/day05-undo.md) |
| 6 | [ブランチ](day06-branch/README.md)（素材：`favorites.md`） | `add-favorites` を作って fast-forward マージし、ブランチを削除する | [6日目](../docs/day06-branch.md) |
| 7 | [マージとコンフリクト](day07-conflict/README.md)（スクリプト：`make-conflict.sh`） | 2種類のコンフリクトを解決し、マージを完了する | [7日目](../docs/day07-merge-conflict.md) |
| 8 | [GitHub とつなぐ](day08-remote/README.md) | `my-profile` を push し、clone・pull・fetch で同期し、push 拒否を解消する | [8日目](../docs/day08-remote-github.md) |

## 9〜14日目：チーム開発編

| 日 | 演習 | 完了条件の要約 | 説明ページ |
|---|---|---|---|
| 9 | [チームの準備と Issue](day09-team-kickoff/README.md) | チームリポジトリをクローンし、ルールに合意し、自分の Issue を作る | [9日目](../docs/day09-team-kickoff.md) |
| 10 | [はじめてのプルリクエスト](day10-first-pr/README.md)（素材：`team-project/members/_template.md`） | 紹介ページを追加する PR が Approve → マージされ、Issue が自動で閉じる | [10日目](../docs/day10-pull-request.md) |
| 11 | [コードレビュー](day11-review/README.md)（[レビューチェックリスト](day11-review/review-checklist.md)） | 担当ページの PR をマージし、相手の PR に最低1つコメントする | [11日目](../docs/day11-code-review.md) |
| 12 | [チームでのコンフリクト](day12-team-conflict/README.md)（素材：`team-project/schedule.md`） | ラウンド1・2のコンフリクトを解決し、全員が最低1回は自分で解決する | [12日目](../docs/day12-team-conflict.md) |
| 13 | [最終課題](day13-final-project/README.md)（発展：[rebase の練習](day13-final-project/rebase-optional.md)） | Issue に分けて並行して PR を回し、用語集に3語ずつ追加する | [13日目](../docs/day13-final-project.md) |
| 14 | [完成・リリース・ふりかえり](day14-retrospective/README.md)（素材：`team-project/retrospective.md`） | `v1.0` の Release を作り、KPT のふりかえりをまとめる | [14日目](../docs/day14-release-retrospective.md) |

## チーム開発編の素材（`team-project/`）

チームで育てる「サークル紹介ガイドブック」の素材です。10日目以降で使います。

| ファイル | 使う日 |
|---|---|
| [`team-project/README.md`](team-project/README.md)（表紙と目次） | 13日目に完成 |
| [`team-project/members/_template.md`](team-project/members/_template.md)（紹介ページのひな形） | 10日目 |
| [`team-project/members/README.md`](team-project/members/README.md)（メンバー一覧） | 13日目に完成 |
| [`team-project/pages/activities.md`](team-project/pages/activities.md)（活動紹介） | 11日目（役割 A） |
| [`team-project/pages/events.md`](team-project/pages/events.md)（年間行事） | 11日目（役割 B） |
| [`team-project/pages/faq.md`](team-project/pages/faq.md)（よくある質問） | 11日目（役割 C） |
| [`team-project/pages/newcomers.md`](team-project/pages/newcomers.md)（新入生へ） | 11日目（役割 D）／3人チームは13日目 |
| [`team-project/pages/git-glossary.md`](team-project/pages/git-glossary.md)（Git 用語集） | 13日目 |
| [`team-project/schedule.md`](team-project/schedule.md)（活動予定） | 12日目のコンフリクト練習、13日目に確定 |
| [`team-project/retrospective.md`](team-project/retrospective.md)（ふりかえり） | 14日目 |

## 困ったときは

- [レシピ集](../recipes/README.md)：やりたいこと・エラーメッセージから探せます。
- [Appendix](../appendix/README.md)：しくみを深く知りたいときに。
- Issue の「質問」「教材の修正依頼」テンプレートも使えます。
