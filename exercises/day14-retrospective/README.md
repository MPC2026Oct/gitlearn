# 14日目の演習：完成・リリース・ふりかえり

説明ページ：[14日目：完成・リリース・ふりかえり](../../docs/day14-release-retrospective.md)

## 目的

ガイドブックを完成させて `v1.0` の Release を作り、KPT（Keep / Problem / Try）で2週間をふりかえります。

## 所要時間の目安

60〜90分（チームで集まる日です）

## 手順

### 1. 最後の PR をマージする

1. 13日目の Issue がすべて Close になっているか確認します。残っていれば、今日のうちに PR を出してマージします。
2. `main` を最新にして、ガイドブックの表紙から全ページをたどれるか、GitHub 上で確認します。

   ```bash
   cd ~/git-practice/gitlearn-team-<チーム記号>
   git switch main
   git pull
   ```

### 2. Release `v1.0` を作る

1. 進行役（14日目は 4人チームなら B、3人チームなら C）が、GitHub の **Releases** → **Draft a new release** を開きます。
2. **Choose a tag** に `v1.0` と入力し、**Create new tag: v1.0 on publish** を選びます。ターゲットは `main` です。
3. タイトルを `v1.0` にし、本文に完成したガイドブックについて、2〜3行で書きます。
4. **Publish release** を押します。
5. 全員が、手元でタグを確かめます。

   ```bash
   git switch main
   git pull
   git fetch --tags
   git tag
   ```

### 3. ふりかえり（KPT）

1. 進行役が、「ふりかえり」Issue を作ります（本文に Keep / Problem / Try の説明を書きます）。
2. 全員が、自分のふりかえりをコメントします。

   ```markdown
   ## Keep（続けたいこと・よかったこと）
   - 

   ## Problem（困ったこと・つまずいたこと）
   - 

   ## Try（次にやってみたいこと）
   - 
   ```

3. 進行役が、コメントをまとめて `exercises/team-project/retrospective.md` を更新します。

   ```bash
   git switch -c <GitHubユーザー名>/retrospective
   ```

   編集してコミットし、`push` して PR を出します。`Closes #<Issue番号>` を入れ、レビュアーにはいつもの組の相手を指定します。Approve されたら、作成者（進行役）がマージします。

### 4. 2週間をふりかえる

説明ページ末尾の「2週間でできるようになったこと」のチェックリストを見て、自分ができるようになったことを確認します。

## 完了条件

- [ ] GitHub の **Releases** に `v1.0` がある
- [ ] 手元で `git tag` を実行すると `v1.0` が表示される
- [ ] 「ふりかえり」Issue に、自分の KPT のコメントがある
- [ ] `retrospective.md` を更新する PR がマージされている
- [ ] 2週間で身についたことを3つ、自分の言葉で挙げられる

## ヒント

- タグを作った直後は、手元に届いていません。`git fetch --tags` を忘れずに。
- KPT の「Problem」は、悪いことではなく、次にいかす材料です。正直に書きましょう。
- 「Try」は、小さくて具体的なことが続けやすいです（例：「自分の授業のレポートを Git で管理してみる」）。
- 「ふりかえり」Issue を作る前に、Release を作ってしまっても問題ありません。
