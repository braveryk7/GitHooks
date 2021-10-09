# このリポジトリについて
このリポジトリは、GitHooksを利用して以下の制約をプロジェクトに導入することを目的に作成されました。

* チケット駆動開発の遵守
* ブランチ命名規則の遵守
* 各種Linterを自動実行

このGitHooksを利用することで、チーム開発の体験を向上させることが可能です。

## 使い方
npm、composerのscriptsを使用して`ghinit`コマンドを作成、実行してください。

`ghinit`コマンドは以下の内容です。

```bash
curl https://raw.githubusercontent.com/braveryk7/GitHooks/main/conf/init.sh > conf/init.sh && sh conf/init.sh
```

https://raw.githubusercontent.com/braveryk7/GitHooks/main/conf/init.sh は当リポジトリのいくつかのファイルをダウンロードし、自動的に設定を完了するプログラムです。

package.json、composer.jsonに`ghinit`コマンドを設定しgitリポジトリに含めておけば新しいメンバーがプロジェクトに参加した時も`npm install`や`composer install`するだけでGitHooksを強制させることが可能です。

```json:package.json
# postinstallフックを使い、npm install時に自動実行

"scripts": {
    "postinstall": "ghinit",
    "ghinit": "curl https://raw.githubusercontent.com/braveryk7/GitHooks/main/conf/init.sh > conf/init.sh && sh conf/init.sh"
}
```

```json:composer.json
# post-install-cmdフックを使い、composer install時に自動実行

"scripts": {
    "post-install-cmd": [
        "@ghinit"
    ],
    "ghinit": "curl https://raw.githubusercontent.com/braveryk7/GitHooks/main/conf/init.sh > conf/init.sh && sh conf/init.sh
}
```

`ghinit`コマンドは以下の初期設定を行っています。

1. `conf/init.sh`を作成
1. `.git/hooks`配下に`commit-msg`と`pre-commit`を設置
1. `commit-msg`と`pre-commit`に実行権限を付与
1. `conf`配下に`linter_config.sh`を設置
1. ESLint / StyleLint / PHP CodeSnifferと各設定ファイルのチェック
1. `conf/init.sh`の削除

## チケット駆動開発の遵守
コミットメッセージに自動的に参照先となるissueのチケット番号を付与することで、チケット番号を入れ忘れるというヒューマンエラーを排除できます。

チケット番号はブランチ名から自動取得されるため、そもそもブランチ名が命名規則に沿っていない場合コミットできません。

```command
$ git commit -m "test commit"
```

このコミットは、自動的に次のようなコミットメッセージになります。

```command
reft #3 test commit"
```

## ブランチ命名規則の遵守
チケット開発駆動を実現させるために必要なブランチ名をGitHooksで強制しています。

ブランチ名は次のフォーマットになっている必要があります。

```
<ticker>-<type>-<subject>
```

`<ticket>`はissueのチケット番号です。

先頭の`#`は必要ありません。

`<type>`は以下のいずれかが必要です。

* feat
* fix
* docs
* style
* refactor
* pref
* test
* chore

これ以外のtypeは全てコミットを拒否されます。

```
# ブランチ名の例
1-feat-user-register
72-docs-readme-update
```

## 各種Linterを自動実行
コミット前に各種静的解析ツール（Linter）を実行することで、コミット前に正しい構文になっていないヒューマンエラーを避けることが可能です。

現在対応しているLinterは以下の通りです。

* JavaScript / TypeScript
    * ESLint
* CSS / SCSS / SASS
    * StyleLint
* PHP
    * PHP CodeSniffer

### 使い方
`conf/linter_config.sh`が各種Linterを実行させるために必要なファイルです。

プロジェクトルートに`conf`ディレクトリを作成して、配下に`linter_config.sh`を設置してください。


実行自体は`pre-commit`から呼び出しています。

```bash:pre-commit
is_js=true
is_css=true
is_php=true
```

デフォルトではJavaScript / TypeScript / CSS / SCSS / SASS / PHP全てのステージされたファイルに対して静的解析を実行します。

不要な場合は`true`を`false`に変更してください。

#### ESLint
ESLinteはJavaScript / TypeScript用のLinterです。
使用する場合は必ず設定ファイルをプロジェクトルートに設置してください。
対応する設定ファイルは以下のいずれかです。

* .eslintrc.js
* .eslintrc.cjs
* .eslintrc.yaml
* .eslintrc.yml
* .eslintrc,json

#### StyleLint
StyleLintはCSS / SCSS / SASS用のLinterです。
使用する場合は必ず設定ファイルをプロジェクトルートに設置してください。
対応する設定ファイルは以下のいずれかです。

* .stylelintrc
* .stylelint.config.js
* .stylelint.config.cjs
* .stylelintrc.yaml
* .stylelintrc.yml
* .stylelintrc.json

#### PHP CodeSniffer
PHP CodeSnifferはPHP用のLinterです。
使用する場合は必ず設定ファイルをプロジェクトルートに設置してください。
対応する設定ファイルは以下のいずれかです。

* .phpcs.xml
* phpcs.xml
* .phpcs.xml.dist
* phpcs.xml.dist

# 免責事項
当プログラムを利用したいかなる不都合も製作者は責任を負いかねます。

# 更新履歴

## Ver 0.0.1 2021/10/8
製作開始