# 7日目：マージとコンフリクト

[← 6日目](day06-branch.md) ｜ [README（全体の地図）](../README.md) ｜ [8日目 →](day08-remote-github.md)

## この日のゴール

- 両方のブランチが進んだときは「マージコミット」で合流することを説明できる
- コンフリクト（conflict、競合）が起きたファイルのマーカー（`<<<<<<<` `=======` `>>>>>>>`）を読める
- VS Code でコンフリクトを解決し、`git add` → `git commit` でマージを完了できる
- `git merge --abort` でマージを途中でやめられる

## 所要時間の目安

合計 **60分**

| セクション | 目安 |
|---|---|
| 1. 両方のブランチが進んだときのマージ | 15分 |
| 2. コンフリクトとは | 5分 |
| 3. コンフリクト練習用リポジトリを用意する | 5分 |
| 4. コンフリクトを解決する | 25分 |
| 5. マージをやめたいとき：git merge --abort | 5分 |
| 6. my-profile で自分でコンフリクトを起こしてみる（任意） | 15分（任意） |

## 前提

- 6日目を終えていること（ブランチの作成・切り替え・fast-forward マージ・削除ができる）
- `~/git-practice/gitlearn`（2日目にクローンした教材）があること
- `~/git-practice/my-profile` にコミットしていない変更が残っていないこと（`git status` で確認）
- 演習：[exercises/day07-conflict/README.md](../exercises/day07-conflict/README.md)

---

## 1. 両方のブランチが進んだときのマージ

6日目のマージは、`main` 側に新しいコミットがなかったので、付箋を早送りするだけの **fast-forward** でした。では、**ブランチを作ったあとに `main` 側でもコミットした** 場合はどうなるでしょうか。`my-profile` で試してみましょう。

1. `my-profile` に移動し、`main` にいることを確かめます。

   ```bash
   cd ~/git-practice/my-profile
   git switch main
   ```

2. 練習用のブランチ `practice-merge` を作って切り替えます。

   ```bash
   git switch -c practice-merge
   ```

3. `favorites.md` の **いちばん最後** に、好きなものを1行追加して保存し、コミットします。

   ```bash
   git add favorites.md
   git commit -m "好きなものを1つ追加"
   ```

4. `main` に戻ります。

   ```bash
   git switch main
   ```

5. 今度は `main` 側で、**`profile.md`**（別のファイル）に1行追加して保存し、コミットします。

   ```bash
   git add profile.md
   git commit -m "自己紹介にひとことを追加"
   ```

