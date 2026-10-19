# 7日目の演習：マージとコンフリクト

説明ページ：[7日目：マージとコンフリクト](../../docs/day07-merge-conflict.md)

## 目的

スクリプトで用意したリポジトリで、2種類のコンフリクト（どちらかを選ぶ／両方残す）を VS Code で解決し、マージを完了できるようになります。

## 所要時間の目安

40〜50分

## 準備：練習用リポジトリを作る

Git Bash で次のコマンドを実行します。

```bash
cd ~/git-practice
bash gitlearn/exercises/day07-conflict/make-conflict.sh
```

`~/git-practice/conflict-lab` ができ、最後に履歴のグラフと、次に実行するコマンドが表示されます。

| ブランチ | 中身 |
|---|---|
| `main` | 「場所:」の行を「学生会館 3階 多目的室」に変更、「持ち物:」リストの末尾に「飲み物」を追加 |
| `change-place` | 「場所:」の行を「オンライン（ビデオ通話）」に変更 |
| `add-items` | 「持ち物:」リストの末尾に「名札」を追加 |

> [!NOTE]
> 次のメッセージが出たときは、それぞれ対処してください。
> - `conflict-lab はすでにあります`：すでに作ってあります。作り直したいときは、エクスプローラーで `conflict-lab` フォルダを削除してから、もう一度実行します。
> - `user.name / user.email が設定されていません`：1日目の初期設定に戻ってください。

## 手順

### コンフリクト①：同じ行を変更した（どちらかを選ぶ）

1. `conflict-lab` に移動して、`change-place` をマージします。

   ```bash
   cd ~/git-practice/conflict-lab
   git merge change-place
   ```

   `CONFLICT (content): Merge conflict in meeting.md` と表示されます（正常です）。
2. `git status` で、`both modified: meeting.md` を確認します。
3. VS Code で `conflict-lab` を開き、`meeting.md` のコンフリクトマーカー（`<<<<<<<` `=======` `>>>>>>>`）を確認します。
4. 「場所:」は片方だけが正しい行です。好きなほう（または自分で決めた新しい行）を選んで解決します。VS Code の「現在の変更を取り込む（Accept Current Change）」か「入力側の変更を取り込む（Accept Incoming Change）」を使います。
5. マーカー（`<<<<<<<` など）が一つも残っていないことを確認して保存します。
6. 解決を記録します。

   ```bash
   git add meeting.md
   git commit --no-edit
   ```

   `--no-edit` は「Git が用意したメッセージ（`Merge branch 'change-place'`）のままコミットする」という指定です。

### コンフリクト②：同じ位置に別の行を追加した（両方残す）

1. 続けて `add-items` をマージします。

   ```bash
   git merge add-items
   ```

2. 「持ち物:」リストの末尾にコンフリクトが出ます。今度は **両方の項目を残したい** ので、「両方の変更を取り込む（Accept Both Changes）」を使います。
3. 保存して、記録します。

   ```bash
   git add meeting.md
   git commit --no-edit
   ```

### 確認とやり直し

1. 履歴を確認します。

   ```bash
   git log --oneline --graph --all
   ```

2. （任意）`git merge --abort` の練習：説明ページの「5. マージをやめたいとき」の手順で、`change-date` ブランチを使ってコンフリクトを起こしてから、`git merge --abort` で取りやめます。`git status` で `working tree clean` に戻ることを確認します。

## 完了条件

- [ ] `meeting.md` に `<<<<<<<` `=======` `>>>>>>>` が残っていない
- [ ] 「場所:」の行が1行だけで、自分が選んだ内容になっている
- [ ] 「持ち物:」リストに、筆記用具・ノートパソコン・飲み物・名札の4つがそろっている
- [ ] `git log --oneline --graph --all` にマージコミットが2つ見える
- [ ] `git status` が `nothing to commit, working tree clean`
- [ ] `git merge --abort` が何をするコマンドか、自分の言葉で説明できる

## ヒント

- コンフリクトは「失敗」ではなく、「どちらを採用するか人間が決めてください」という Git からの確認です。落ち着いて、マーカーの上下に何が書かれているかを読みます。
- `HEAD`（または Current）が **いまいるブランチ（`main`）の側**、`change-place` や `add-items`（Incoming）が **取り込もうとしている側** です。
- `git commit` でメッセージ画面が開いたまま閉じられなくなったときは、[レシピ集のトラブル対応（trouble-10）](../../recipes/troubleshooting.md#trouble-10) を見てください。
- マーカーを消し忘れてコミットしてしまったら、もう一度ファイルを直して、新しくコミットすれば大丈夫です。
- もっと練習したい人は、`my-profile` でブランチを2つ作り、同じ行を別々に変えてマージしてみましょう（説明ページの任意の節）。
