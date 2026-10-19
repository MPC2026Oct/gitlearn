# 発展（任意）：rebase を試す

説明ページ：[13日目：最終課題に取り組む](../../docs/day13-final-project.md)　／　詳しい解説：[rebase（Appendix）](../../appendix/rebase.md)

## 目的

`git rebase main` が何をするのかを、手元の `my-profile` で試して理解します。

> [!CAUTION]
> rebase は履歴を書き換えます。**他の人と共有しているブランチ（push 済みで、他の人も使っているブランチ）では使いません。** この課題は、自分だけが使う `my-profile` で行います。

## 所要時間の目安

20〜30分

## 準備

`~/git-practice/my-profile` で `git status` が `working tree clean` であることを確認します。

```bash
cd ~/git-practice/my-profile
git status
```

## パート1：コンフリクトなし版

`main` と作業ブランチで、**別のファイル** を変更します。

1. 作業ブランチを作り、`favorites.md` に1行追記してコミットします。

   ```bash
   git switch -c rebase-practice1
   echo "- rebase の練習" >> favorites.md
   git commit -am "favorites に1行追記"
   ```

2. `main` に戻り、`hobbies.md` に1行追記してコミットします。

   ```bash
   git switch main
   echo "- rebase を試すこと" >> hobbies.md
   git commit -am "hobbies に1行追記"
   ```

3. 履歴の形を見ます（枝分かれしています）。

   ```bash
   git log --oneline --graph --all
   ```

4. 作業ブランチに戻り、`main` の上に載せ替えます。

   ```bash
   git switch rebase-practice1
   git rebase main
   ```

5. もう一度、履歴の形を見ます。

   ```bash
   git log --oneline --graph --all
   ```

   枝分かれが **1本の線** になり、`rebase-practice1` のコミットが `main` の先頭の後ろに並んでいます。コミットのハッシュ値が変わっていることにも注目します。
6. `main` に取り込みます。

   ```bash
   git switch main
   git merge rebase-practice1
   git branch -d rebase-practice1
   ```

## パート2：コンフリクトあり版

`main` と作業ブランチで、**同じ行** を変更します。

1. 作業ブランチを作り、`profile.md` のニックネームの行を書き換えてコミットします。

   ```bash
   git switch -c rebase-practice2
   ```

   VS Code で `profile.md` のニックネームの行を「ブランチ側の名前」に書き換え、保存します。

   ```bash
   git commit -am "ニックネームをブランチ側で変更"
   ```

2. `main` に戻り、**同じ行** を別の内容に書き換えてコミットします。

   ```bash
   git switch main
   ```

   VS Code で同じ行を「main 側の名前」に書き換え、保存します。

   ```bash
   git commit -am "ニックネームを main 側で変更"
   ```

3. 作業ブランチで rebase します。

   ```bash
   git switch rebase-practice2
   git rebase main
   ```

   `CONFLICT` と出て、rebase が途中で止まります。
4. VS Code で `profile.md` を開き、7日目と同じようにコンフリクトを解決します（どちらか、または新しい名前にする）。
5. 解決を伝えて、rebase を続けます。**`git commit` ではなく `git rebase --continue` です。**

   ```bash
   git add profile.md
   git rebase --continue
   ```

   `git rebase --continue` を実行すると、VS Code にコミットメッセージ（`COMMIT_EDITMSG`）のタブが開き、ターミナルは `hint: Waiting for your editor to close the file...` と表示して待ち状態になります（1日目に `core.editor` を `code --wait` に設定したためで、固まったわけではありません）。内容を確かめてタブを閉じると rebase が完了し、`Successfully rebased and updated refs/heads/rebase-practice2.` と表示されます。

6. やめたくなったら、`git rebase --abort` で、rebase を始める前の状態に戻れます。
7. `main` に取り込んで片付けます。

   ```bash
   git switch main
   git merge rebase-practice2
   git branch -d rebase-practice2
   ```

## 完了条件

- [ ] パート1で、`git log --oneline --graph --all` の枝分かれが1本の線になった
- [ ] rebase の前後で、コミットのハッシュ値が変わることを確認した
- [ ] パート2で、`git rebase --continue` で rebase を終えられた（または `--abort` で取りやめた）
- [ ] 「共有しているブランチでは rebase を使わない」理由を説明できる

## ヒント

- 途中で状態がわからなくなったら、`git status` を見ます。「rebase in progress」と書かれていたら、rebase の途中です。
- 困ったら `git rebase --abort` で元に戻せます。
- `git commit -am` は、すでに追跡している（コミット済みの）ファイルの変更を、まとめてステージしてコミットします。新しいファイルは含まれません。
- この課題で使うファイル（`profile.md`、`hobbies.md`、`favorites.md`）が `my-profile` にない場合は、これまでの日の演習を済ませるか、同じ名前のファイルを作ってコミットしてください。
