" 最後の補完文字列の開始行・終了行
let s:last_snippet_start_line = 0
let s:last_snippet_end_line = 0

" プレースホルダー or タブストップにマッチする正規表現
let s:pattern_of_tabstop_or_placeholder = '\(\${\d\{-\}:\w\{-\}}\|\$\d\)'

function! tinysnippet#Complete(findstart, base) abort
    if a:findstart
        " 単語の先頭を探す
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    endif

    " カーソル位置記録
    let s:pos = getpos(".")
    let s:last_snippet_start_line = s:pos[1]

    " スニペット補完完了コールバックの設定
    augroup snippet_complete_done
        autocmd!
        autocmd CompleteDone <buffer> call tinysnippet#SnippetCompleteDoneCallback()
    augroup END


    " ファイルタイプ取得
    let l:filetype = &filetype


    " スニペット検索ディレクトリを探す
    let l:target_directories = []
    if !exists('g:tiny_snippet_snippet_directories_custom')
        " カスタム定義が無い場合、デフォルトを使用
        for d in g:tiny_snippet_snippet_directories_default
            let l:target_directories = l:target_directories + split(glob(l:d), "\n")
        endfor
    else
        " カスタム定義がある場合、そちらを使用
        for d in g:tiny_snippet_snippet_directories_custom
            let l:target_directories = l:target_directories + split(glob(l:d), "\n")
        endfor
    endif

    " スニペット検索ディレクトリからスニペットファイルを探して補完候補作成
    for d in l:target_directories
        let l:files = split(glob(l:d . '/' . l:filetype . '/' . a:base . '*'), "\n")
        for f in l:files
            let l:file_contents = readfile(fnamemodify(l:f, ':p'))
            let l:complete_item = {'word': join(l:file_contents, "\n"), 'abbr': fnamemodify(l:f, ':t:r')}

            call complete_add(l:complete_item)

            if complete_check()
                break
            endif
        endfor
    endfor

    return []
endfunction


function! tinysnippet#SnippetCompleteDoneCallback() abort
    autocmd! snippet_complete_done

    " 補完アイテム確認
    if empty(v:completed_item) || get(v:completed_item, 'word', '') ==# '' && get(v:completed_item, 'abbr', '') ==# ''
        return
    endif

    let s:last_snippet_end_line = getpos(".")[1] - 1

    " カーソル位置復元
    delete _
    call setpos(".", s:pos)

endfunction


function! tinysnippet#EditedPlaceHolderCallback() abort
    autocmd! snippet_edit

    " カーソル位置記録
    let l:pos = getpos(".")

    " 最後に保管したテキスト範囲内の全プレースホルダを置換
    try
        execute s:last_snippet_start_line . "," . s:last_snippet_end_line . "s/" . @+ . "/" . @. . "/g"
    catch
        " 「置換対象が見つからないエラー」を握りつぶす
    endtry

    " カーソル位置復元
    call setpos(".", l:pos)
endfunction


function! tinysnippet#select_next() abort
    call tinysnippet#select_tabstop_or_placeholder('', 'e')
endfunction

function! tinysnippet#select_prev() abort
    call tinysnippet#select_tabstop_or_placeholder('eb', 'b')
endfunction

function! tinysnippet#select_tabstop_or_placeholder(first_search_option, second_search_option) abort
    " 編集後コールバックの設定
    augroup snippet_edit
        autocmd!
        autocmd InsertLeave <buffer> call tinysnippet#EditedPlaceHolderCallback()
    augroup END

    " 次のマークまで移動
    let l:line = search(s:pattern_of_tabstop_or_placeholder, a:first_search_option)

    " 見つからなければ何もしない
    if l:line == 0
        return
    endif

    " マーク末尾までを選択
    normal v
    call search(s:pattern_of_tabstop_or_placeholder, a:second_search_option)
endfunction

