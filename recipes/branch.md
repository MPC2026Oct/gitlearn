# レシピ集：ブランチ・マージ・コンフリクト

[レシピ集の目次](README.md) ｜ [README（全体の地図）](../README.md)

ブランチを作る・切り替える・消す、マージする、コンフリクトを解決する、についてのレシピです。

- [branch-01 ブランチの一覧と、今いるブランチを確認したい](#branch-01)
- [branch-02 新しいブランチを作って切り替えたい](#branch-02)
- [branch-03 未コミットの変更があってブランチを切り替えられない](#branch-03)
- [branch-04 ブランチを削除したい（手元・GitHub・追跡ブランチ）](#branch-04)
- [branch-05 ブランチを取り込みたい（マージ）](#branch-05)
- [branch-06 コンフリクトを解決したい／マージをやめたい](#branch-06)
- [branch-07 間違えて main で作業してしまった変更を、新しいブランチに移したい](#branch-07)
- [branch-08 作業中のブランチに main の最新を取り込みたい](#branch-08)

> [!NOTE]
> コマンドはすべて VS Code 内の Git Bash で、リポジトリのフォルダに `cd` してから実行します。`<...>` の部分は、かっこごと置き換えてから実行してください。ブランチ名の例として、ひとり練習では `add-favorites`、チーム開発では `<GitHubユーザー名>/add-member-page` を使います。画面の説明は執筆時点（2026年10月）の表示です。出力例のハッシュ値は人によって違います。

---

<a id="branch-01"></a>
## branch-01 ブランチの一覧と、今いるブランチを確認したい

**こんなとき**：どんなブランチがあるか、今どのブランチで作業しているかを確かめたいとき。

**Git Bash**：

手元のブランチの一覧を表示します。`*` が付いているのが今いるブランチです。

```bash
git branch
```

```text
  add-favorites
* main
```

GitHub 側のブランチ（リモート追跡ブランチ）も含めて表示します。

```bash
git branch -a
```

```text
  add-favorites
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
```

各ブランチの最新コミットと、GitHub のどのブランチと対応しているか（上流ブランチ）、どれだけ進んでいるかを表示します。

```bash
git branch -vv
```

```text
  add-favorites 1748a52 [origin/add-favorites] 好きなものリストを追加
* main          08c0cc1 [origin/main: ahead 1] 趣味を追加
```

（`ahead 1` は「手元の方が1コミット進んでいる＝まだ push していないコミットが1つある」という意味です。）

`git status` の1行目（`On branch main`）でも、今いるブランチがわかります。

**VS Code**：

- 今いるブランチ名は、画面左下のステータスバーに表示されています。
- そのブランチ名を選ぶと、画面上部にブランチの一覧が表示されます（`origin/` で始まるものは GitHub 側のブランチです）。何も選ばずに閉じるときは `Esc` を押します。

**注意点**：

- ほかの人が GitHub に作ったばかりのブランチは、`git fetch` するまで `git branch -a` に出てきません → [remote-06](remote.md#remote-06)
- 一覧が長くて `:` が出たら `q` で抜けます → [trouble-09](troubleshooting.md#trouble-09)

**関連**：[6日目](../docs/day06-branch.md)、[Appendix：ブランチとマージ](../appendix/branches-and-merge.md)、[Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="branch-02"></a>
## branch-02 新しいブランチを作って切り替えたい

**こんなとき**：`main` を直接変えずに、新しい作業を別のブランチで始めたいとき。

**Git Bash**：

新しいブランチを作って、すぐにそこへ切り替えます（`-c` は create＝作成の意味です）。

```bash
git switch -c add-favorites
```

```text
Switched to a new branch 'add-favorites'
```

チーム開発では、`<GitHubユーザー名>` の部分をかっこごと置き換えて、次のような名前にします。

```bash
git switch -c <GitHubユーザー名>/add-member-page
```

すでにあるブランチに切り替えるときは、`-c` を付けません。

```bash
git switch main
```

**VS Code**：

1. 画面左下のステータスバーのブランチ名を選びます。
2. 画面上部の一覧から「＋ 新しいブランチの作成...（Create new branch...）」を選びます。
3. ブランチ名を入力して Enter を押します。作ったブランチに自動で切り替わります。

コマンドパレット（`Ctrl+Shift+P`）の「Git: ブランチの作成...（Git: Create Branch...）」でも同じことができます。既存のブランチに切り替えるときは、手順2の一覧からブランチ名を選びます。

**注意点**：

- 新しいブランチは **今いるブランチの今のコミット** から作られます。たいていは `main` に切り替えて、最新にしてから（チームなら `git pull` してから）作ります。
- ブランチ名には、スペースや日本語を使わず、英小文字・数字・ハイフン（`-`）・スラッシュ（`/`）で、内容がわかる名前を付けます。
- 未コミットの変更は、切り替えた先のブランチにそのまま持ち越されます。切り替えられないときは → [branch-03](#branch-03)
- 新しいブランチを GitHub に送るときは → [remote-04](remote.md#remote-04)。ほかの人のブランチに切り替えたいときは → [remote-07](remote.md#remote-07)

**関連**：[6日目](../docs/day06-branch.md)、[10日目](../docs/day10-pull-request.md)、[Appendix：ブランチとマージ](../appendix/branches-and-merge.md)

---

<a id="branch-03"></a>
## branch-03 未コミットの変更があってブランチを切り替えられない

**こんなとき**：`git switch` したら、次のようなエラーが出て切り替えられなかったとき。

```text
error: Your local changes to the following files would be overwritten by checkout:
	profile.md
Please commit your changes or stash them before you switch branches.
Aborting
```

（今のブランチで変更したファイルが、切り替え先のブランチでは違う内容になっているため、切り替えると変更が上書きされてしまう、という意味です。）

**Git Bash**：変更をどうしたいかで、次のどれかを選びます。

**A. 変更をコミットしてから切り替える**（今のブランチで続ける作業の場合。いちばんおすすめ）

```bash
git add .
git commit -m "自己紹介の途中まで"
git switch main
```

**B. 変更を一時的に退避して切り替える**（あとで今のブランチに戻って続ける場合）

```bash
git stash push -u -m "自己紹介の途中"
git switch main
```

元のブランチに戻ったら、退避した変更を戻します。

```bash
git switch add-favorites
git stash pop
```

**C. 変更が要らないなら、捨ててから切り替える**

```bash
git restore .
git switch main
```

**VS Code**：ステータスバーからブランチを切り替えようとすると、「ローカルの変更は、チェックアウトによって上書きされます。」という確認が出ます。

- 「スタッシュしてチェックアウト（Stash & Checkout）」：変更を退避して切り替えます（B と同じ）。
- 「変更の移行（Migrate Changes）」：変更を切り替え先に持っていきます（切り替え先で変更がぶつかるとコンフリクトになります）。
- 「チェックアウトの強制（Force Checkout）」：**変更を捨てて** 切り替えます（C と同じ）。

迷ったら「キャンセル」して、ソース管理ビューでコミット（A）してから切り替えるのが安全です。

**注意点**：

- 変更したファイルが切り替え先と衝突しない場合は、エラーにならず、変更が **そのまま切り替え先に持ち越されます**。どのブランチで作業しているか、ステータスバーでこまめに確認しましょう。
- C の方法と「チェックアウトの強制」で捨てた変更は取り戻せません。
- stash を戻すときにコンフリクトすることがあります → [undo-07](undo.md#undo-07)
- 同じエラーが `git pull` や `git merge` で出たときは → [trouble-05](troubleshooting.md#trouble-05)

**関連**：[6日目](../docs/day06-branch.md)、[undo-07](undo.md#undo-07)、[trouble-05](troubleshooting.md#trouble-05)

---

<a id="branch-04"></a>
## branch-04 ブランチを削除したい（手元・GitHub・追跡ブランチ）

**こんなとき**：マージが終わって使わなくなったブランチを片付けたいとき。GitHub 上のブランチや、`git branch -a` に残っている `remotes/origin/...` も消したいとき。

ブランチは「手元」「GitHub」「手元にある GitHub の写し（リモート追跡ブランチ）」の3か所にあり、それぞれ別々に消します。

**Git Bash**：

**① 手元のブランチを消す**：消したいブランチ以外（ふつうは `main`）に切り替えてから消します。

```bash
git switch main
git branch -d add-favorites
```

```text
Deleted branch add-favorites (was 1748a52).
```

**② GitHub 上のブランチを消す**：`<GitHubユーザー名>` の部分は、かっこごと置き換えてから実行します。

```bash
git push origin --delete <GitHubユーザー名>/add-member-page
```

```text
To https://github.com/<運営者のアカウント>/gitlearn-team-a.git
 - [deleted]         hydr4/add-member-page
```

（`hydr4` や `gitlearn-team-a` の部分は、人やチームによって違います。）

**③ GitHub で消されたブランチの写し（`remotes/origin/...`）を手元から消す**：

```bash
git fetch --prune
```

```text
 - [deleted]         (none)     -> origin/hydr4/add-member-page
```

**GitHub（ブラウザ）**：PR をマージした直後なら、PR の画面に出る **Delete branch** ボタンで GitHub 上のブランチを消せます（②と同じ）。リポジトリの **Branches** 画面（ブランチ一覧）のごみ箱アイコンからも消せます。

**VS Code**：

- 手元のブランチ：コマンドパレット（`Ctrl+Shift+P`）で「Git: ブランチの削除...（Git: Delete Branch...）」を選び、消すブランチを選びます。
- GitHub 上のブランチ：「Git: リモート ブランチの削除...（Git: Delete Remote Branch...）」を選びます。
- 追跡ブランチの片付け：「Git: フェッチ (Prune)（Git: Fetch (Prune)）」を選びます。

**注意点**：

- 今いるブランチは消せません。先に `git switch main` で移動します。
- `-d` は、**まだマージしていないブランチを消そうとすると止めてくれます**（`error: the branch '...' is not fully merged` と表示されます）。本当に要らない場合だけ、`-D`（大文字）で強制的に消します。間違えて消したときは → [undo-08](undo.md#undo-08)
- GitHub の PR で **Squash and merge** や **Rebase and merge** を使ってマージした場合、手元の Git からは「マージされていない」と見えるため、`-d` で消せないことがあります。GitHub で PR がマージ済み（**Merged**）になっていることを確かめてから `-D` で消してください。
- ほかの人が使っているブランチを GitHub から消さないでください。

**関連**：[6日目](../docs/day06-branch.md)、[10日目](../docs/day10-pull-request.md)、[14日目](../docs/day14-release-retrospective.md)、[Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md)

---

<a id="branch-05"></a>
## branch-05 ブランチを取り込みたい（マージ）

**こんなとき**：ブランチでの作業が終わったので、その変更を `main` に取り込みたいとき（ひとりで練習しているとき。チームでは PR でマージします → [github-10](github.md#github-10)）。

**Git Bash**：

1. **取り込む側**（ここでは `main`）に切り替えます。

```bash
git switch main
```

2. 取り込みたいブランチを指定してマージします。

```bash
git merge add-favorites
```

`main` がブランチを作ったときから進んでいなければ、`main` が前に進むだけの **fast-forward**（早送り）マージになります。

```text
Updating 08c0cc1..1748a52
Fast-forward
 favorites.md | 1 +
 1 file changed, 1 insertion(+)
```

両方のブランチが進んでいた場合は、2つをまとめる **マージコミット** が作られます。メッセージを書くエディタ（VS Code のタブ）が開いたら、そのまま保存してタブを閉じれば完了します。

3. 結果を確認します。

```bash
git log --oneline --graph --all
```

**VS Code**：

1. ステータスバーのブランチ名を選び、取り込む側（`main`）に切り替えます。
2. コマンドパレット（`Ctrl+Shift+P`）で「Git: マージ...（Git: Merge...）」を選びます。
3. 取り込みたいブランチ（`add-favorites`）を選びます。

**注意点**：

- `git merge add-favorites` は「今いるブランチに add-favorites を取り込む」という意味です。**向きを間違えやすい** ので、マージの前に `git status` で今いるブランチを確認してください。
- マージの前に、両方のブランチで変更をコミットしておきます（未コミットの変更があると止まることがあります）。
- 同じ行を両方で変えているとコンフリクトになります → [branch-06](#branch-06)
- マージが終わったブランチは削除して片付けます → [branch-04](#branch-04)

**関連**：[6日目](../docs/day06-branch.md)、[7日目](../docs/day07-merge-conflict.md)、[Appendix：ブランチとマージ](../appendix/branches-and-merge.md)

---

<a id="branch-06"></a>
## branch-06 コンフリクトを解決したい／マージをやめたい

**こんなとき**：`git merge` や `git pull` をしたら、次のように表示されて止まったとき。

```text
Auto-merging meeting.md
CONFLICT (content): Merge conflict in meeting.md
Automatic merge failed; fix conflicts and then commit the result.
```

コンフリクト（conflict、競合）は、2つのブランチが **同じファイルの同じ行** を違う内容に変えたときに起こります。Git がどちらを残すか決められないので、人が決めます。

**Git Bash**：

1. どのファイルがコンフリクトしているか確認します（`both modified` と表示されます）。

```bash
git status
```

2. そのファイルを VS Code で開きます（例は [7日目](../docs/day07-merge-conflict.md) の練習用リポジトリ `conflict-lab` の `meeting.md` です）。次のような **コンフリクトマーカー** が入っています。

```text
<<<<<<< HEAD
- 場所: 学生会館 3階 多目的室
=======
- 場所: オンライン（ビデオ通話）
>>>>>>> change-place
```

`<<<<<<< HEAD` から `=======` までが今いるブランチの内容、`=======` から `>>>>>>>` までが取り込もうとしたブランチの内容です。

3. 残したい内容になるようにファイルを書き換え、**`<<<<<<<` `=======` `>>>>>>>` の行をすべて消して** 保存します。

```text
- 場所: オンライン（ビデオ通話）
```

4. 解決したファイルをステージし、コミットしてマージを完了します。`--no-edit` を付けると、自動で作られたメッセージ（`Merge branch '...'`）のままコミットされます。

```bash
git add meeting.md
git commit --no-edit
```

**マージをやめて、マージ前の状態に戻したいとき**：

```bash
git merge --abort
```

**VS Code**：

1. 「ソース管理（Source Control）」ビューの「変更のマージ（Merge Changes）」に、コンフリクトしたファイルが表示されます（右に `!` が付きます）。ファイルを選んで開きます。
2. コンフリクトの部分の上に、次のボタンが並びます。
   - 「現在の変更を取り込む（Accept Current Change）」：今いるブランチ（HEAD）の内容を残す
   - 「入力側の変更を取り込む（Accept Incoming Change）」：取り込もうとしたブランチの内容を残す
   - 「両方の変更を取り込む（Accept Both Changes）」：両方を残す（あとで手で整える）
3. どれかを選ぶか、手で書き換えて、マーカーが残っていないことを確かめて保存します。
4. ファイルの「＋」（変更をステージ（Stage Changes））でステージします。
5. メッセージ欄に `Merge branch '...'` が入っているので、「✓ コミット（Commit）」を選びます。

画面右下の「マージ エディターで解決（Resolve in Merge Editor）」ボタンを使うと、左右に両方の内容、下に結果が並ぶ **マージエディター** で解決できます。結果を整えたら「マージの完了（Complete Merge）」を選び、手順4〜5へ進みます。

マージをやめるときは、コマンドパレット（`Ctrl+Shift+P`）の「Git: マージの中止（Git: Abort Merge）」を使います。

**注意点**：

- マーカーの行（`<<<<<<<`、`=======`、`>>>>>>>`）が1つでも残ったままコミットすると、その行もファイルに記録されてしまいます。コミット前に必ず確かめてください。
- 解決の途中で、どうしていいかわからなくなったら、`git merge --abort` で最初からやり直せます（マージ前にコミットしていた内容は消えません）。
- `git pull` でのコンフリクトも、同じ手順で解決します。解決したら `git push` を忘れずに。
- GitHub の PR で起きたコンフリクトは → [github-09](github.md#github-09)、またはこのレシピの手順で手元で解決します（[branch-08](#branch-08)）。
- `git commit` でエディタが開いた場合は、保存してタブを閉じれば完了です → [setup-03](setup.md#setup-03)

**関連**：[7日目](../docs/day07-merge-conflict.md)、[12日目](../docs/day12-team-conflict.md)、[Appendix：ブランチとマージ](../appendix/branches-and-merge.md)、出典：[VS Code ドキュメント Merge conflicts](https://code.visualstudio.com/docs/sourcecontrol/merge-conflicts)

---

<a id="branch-07"></a>
## branch-07 間違えて main で作業してしまった変更を、新しいブランチに移したい

**こんなとき**：ブランチを作るのを忘れて、`main` のまま編集やコミットをしてしまったとき（まだ push していない）。

**Git Bash**：

**A. まだコミットしていない場合**：新しいブランチを作って切り替えるだけで、変更はそのまま持っていけます。

```bash
git switch -c add-hobby
git status
```

あとは、いつもどおりステージしてコミットします。`main` は何も変わっていません。

**B. すでに `main` にコミットしてしまった場合**（まだ push していない）：

1. 未コミットの変更が残っていないことを確認します（`nothing to commit, working tree clean` と出れば OK。残っていたら先にコミットします）。

```bash
git status
```

2. 今の位置に新しいブランチを作ります（切り替えはしません）。間違えたコミットは、このブランチに残ります。

```bash
git branch add-hobby
```

3. `main` を GitHub の `main`（`origin/main`）と同じ位置に戻します。

```bash
git reset --hard origin/main
```

4. 新しいブランチに切り替えて、コミットが移っていることを確認します。

```bash
git switch add-hobby
git log --oneline --graph --all
```

GitHub につないでいないリポジトリ（`origin` がない）の場合は、手順3を `git reset --hard HEAD~1`（間違えたコミットが1つの場合。2つなら `HEAD~2`）にします。

**VS Code**：

- A の場合：ステータスバーのブランチ名 →「新しいブランチの作成...（Create new branch...）」で新しいブランチを作ると、変更がそのまま移ります。
- B の場合：GUI だけで行う方法はありません。ターミナルで実行します。

**注意点**：

- B の手順3の `git reset --hard` は、**未コミットの変更を消します**。必ず手順1で確認してから実行してください。手順2で作ったブランチにコミットが残っているので、コミット自体は消えません。
- **すでに `main` を push してしまった場合は、この方法を使わないでください**。チームの `main` に入ってしまった変更は [undo-05](undo.md#undo-05) の `git revert` で打ち消します。
- 間違えて実行しても、[undo-08](undo.md#undo-08) の reflog で取り戻せることがあります。

**関連**：[6日目](../docs/day06-branch.md)、[undo-04](undo.md#undo-04)、[Appendix：取り消しの詳細](../appendix/undo-in-depth.md)

---

<a id="branch-08"></a>
## branch-08 作業中のブランチに main の最新を取り込みたい

**こんなとき**：自分のブランチで作業している間に、ほかの人の PR が `main` にマージされたとき。PR にコンフリクトが出たので、手元で解決したいとき。`main` の新しい内容を使って作業を続けたいとき。

**Git Bash**：

1. 自分の変更をコミットしておきます（`git status` で `working tree clean` になっていることを確認します）。

```bash
git status
```

2. GitHub の最新を取得します（取得するだけで、ファイルはまだ変わりません）。

```bash
git fetch origin
```

3. 自分のブランチにいることを確認し、GitHub の `main`（`origin/main`）を取り込みます。`<GitHubユーザー名>` の部分は、かっこごと置き換えてから実行します。

```bash
git switch <GitHubユーザー名>/add-member-page
git merge origin/main
```

マージコミットのメッセージを書くタブが開いたら、そのまま保存して閉じます。コンフリクトが起きたら [branch-06](#branch-06) の手順で解決します。

4. 結果を GitHub に送ります。PR を出している場合は、PR が自動で更新されます。

```bash
git push
```

**別の方法**：手元の `main` も一緒に最新にしたいときは、次の順でも同じ結果になります。

```bash
git switch main
git pull
git switch <GitHubユーザー名>/add-member-page
git merge main
```

**VS Code**：

1. 自分のブランチにいることをステータスバーで確認します。
2. コマンドパレット（`Ctrl+Shift+P`）で「Git: フェッチ（Git: Fetch）」を選びます。
3. 続けて「Git: マージ...（Git: Merge...）」を選び、`origin/main` を選びます。
4. コンフリクトしたら [branch-06](#branch-06) の VS Code の手順で解決します。
5. 「変更の同期（Sync Changes）」ボタン（またはステータスバーの ↑ の数字）で push します。

**注意点**：

- `git merge origin/main` の前に `git fetch` を忘れると、古い `main` を取り込むことになります。
- こまめに（作業を始める前や PR を出す前に）`main` を取り込むと、大きなコンフリクトを防げます。
- `merge` の代わりに `rebase` で取り込む方法もあります。ただし push 済みのブランチを rebase すると `git push` が拒否されるので、この教材では `merge` を使います → [Appendix：rebase](../appendix/rebase.md)

**関連**：[12日目](../docs/day12-team-conflict.md)、[13日目](../docs/day13-final-project.md)、[remote-06](remote.md#remote-06)、[Appendix：リモート追跡ブランチ](../appendix/remote-tracking.md)、[Appendix：rebase](../appendix/rebase.md)
