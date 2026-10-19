#!/usr/bin/env bash
# 7日目：コンフリクト練習用のリポジトリ「conflict-lab」を作るスクリプトです。
# 使い方（Git Bash で）:
#   cd ~/git-practice
#   bash gitlearn/exercises/day07-conflict/make-conflict.sh

LAB="$HOME/git-practice/conflict-lab"

# すでにあれば、何もせずに終了する（上書きしない）
if [ -e "$LAB" ]; then
  echo "[中止] $LAB はすでにあります。何も変更していません。"
  echo "作り直したいときは、エクスプローラーで conflict-lab フォルダを削除してから、もう一度実行してください。"
  exit 1
fi

# user.name / user.email が未設定なら、1日目に戻ってもらう
if [ -z "$(git config user.name)" ] || [ -z "$(git config user.email)" ]; then
  echo "[中止] Git の user.name / user.email が設定されていません。"
  echo "1日目の「Git の初期設定をする」に戻って、次の2つを設定してから、もう一度実行してください。"
  echo '  git config --global user.name "表示したい名前"'
  echo '  git config --global user.email "メールアドレス"'
  exit 1
fi

# 途中で失敗したら止める
set -e

mkdir -p "$LAB"
cd "$LAB"
git init -q -b main
# このリポジトリの中だけ、改行コードを LF のままにする（Windows で LF→CRLF の警告が出ないように）
git config core.autocrlf false

# --- 最初のコミット ---
cat > meeting.md <<'TEXT'
# サークルのミーティング案内

次回のミーティングについてお知らせします。

- 日時: 5月10日（土）13:00〜15:00
- 場所: 学生会館 2階 会議室A

持ち物:

- 筆記用具
- ノートパソコン
TEXT
git add meeting.md
git commit -q -m "ミーティング案内を作成"

# --- コンフリクト①の準備：同じ「場所:」の行を、別々に変更する ---
git switch -q -c change-place
sed -i 's/^- 場所: .*/- 場所: オンライン（ビデオ通話）/' meeting.md
git commit -q -am "場所をオンラインに変更"

git switch -q main
sed -i 's/^- 場所: .*/- 場所: 学生会館 3階 多目的室/' meeting.md
git commit -q -am "場所を3階の多目的室に変更"

# --- コンフリクト②の準備：「持ち物:」リストの末尾に、別々の1行を追加する ---
# add-items は、最初のコミットから分かれたブランチにする
git switch -q -c add-items HEAD~1
echo "- 名札" >> meeting.md
git commit -q -am "持ち物に名札を追加"

git switch -q main
echo "- 飲み物" >> meeting.md
git commit -q -am "持ち物に飲み物を追加"

echo ""
echo "conflict-lab を作りました: $LAB"
echo ""
git log --oneline --graph --all
echo ""
echo "次のコマンドを順番に実行してください。"
echo "  1. cd ~/git-practice/conflict-lab"
echo "  2. git merge change-place   （コンフリクト①：場所の行。VS Code で解決して git add → git commit）"
echo "  3. git merge add-items      （コンフリクト②：持ち物リスト。両方残して解決して git add → git commit）"
