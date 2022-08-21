# tiny-snippet.vim

スニペット挿入プラグイン。

## Usage:

### スニペット入力

関数 `tinysnippet#Complete` を、 `completefunc` か `omnifunc` にセットして呼び出してください。

設定例 :

```vim
set completefunc=tinysnippet#Complete
```

### プレースホルダジャンプ・置換

`tinysnippet#select_next()` と `tinysnippet#select_prev()` で、プレースホルダへジャンプします。
これら関数をお好みのキーにマッピングしてください。

プレースホルダーへジャンプすると、プレースホルダーを選択した状態になるので、 `c` キーでプレースホルダを編集してください。

設定例 :

- インサートモード・ノーマルモード中に `<C-j>` で次のプレースホルダーへジャンプ
- インサートモード・ノーマルモード中に `<C-k>` で前のプレースホルダーへジャンプ

```vim
inoremap <silent> <C-j> <Esc>:call tinysnippet#select_next()<Enter>
nnoremap <silent> <C-j> <Esc>:call tinysnippet#select_next()<Enter>
inoremap <silent> <C-k> <Esc>:call tinysnippet#select_prev()<Enter>
nnoremap <silent> <C-k> <Esc>:call tinysnippet#select_prev()<Enter>
```

## 設定

### スニペット定義格納ディレクトリ

デフォルト設定では、プラグインルートディレクトリ直下の `snippets` ディレクトリがスニペットディレクトリになっています。

カスタマイズしたい場合には、 `g:tiny_snippet_snippet_directories_custom` に、スニペット定義を格納するディレクトリのリストを設定してください。

設定例 :

```vim
let g:tiny_snippet_snippet_directories_custom = ["/PATH/TO/SNIPPET/DIRECTORY/1", /PATH/TO/SNIPPET/DIRECTORY/2]
```


## スニペット定義ファイル

`g:tiny_snippet_snippet_directories_custom` で指定したフォルダ内に、ファイルタイプ名のディレクトリを作成


ディレクトリ構造例 :

```
snippet_directory
    +- cpp/
    |    +- for.cpp
    |    +- cout.cpp
    +- java/
         +- for.java
         +- foreach.java
```

スニペットファイル例(for.cpp) :

```cpp
for (int ${1:variable} = 0; ${1:variable} < ${2:count}; ${1:variable}++) {
    ${3:cursor}
}
```



## 制限事項

- 何も考えずに `autocmd CompleteDone` を利用しているため、他の補完プラグインを使用すると多分挙動が壊れます
- スニペットの一括置換が有効なのは、最後に挿入したスニペットのみです。また、別の補完を挟むと正しく一括置換ができなくなります


## License:

Copyright (C) 2022 mikoto2000

This software is released under the MIT License, see LICENSE

このソフトウェアは MIT ライセンスの下で公開されています。 LICENSE を参照してください。


## Author:

mikoto2000 <mikoto2000@gmail.com>
