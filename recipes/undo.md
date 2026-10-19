# レシピ集：取り消し・やり直し

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

「やってしまった！」を元に戻すためのレシピです。まず **戻したい変更がどこにあるか**（編集しただけ／ステージした／コミットした／push した）を確かめてから選んでください。

| 戻したいもの | レシピ | push 後に使えるか |
|---|---|---|
| 編集中のファイル（ステージ前） | [undo-01](#undo-01) | ― |
| ステージしたファイル | [undo-02](#undo-02) | ― |
| 直前のコミット（直す） | [undo-03](#undo-03) | 使わない |
| 直前のコミット（取り消す） | [undo-04](#undo-04) | 使わない |
| push 済みのコミット | [undo-05](#undo-05) | 使える |
| ファイルを過去の状態に | [undo-06](#undo-06) | 使える（新しいコミットになる） |
| 作業途中の変更を一時退避 | [undo-07](#undo-07) | ― |
| 消したコミットやブランチ | [undo-08](#undo-08) | ― |

- [undo-01 編集中のファイルを最後のコミットの状態に戻したい](#undo-01)
- [undo-02 ステージを取り消したい](#undo-02)
- [undo-03 直前のコミットを直したい（メッセージの修正・ファイルの入れ忘れ）](#undo-03)
- [undo-04 直前のコミットを取り消したい（まだ push していない）](#undo-04)
- [undo-05 push 済みのコミットを打ち消したい](#undo-05)
- [undo-06 ファイルを過去のコミットの状態に戻したい](#undo-06)
- [undo-07 作業途中の変更を一時的に退避したい（stash）](#undo-07)
- [undo-08 消してしまったコミットやブランチを取り戻したい（reflog）](#undo-08)

> [!NOTE]
> コマンドはすべて VS Code 内の Git Bash で、リポジトリのフォルダに `cd` してから実行します。画面の説明は執筆時点（2026年10月）の表示です。出力例のハッシュ値（`a1b2c3d` など）は人によって違います。

> [!TIP]
> 取り消しの前に `git status` と `git log --oneline --graph --all` で今の状態を確かめる習慣をつけると、失敗が減ります。

---

<a id="undo-01"></a>
## undo-01 編集中のファイルを最後のコミットの状態に戻したい

**こんなとき**：ファイルを編集してみたけれど、うまくいかなかったので、編集をなかったことにして最後のコミットの状態に戻したいとき（まだステージしていない）。

**Git Bash**：

```bash
git restore profile.md
```

変更したファイルを全部まとめて戻すときは、ファイル名の代わりに `.` を指定します。

```bash
git restore .
```

戻ったか確認します。

```bash
git status
```

```text
On branch main
nothing to commit, working tree clean
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューの「変更（Changes）」で、戻したいファイルにマウスを乗せます。
2. 曲がった矢印のアイコン「変更を破棄（Discard Changes）」を選びます。
3. 確認画面で「ファイルの破棄（Discard File）」などの破棄するボタンを選びます。

すべてのファイルを戻すときは、「変更」の見出しにある「すべての変更を破棄（Discard All Changes）」を使います。

**注意点**：

- **この操作で消えた編集内容は、Git では取り戻せません**（一度もコミットもステージもしていないため）。本当に要らないか確かめてから実行してください。迷ったら [undo-07](#undo-07) の stash で退避しておくと安全です。
- ステージ済みの変更は `git restore` だけでは戻りません。先に [undo-02](#undo-02) でステージを取り消します。
- 新しく作ったファイル（untracked）は `git restore` の対象外です。要らなければ、エクスプローラーなどで削除します。VS Code の「変更を破棄」を untracked のファイルに使うと、**そのファイルは削除されます**。

**関連**：[5日目](../docs/day05-undo.md)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="undo-02"></a>
## undo-02 ステージを取り消したい

**こんなとき**：`git add` でステージしたけれど、このファイルは次のコミットに入れたくない、と思ったとき。編集内容そのものは残したいとき。

**Git Bash**：

```bash
git restore --staged profile.md
```

ステージしたものを全部取り消すときは `.` を指定します。

```bash
git restore --staged .
```

```bash
git status -s
```

```text
 M profile.md
```

（`M` が右の列に移り、「変更したがステージしていない」状態に戻りました。）

**VS Code**：

1. 「ソース管理（Source Control）」ビューの「ステージされている変更（Staged Changes）」で、ファイルにマウスを乗せます。
2. 「－」アイコン「変更のステージング解除（Unstage Changes）」を選びます。

全部取り消すときは、「ステージされている変更」の見出しの「－」（すべての変更のステージング解除（Unstage All Changes））を選びます。

**注意点**：

- ステージを取り消しても、**ファイルの編集内容は消えません**。安全な操作です。
- 編集内容まで戻したい場合は、続けて [undo-01](#undo-01) を行います。

**関連**：[5日目](../docs/day05-undo.md)、[Appendix：3つの場所](../appendix/three-areas.md)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="undo-03"></a>
## undo-03 直前のコミットを直したい（メッセージの修正・ファイルの入れ忘れ）

**こんなとき**：コミットした直後に、メッセージの誤字に気づいたとき。ファイルを1つステージし忘れていたとき。（まだ push していない場合）

**Git Bash**：

メッセージだけを直します。

```bash
git commit --amend -m "自己紹介に趣味を追加"
```

入れ忘れたファイルを、直前のコミットに追加します（メッセージはそのまま）。

```bash
git add hobbies.md
git commit --amend --no-edit
```

直ったか確認します。

```bash
git show --stat HEAD
```

**VS Code**：

1. 入れ忘れたファイルがあれば、ステージします。メッセージを直したい場合は、メッセージ欄に正しいメッセージを書きます。
2. 「✓ コミット（Commit）」ボタンの右の「∨」を選びます。
3. 「コミット (修正)（Commit (Amend)）」を選びます。

メッセージ欄を空のまま実行すると、元のメッセージが書かれたタブが開くことがあります。その場合は必要に応じて書き換え、保存してタブを閉じると確定します。

**注意点**：

- `--amend` は、直前のコミットを **新しいコミットに置き換えます**（ハッシュが変わります）。**push 済みのコミットには使わないでください**。GitHub の履歴と食い違い、push が拒否されます。push 済みなら [undo-05](#undo-05) を使います。
- 直せるのは「直前の」コミットだけです。もっと前のコミットを直す方法は [Appendix：rebase](../appendix/rebase.md) の対話的 rebase で紹介しています（発展）。

**関連**：[5日目](../docs/day05-undo.md)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="undo-04"></a>
## undo-04 直前のコミットを取り消したい（まだ push していない）

**こんなとき**：コミットしたけれど、まだ早かった、別のブランチでやるべきだった、などの理由でコミットをなかったことにしたいとき。変更内容は手元に残したいとき。

**Git Bash**：

コミットだけを取り消し、変更は **ステージした状態のまま** 残します。

```bash
git reset --soft HEAD~1
```

`HEAD~1` は「今いるコミットの1つ前」という意味です。確認します。

```bash
git status -s
git log --oneline -3
```

```text
M  profile.md
```

コミットを取り消し、ステージも外したい（変更はファイルに残す）ときは、`--soft` を付けずに実行します（`--mixed` と同じ意味です）。

```bash
git reset HEAD~1
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューの上部にある「…」（その他の操作）を選びます。
2. 「コミット（Commit）」→「前回のコミットを元に戻す（Undo Last Commit）」を選びます。

コミットが取り消され、変更は「ステージされている変更」に戻り、メッセージ欄に元のメッセージが入ります（`git reset --soft HEAD~1` と同じ動きです）。

**注意点**：

- **push 済みのコミットには使わないでください**。手元と GitHub の履歴が食い違います。push 済みなら [undo-05](#undo-05) を使います。
- `git reset --hard HEAD~1` は、コミットだけでなく **変更内容も消します**。最後の手段です。間違えて実行したときは [undo-08](#undo-08) で取り戻せることがあります。
- 間違えて `main` にコミットしてしまった場合は、[branch-07](branch.md#branch-07) の方法がおすすめです。

**関連**：[5日目](../docs/day05-undo.md)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="undo-05"></a>
## undo-05 push 済みのコミットを打ち消したい

**こんなとき**：GitHub に push したあとで、そのコミットが間違いだったと気づいたとき。チームの `main` に入ってしまった変更を元に戻したいとき。

**Git Bash**：

直前のコミットを打ち消す「逆向きのコミット」を作ります。`--no-edit` を付けると、自動で作られたメッセージ（`Revert "..."`）のままコミットされます。

```bash
git revert HEAD --no-edit
```

```text
[main 9d8e7f6] Revert "趣味を追加"
 1 file changed, 1 deletion(-)
```

もっと前のコミットを打ち消すときは、`git log --oneline` でハッシュを確かめて指定します。次の `15caa63` は例なので、**自分の画面に表示されたハッシュに置き換えて** 実行してください。

```bash
git log --oneline
git revert 15caa63 --no-edit
```

打ち消しのコミットを GitHub に送ります。

```bash
git push
```

**VS Code**：GUI での操作はありません。ターミナルで実行します。push は「変更の同期（Sync Changes）」ボタンでもできます。

**注意点**：

- `revert` は履歴を消さずに、**打ち消す内容の新しいコミットを追加** します。履歴を書き換えないので、push 済みでも安全に使えます。
- チームのリポジトリで `main` を直接変更できない場合は、ブランチを作って revert し、PR を出します（GitHub の PR 画面の **Revert** ボタンでも、打ち消し用の PR を作れます）。
- 打ち消す内容が、その後のコミットと同じ行を変えていると、コンフリクトが起きることがあります。解決方法は [branch-06](branch.md#branch-06) と同じです。やめたいときは `git revert --abort` を実行します。
- push 済みのコミットに `git reset` や `--amend` を使って `git push --force` するのは、チームの履歴を壊すので、この教材では使いません。

**関連**：[5日目](../docs/day05-undo.md)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)、[Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="undo-06"></a>
## undo-06 ファイルを過去のコミットの状態に戻したい

**こんなとき**：1つのファイルだけを、何コミットか前の内容に戻したいとき（ほかのファイルはそのままにしたい）。

**Git Bash**：

1. そのファイルを変えたコミットの一覧を見て、戻したい時点のハッシュを確かめます。

```bash
git log --oneline -- profile.md
```

```text
72cd3f8 趣味を追加
15caa63 自己紹介を書き換え
f3b1fd6 自己紹介を追加
```

2. そのコミットの時点の内容に、ファイルを戻します。次の `15caa63` は例なので、**自分の画面に表示されたハッシュに置き換えて** 実行してください。

```bash
git restore --source=15caa63 profile.md
```

3. 内容を確かめて、コミットします。

```bash
git diff
git add profile.md
git commit -m "自己紹介を以前の内容に戻す"
```

ハッシュの代わりに `HEAD~2`（2つ前のコミット）のような書き方もできます。

**VS Code**：直接戻す GUI はありません。ターミナルで実行します。
過去の内容を見るだけなら、エクスプローラーの「タイムライン（Timeline）」で、そのファイルのコミットを選ぶと、その時点の内容と比べられます。

**注意点**：

- `git restore --source=...` は、ワーキングツリー（手元のファイル）の内容だけを書き換えます。**その時点で、まだコミットしていない編集は上書きされて消えます**。先にコミットするか、[undo-07](#undo-07) で退避してください。
- 戻した内容は「新しいコミット」として記録されるので、push 済みでも安全に使えます。
- 戻すのをやめたいときは、コミット前なら `git restore profile.md` で最後のコミットの状態に戻せます。

**関連**：[5日目](../docs/day05-undo.md)、[basics-05](basics.md#basics-05)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="undo-07"></a>
## undo-07 作業途中の変更を一時的に退避したい（stash）

**こんなとき**：作業の途中で、別のブランチに切り替えたり、pull したりする必要が出たけれど、今の変更はまだコミットしたくないとき。

**Git Bash**：

変更を退避します。`-u` を付けると、新しく作ったファイル（untracked）も一緒に退避します。`-m` で、あとで見分けるためのメモを付けられます。

```bash
git stash push -u -m "趣味の追加の途中"
```

```text
Saved working directory and index state On main: 趣味の追加の途中
```

ワーキングツリーが最後のコミットの状態に戻ります（`git status` で確認できます）。退避したものの一覧を見ます。

```bash
git stash list
```

```text
stash@{0}: On main: 趣味の追加の途中
```

退避した変更を元に戻し、一覧から消します。

```bash
git stash pop
```

元に戻すけれど一覧には残しておきたいときは `apply`、要らなくなった退避を消すときは `drop` を使います。

```bash
git stash apply
git stash drop
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューの上部の「…」（その他の操作）を選びます。
2. 「スタッシュ（Stash）」を開き、「スタッシュ（Stash）」または「スタッシュ (未追跡ファイルを含む)（Stash (Include Untracked)）」を選びます。
3. メッセージを聞かれたら、メモを入力して Enter を押します。
4. 戻すときは、同じメニューから「最新のスタッシュをポップ（Pop Latest Stash）」を選びます。

**注意点**：

- `-u` を付けないと、新しく作ったファイルは退避されず、手元に残ります。
- `git stash pop` で戻すときに、今のファイルと同じ行がぶつかるとコンフリクトになります。その場合、退避した内容は一覧に **残ったまま** になるので、コンフリクトを解決したあと（[branch-06](branch.md#branch-06)）、`git stash drop` で消してください。
- stash は一時的な置き場所です。長く置いておくと何の変更だったか忘れがちなので、なるべく早く戻すか、ブランチを作ってコミットしましょう。

**関連**：[5日目](../docs/day05-undo.md)、[branch-03](branch.md#branch-03)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="undo-08"></a>
## undo-08 消してしまったコミットやブランチを取り戻したい（reflog）

**こんなとき**：`git reset --hard` でコミットを消してしまったとき。マージしていないブランチを `git branch -D` で消してしまったとき。

**Git Bash**：

1. `HEAD`（今いる場所）が動いた記録を表示します。新しい順に並びます。

```bash
git reflog
```

```text
12ef8e6 HEAD@{0}: reset: moving to HEAD~2
08c0cc1 HEAD@{1}: commit: 趣味を追加
b56c023 HEAD@{2}: commit: 好きな食べ物を追加
12ef8e6 HEAD@{3}: commit: 自己紹介を書き換え
```

2. 取り戻したいコミット（ここでは `reset` する前の `08c0cc1`）を見つけます。
3. そのコミットを指すブランチを作って、取り戻します。次の `08c0cc1` は例なので、**自分の画面に表示されたハッシュに置き換えて** 実行してください。

```bash
git branch rescue 08c0cc1
git log --oneline --graph --all
```

`rescue` ブランチの先に、消えたはずのコミットが見えれば成功です。

4. 取り戻したコミットを今のブランチに戻したいときは、マージします。

```bash
git merge rescue
git branch -d rescue
```

**消したブランチを取り戻す場合**：`git branch -D` を実行したときの表示 `Deleted branch add-favorites (was e113608).` の `e113608` が、そのブランチの最後のコミットです。同じ名前でブランチを作り直せます（ハッシュは自分の画面のものに置き換えます）。

```bash
git branch add-favorites e113608
```

表示を見逃したときは、`git reflog` で、そのブランチで最後にしたコミットを探します。

**VS Code**：GUI での操作はありません。ターミナルで実行します。

**注意点**：

- reflog は **自分のパソコンの中だけ** の記録です。ほかの人のパソコンや GitHub には残っていません。
- 一度もコミットしていない変更（`git restore` や「変更を破棄」で消したもの）は、reflog では取り戻せません。
- reflog の記録は、ずっとは残りません（既定ではおよそ90日、どこからも指されていないコミットはおよそ30日で消えることがあります）。気づいたら早めに取り戻しましょう。
- `git reset --hard rescue` のように `--hard` で戻すこともできますが、まだコミットしていない変更が消えるので、ブランチを作る方法が安全です。

**関連**：[5日目](../docs/day05-undo.md)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)、[Appendix：Git の内部のしくみ](../appendix/git-internals.md)
