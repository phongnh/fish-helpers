function wd -d "Quickly cd in $HOME/projects"
    set -l dir
    for dir in $WORKING_DIRS
        builtin cd "$dir/$argv[1]" 2>/dev/null
        if test $status -eq 0
            break
        end
    end
end

complete --exclusive --command wd --arguments '(__fish_complete_cwd $WORKING_DIRS)'