6. 履歴をグラフで見ます。2つのブランチが別々の方向に進んでいます。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   * 7b8c9d0 (HEAD -> main) 自己紹介にひとことを追加
   | * 6a7b8c9 (practice-merge) 好きなものを1つ追加
   |/
   * 5e6f7a8 座右の銘を追加
   ...
   ```

   （ハッシュ値は人によって違います。）

7. `practice-merge` を `main` にマージします。

   ```bash
   git merge practice-merge
   ```

8. **VS Code に `MERGE_MSG` というタブが開きます。** 1行目に `Merge branch 'practice-merge'` と書かれています。これは「マージコミット」のメッセージです。このままでよいので、**タブを閉じます**（タブの × をクリック、または `Ctrl+W`）。

   > [!NOTE]
   > 1日目に `core.editor "code --wait"` を設定したので、Git がメッセージの入力のために VS Code を開き、タブが閉じられるのを待っています。タブを閉じると、ターミナルに次のように表示されてマージが終わります。

   ```text
   Merge made by the 'ort' strategy.
    favorites.md | 1 +
    1 file changed, 1 insertion(+)
   ```

9. もう一度、履歴を見ます。

   ```bash
   git log --oneline --graph --all
   ```

   ```text
   *   8c9d0e1 (HEAD -> main) Merge branch 'practice-merge'
   |\
   | * 6a7b8c9 (practice-merge) 好きなものを1つ追加
   * | 7b8c9d0 自己紹介にひとことを追加
   |/
   * 5e6f7a8 座右の銘を追加
   ...
   ```

   2本の線が合流する **マージコミット**（`Merge branch 'practice-merge'`）ができました。

10. 練習用ブランチを削除します。

    ```bash
    git branch -d practice-merge
    ```

### 3-way マージのしくみ

両方のブランチが進んでいると、早送りでは済みません。そこで Git は、次の **3つ** を見比べて合流させます。これを **3-way マージ**（3者間マージ）と呼びます。

| 比べるもの | 今回の例 |
|---|---|
| 共通の祖先（2つのブランチが分かれた地点） | 「座右の銘を追加」のコミット |
| 今いるブランチ（`main`）の最新 | 「自己紹介にひとことを追加」 |
| 取り込むブランチ（`practice-merge`）の最新 | 「好きなものを1つ追加」 |

祖先から見て「`main` は `profile.md` を変えた」「`practice-merge` は `favorites.md` を変えた」とわかるので、Git は **両方の変更を自動で合わせた** 新しいコミット（マージコミット）を作ります。マージコミットは、親（1つ前のコミット）を2つ持つ特別なコミットです。

> [!TIP]
> VS Code のタブを開かずにマージしたいときは `git merge --no-edit practice-merge` のように `--no-edit` を付けると、用意されたメッセージのままマージコミットを作ります。

---

## 2. コンフリクトとは

3-way マージでは、たいていの場合 Git が自動で合わせてくれます。ところが、**同じファイルの同じ行（または隣り合った行）を、両方のブランチが別々の内容に変えた** 場合は、Git にはどちらを採用すべきか判断できません。この状態を **コンフリクト（conflict、競合）** と呼びます。

| 状況 | 結果 |
|---|---|
| 別々のファイルを変えた | 自動でマージされる |
| 同じファイルの、離れた行を変えた | 自動でマージされる |
| 同じファイルの **同じ行** を、別々の内容に変えた | **コンフリクト** |
| 同じ位置に、別々の行を追加した | **コンフリクト** |

コンフリクトはエラーでも失敗でもありません。**「ここは人間が決めてください」という Git からの相談** です。落ち着いて、どうしたいかを決めて書き直せば解決できます。

---

## 3. コンフリクト練習用リポジトリを用意する

わざとコンフリクトが起きる状態のリポジトリを、スクリプト（script：コマンドをまとめて自動で実行するファイル）で作ります。

1. 練習用フォルダの親に移動します。

   ```bash
   cd ~/git-practice
   ```

2. スクリプトを実行します。

   ```bash
   bash gitlearn/exercises/day07-conflict/make-conflict.sh
   ```

   `~/git-practice/conflict-lab` というリポジトリが作られ、最後に次に実行するコマンドが表示されます。

3. 作られたリポジトリに移動します。

   ```bash
   cd conflict-lab
   ```

4. 中身を確認します。

   ```bash
   git log --oneline --graph --all
   ```

   次の3つのブランチがあり、`main` と別々の方向に進んでいることがわかります。

   | ブランチ | 内容 |
   |---|---|
   | `main` | `meeting.md`（ミーティング案内）の「場所:」の行を変更し、「持ち物:」の末尾に1行追加している |
   | `change-place` | 同じ「場所:」の行を、別の場所に変更している |
   | `add-items` | 同じ「持ち物:」の末尾に、別の1行を追加している |

5. VS Code でこのフォルダを開きます。メニューの「ファイル（File）」→「フォルダーを開く（Open Folder）」で `C:\Users\<Windowsのユーザー名>\git-practice\conflict-lab` を選びます。

   > [!TIP]
   > Git Bash で `code .` と入力しても、今いるフォルダを VS Code の新しいウィンドウで開けます。

> [!NOTE]
> - スクリプトは、`conflict-lab` がすでにあると何もせずに終了します（上書きしません）。最初からやり直したいときは、エクスプローラーで `conflict-lab` フォルダを削除してから、もう一度実行してください（VS Code で開いている場合は、先にそのウィンドウを閉じます）。
> - `[中止] Git の user.name / user.email が設定されていません。` というメッセージで止まった場合は、[1日目](day01-install-git.md) の初期設定をやり直してください。

---

## 4. コンフリクトを解決する

### コンフリクトを起こす（コンフリクト①：どちらかを選ぶ）

1. `main` にいることを確かめます。

   ```bash
   git branch
   ```

   ```text
     add-items
     change-place
   * main
   ```

2. `change-place` を `main` にマージします。

   ```bash
   git merge change-place
   ```

   ```text
   Auto-merging meeting.md
   CONFLICT (content): Merge conflict in meeting.md
   Automatic merge failed; fix conflicts and then commit the result.
   ```

   「`meeting.md` でコンフリクトが起きたので、直してからコミットしてください」という意味です。Git Bash のプロンプトも `(main|MERGING)`（マージの途中）に変わります。

3. 状態を確認します。

   ```bash
   git status
   ```

   ```text
   On branch main
   You have unmerged paths.
     (fix conflicts and run "git commit")
     (use "git merge --abort" to abort the merge)

   Unmerged paths:
     (use "git add <file>..." to mark resolution)
   	both modified:   meeting.md

   no changes added to commit (use "git add" and/or "git commit -a")
   ```

   `both modified`（両方で変更された）のファイルがコンフリクトしているファイルです。

### コンフリクトマーカーの読み方

VS Code で `meeting.md` を開くと、次のような部分があります。

```text
- 日時: 5月10日（土）13:00〜15:00
<<<<<<< HEAD
- 場所: 学生会館 3階 多目的室
=======
- 場所: オンライン（ビデオ通話）
>>>>>>> change-place

