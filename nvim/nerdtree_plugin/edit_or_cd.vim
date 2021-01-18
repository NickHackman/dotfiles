" NERDTree either Open a file or change directory to the directory
function! OpenFileOrCd()
    let treenode = g:NERDTreeFileNode.GetSelected()
    if treenode == {}
        return
    endif

    if treenode.path.isDirectory
        call b:NERDTree.changeRoot(treenode)
    else
        execute 'edit ' . treenode.path.str()
    endif
endfunction

call NERDTreeAddKeyMap({'key': '<CR>', 'callback': 'OpenFileOrCd', 'quickhelpText': 'Open a file or change directory'})