持ち物:
```

Git がファイルに書き込んだ **コンフリクトマーカー** の意味は次のとおりです。

| マーカー | 意味 |
|---|---|
| `<<<<<<< HEAD` | ここから下が **今いるブランチ（`main`）** の内容。VS Code では「現在の変更（Current Change）」 |
| `=======` | 区切り線 |
| `>>>>>>> change-place` | ここから上が **取り込もうとしているブランチ（`change-place`）** の内容。VS Code では「入力側の変更（Incoming Change）」 |

**解決する** とは、このマーカーで囲まれた部分を **最終的にこうしたい、という内容に書き直し、マーカーの行（`<<<<<<<` `=======` `>>>>>>>`）を消すこと** です。方法は次の3つのどれでも構いません。

- 手でテキストを編集する
- VS Code のボタンを使う（次の節）
- VS Code のマージエディターを使う（次の節）

### VS Code で解決する

VS Code は、コンフリクトしている部分に色を付け、すぐ上に小さなボタン（CodeLens）を表示します（執筆時点の表示です）。

| ボタン | 結果 |
|---|---|
| **現在の変更を取り込む**（Accept Current Change） | `HEAD`（`main`）側だけを残す |
| **入力側の変更を取り込む**（Accept Incoming Change） | `change-place` 側だけを残す |
| **両方の変更を取り込む**（Accept Both Changes） | 両方を上下に並べて残す |
| **変更の比較**（Compare Changes） | 2つを左右に並べて見比べる（解決はしない） |

コンフリクト①では、場所はどちらか1つに決める必要があります。

1. 左側の **ソース管理ビュー**（`Ctrl+Shift+G`）を開きます。「**変更のマージ**（Merge Changes）」という欄に `meeting.md` が表示されています。クリックして開きます。
2. コンフリクト部分の上にあるボタンのうち、採用したいほうをクリックします（どちらでも構いません。ここでは例として「**入力側の変更を取り込む**（Accept Incoming Change）」）。
3. マーカーの行が消え、選んだ内容だけが残ったことを確かめます。

   ```text
   - 日時: 5月10日（土）13:00〜15:00
   - 場所: オンライン（ビデオ通話）

   持ち物:
   ```

4. 必要なら、さらに手で書き直します（たとえば「- 場所: オンライン（ビデオ通話）／会場は学生会館 3階 多目的室」のように、両方の情報を1行にまとめても構いません）。
5. `Ctrl+S` で保存します。
6. ファイル内に `<<<<<<<`、`=======`、`>>>>>>>` が **1つも残っていない** ことを目で確かめます。

#### マージエディターを使う場合

VS Code には、3つの画面を並べて解決する **マージエディター** もあります。どちらを使っても結果は同じです。

1. コンフリクトしているファイルを開いたとき、右下に表示される「**マージ エディターで解決**（Resolve in Merge Editor）」ボタンをクリックします（ソース管理ビューでファイルを右クリックして開くこともできます）。
2. 画面が3つに分かれます。

   | 位置 | 内容 |
   |---|---|
   | 上段の左 | **着信**（Incoming）：取り込もうとしているブランチ（`change-place`）の内容 |
   | 上段の右 | **現在**（Current）：今いるブランチ（`main`）の内容 |
   | 下段 | **結果**（Result）：保存される最終的な内容 |

3. 上段の左右それぞれの変更の上に表示されるボタンや、行の横のチェックボックスで、どちらを結果に入れるかを選びます。両方入れることもできます（ボタンの日本語表示は翻訳が揃っていないことがあるので、英語表示の **Accept Incoming** ／ **Accept Current** ／ **Accept Combination** と見比べてください）。
4. 下段の「結果」を直接編集することもできます。
5. 右下の「**マージの完了**（Complete Merge）」をクリックします。ファイルが保存され、ステージ（次の手順の `git add` と同じ）まで行われます。

出典：[Resolve conflicts in VS Code（Visual Studio Code 公式ドキュメント）](https://code.visualstudio.com/docs/sourcecontrol/merge-conflicts)（執筆時点で確認。日本語の表示名は [VS Code 日本語言語パックの翻訳](https://github.com/microsoft/vscode-loc) を参照）

### 解決を記録する

ファイルを直しただけでは、マージはまだ終わっていません。**「このファイルは解決しました」と Git に伝え（`git add`）、マージコミットを作る（`git commit`）** ことで完了します。

**Git Bash で**

1. 解決したファイルをステージします。

   ```bash
   git add meeting.md
   ```

2. 状態を確認します。

   ```bash
   git status
   ```

   ```text
   On branch main
   All conflicts fixed but you are still merging.
     (use "git commit" to conclude merge)

   Changes to be committed:
   	modified:   meeting.md
   ```

   「すべてのコンフリクトは解決したが、まだマージの途中」という意味です。

3. コミットしてマージを完了します。`--no-edit` は、Git が用意したメッセージ（`Merge branch 'change-place'`）をそのまま使う、という指定です。

   ```bash
   git commit --no-edit
   ```

   ```text
   [main 1cfe5cd] Merge branch 'change-place'
   ```

   > [!NOTE]
   > `--no-edit` を付けずに `git commit` だけを実行すると、VS Code に `COMMIT_EDITMSG` のタブが開きます。メッセージを確認・編集してから保存し、タブを閉じると完了します。

**VS Code で**

1. ソース管理ビューの「変更のマージ（Merge Changes）」にある `meeting.md` にマウスを乗せ、「**+**」（変更をステージ／Stage Changes）をクリックします（マージエディターで「マージの完了」を押した場合は、すでにステージされています）。
2. メッセージ欄に `Merge branch 'change-place'` が入っていることを確かめます。
3. 「**✓ コミット**（Commit）」をクリックします。

> [!WARNING]
> マーカーが残ったままステージしようとすると、VS Code が「マージの競合がある meeting.md をステージしてもよろしいですか?」と確認してきます。その場合はいったんキャンセルして、ファイルを見直してください。Git Bash の `git add` は確認なしでステージしてしまうので、`git add` の前に必ずマーカーが残っていないか確かめましょう。

最後にグラフで確かめます。

```bash
git log --oneline --graph --all
```

`Merge branch 'change-place'` のマージコミットで、2本の線が合流していれば成功です。

### コンフリクト②：両方残す

次は `add-items` を取り込みます。今度は「持ち物」の追加なので、**両方とも残す** のが自然です。

1. マージします。

   ```bash
   git merge add-items
   ```

   ```text
   Auto-merging meeting.md
   CONFLICT (content): Merge conflict in meeting.md
   Automatic merge failed; fix conflicts and then commit the result.
   ```

2. VS Code で `meeting.md` を開きます。末尾が次のようになっています。

   ```text
   持ち物:

   - 筆記用具
   - ノートパソコン
   <<<<<<< HEAD
   - 飲み物
   =======
   - 名札
   >>>>>>> add-items
   ```

3. 「**両方の変更を取り込む**（Accept Both Changes）」をクリックします。

   ```text
   持ち物:

   - 筆記用具
   - ノートパソコン
   - 飲み物
   - 名札
   ```

4. 保存（`Ctrl+S`）し、マーカーが残っていないことを確かめます。
5. ステージしてコミットします。

   ```bash
   git add meeting.md
   git commit --no-edit
   ```

6. グラフで確かめます。

   ```bash
   git log --oneline --graph --all
   ```

   マージコミットが2つでき、3本の流れがすべて `main` に合流していれば完了です。

---

## 5. マージをやめたいとき：git merge --abort

コンフリクトが起きたけれど「今は解決したくない」「やり方を間違えたので最初からやり直したい」というときは、マージそのものを取りやめて、**マージ前の状態に戻す** ことができます。

1. `conflict-lab` で、練習用にもう一度コンフリクトを起こします。今いる `main` から練習用ブランチを作り、「日時:」の行を変えてコミットします。

   ```bash
   git switch -c change-date
   ```

   VS Code で `meeting.md` の「日時:」の行を好きな日時に書き換えて保存し、コミットします。

   ```bash
   git commit -am "日時を変更"
   ```

   > [!NOTE]
   > `-a` は「すでに Git で管理しているファイルの変更を、まとめてステージしてからコミットする」という省略記法です。

2. `main` に戻り、同じ「日時:」の行を **別の日時** に書き換えて保存し、コミットします。

   ```bash
   git switch main
   ```

   ```bash
   git commit -am "日時を別の日に変更"
   ```

3. マージしてコンフリクトを起こします。

   ```bash
   git merge change-date
   ```

   ```text
   Auto-merging meeting.md
   CONFLICT (content): Merge conflict in meeting.md
   Automatic merge failed; fix conflicts and then commit the result.
   ```

4. マージを取りやめます。

   ```bash
   git merge --abort
   ```

5. 状態を確認します。

   ```bash
   git status
   ```

   ```text
   On branch main
   nothing to commit, working tree clean
   ```

   プロンプトの `|MERGING` も消え、マージ前の状態に戻りました。`meeting.md` のマーカーも消えています。

6. 練習用ブランチを削除します。マージしていないので、`-D`（強制削除）を使います。

   ```bash
   git branch -D change-date
   ```

**VS Code で** マージを取りやめるときは、コマンドパレット（`Ctrl+Shift+P`）で「**Git: マージの中止**（Git: Abort Merge）」を実行します。

> [!TIP]
> `git merge --abort` は「マージの途中」のときだけ使えます。マージコミットを作り終えたあとで取り消したい場合は、[レシピ branch-06](../recipes/branch.md#branch-06) と5日目の `reset` を参照してください。

---

## 6. my-profile で自分でコンフリクトを起こしてみる（任意）

時間がある人は、スクリプトを使わずに、自分の手でコンフリクトを起こして解決してみましょう。手順を自分で組み立てられれば、コンフリクトのしくみを理解できた証拠です。

1. `my-profile` に移動し、`main` にいることを確かめます。

   ```bash
   cd ~/git-practice/my-profile
   git switch main
   ```

2. ブランチ `change-goal` を作って切り替えます。

   ```bash
   git switch -c change-goal
   ```

3. `profile.md` の「目標」の行を書き換えて保存し、コミットします。

   ```bash
   git commit -am "目標を変更"
   ```

4. `main` に戻ります。

   ```bash
   git switch main
   ```

5. `profile.md` の **同じ「目標」の行** を、別の内容に書き換えて保存し、コミットします。

   ```bash
   git commit -am "目標を別の内容に変更"
   ```

6. マージします。

   ```bash
   git merge change-goal
   ```

7. 4章の手順で解決し、`git add profile.md` → `git commit --no-edit` で完了します。
8. 使い終わったブランチを削除します。

   ```bash
   git branch -d change-goal
   ```

> [!NOTE]
> `my-profile` は8日目に GitHub に push します。マージコミットが含まれていても問題ありません。

---

## 確認チェックリスト

- [ ] `my-profile` で、両方のブランチが進んだ状態からマージし、`git log --oneline --graph --all` でマージコミットの合流を確かめた
- [ ] `bash gitlearn/exercises/day07-conflict/make-conflict.sh` で `~/git-practice/conflict-lab` を作った
- [ ] `git merge change-place` でコンフリクトを起こし、`<<<<<<< HEAD` と `>>>>>>> change-place` の間のどちらが `main` 側かを説明できる
- [ ] コンフリクト①をどちらか一方を選んで解決し、`git add` → `git commit` でマージを完了した
- [ ] コンフリクト②を「両方の変更を取り込む（Accept Both Changes）」で解決し、マージを完了した
- [ ] `git merge --abort` でマージ前に戻せた（`git status` が `nothing to commit, working tree clean`）
- [ ] `conflict-lab` の `meeting.md` に `<<<<<<<` などのマーカーが残っていない
- [ ] 演習 [exercises/day07-conflict/README.md](../exercises/day07-conflict/README.md) の完了条件を満たした

## よくあるつまずき

**症状：`git merge` のあと、見慣れない黒い画面（Vim）が開いて操作できない**
- 原因：エディタが VS Code に設定されていないため、Git の既定のエディタ Vim が開いています。
- 対処：`Esc` を押してから `:wq` と入力して `Enter` で抜けられます。今後のために `git config --global core.editor "code --wait"` を設定します。→ [レシピ trouble-10](../recipes/troubleshooting.md#trouble-10)

**症状：`git merge` のあと、ターミナルが止まったまま何も起きない**
- 原因：VS Code に `MERGE_MSG`（または `COMMIT_EDITMSG`）のタブが開いて、閉じられるのを待っています。
- 対処：VS Code のタブを探して閉じます。ターミナルに `hint: Waiting for your editor to close the file...` と出ていれば、この状態です。

**症状：`bash: gitlearn/exercises/day07-conflict/make-conflict.sh: No such file or directory` と出る**
- 原因：`~/git-practice` 以外の場所で実行しているか、教材のクローンが古い（スクリプトがない）可能性があります。
- 対処：`cd ~/git-practice` してから実行します。`ls gitlearn/exercises/day07-conflict` でファイルがあるか確かめてください。

**症状：`[中止] … conflict-lab はすでにあります。何も変更していません。` と出て、スクリプトが何もしない**
- 原因：前に作った `conflict-lab` が残っています。
- 対処：やり直したいときは、VS Code の `conflict-lab` のウィンドウを閉じてから、エクスプローラーで `conflict-lab` フォルダを削除し、もう一度実行します。

**症状：解決してコミットしたのに、ファイルに `<<<<<<<` が残っていた**
- 原因：マーカーを消し忘れたまま `git add` しました。
- 対処：ファイルを直して保存し、`git add` → `git commit -m "コンフリクトマーカーを削除"` で直したコミットを追加します。

**症状：`error: Merging is not possible because you have unmerged files.` や `You have not concluded your merge (MERGE_HEAD exists).` と出る**
- 原因：前のマージがまだ途中です。
- 対処：`git status` で状況を確認し、解決して `git add` → `git commit` で完了するか、`git merge --abort` で取りやめます。→ [レシピ branch-06](../recipes/branch.md#branch-06)

**症状：どちらが「現在の変更」でどちらが「入力側の変更」かわからなくなった**
- 対処：「現在（Current）」＝ **今いるブランチ**（`git branch` で `*` が付いているもの、マーカーでは `HEAD`）、「入力側（Incoming）」＝ **`git merge` の後ろに書いたブランチ** です。

## もっと知りたい人へ

- [Appendix：ブランチとマージ](../appendix/branches-and-merge.md)：マージベース、fast-forward と 3-way マージ、`--no-ff`、コンフリクトが起きる条件・起きない条件、`merge.conflictStyle=zdiff3`、マージエディター
- レシピ
  - [branch-05 ブランチを取り込みたい（マージ）](../recipes/branch.md#branch-05)
  - [branch-06 コンフリクトを解決したい／マージをやめたい](../recipes/branch.md#branch-06)
  - [trouble-10 コミットや pull の途中で見慣れないエディタ（Vim）が開いた](../recipes/troubleshooting.md#trouble-10)

---
[← 6日目](day06-branch.md) ｜ [README](../README.md) ｜ [8日目 →](day08-remote-github.md)
