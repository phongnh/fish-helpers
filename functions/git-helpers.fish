function update-git-repos -d "Update all git repositories in current folder"
    set -l cwd (pwd)
    set -l dir "$argv[1]"
    if test -z "$dir"
        set dir "$cwd"
    else
        cd "$dir"
        set dir (pwd)
    end
    echo "*** Dir: $dir"
    for project in "$dir"/*
        if test ! -d "$project"
            continue
        end
        cd "$project"
        test -d .git ;and echo "--> Updating $project" ;and git sync
        test ""(basename $project)"" = "deployment" ;and update-git-repos
    end
    set -l git_hosts  "9fans.net" "bitbucket.org" "github.com" "golang.org" "gopkg.in"  "honnef.co"
    for git_host in $git_hosts
        if test ""(basename $dir)"" = "$git_host"
            for project in "$dir"/*
                update-git-repos "$project"
            end
        end
    end
    cd "$cwd"
end

function git-cleanup -d "Cleanup git repo"
    echo "--> Cleanup" (pwd)
    git cleanup
end

function cleanup-git-repos -d "Cleanup all git repositories in current folder"
    set -l cwd (pwd)
    set -l dir "$argv[1]"
    if test -z "$dir"
        set dir "$cwd"
    else
        cd "$dir"
        set dir (pwd)
    end
    echo "*** Dir: $dir"
    test -d "$dir"/.git ;and git-cleanup
    for project in "$dir"/*
        if test ! -d "$project"
            continue
        end
        cd "$project"
        test -d .git ;and git-cleanup
    end
    cd "$cwd"
end

function git-fix-permissions -d "Fix permission for git repo"
    echo "--> Fixing permissions" (pwd)
    git diff --summary | grep --color 'mode change 100755 => 100664' | cut -d' ' -f7- | xargs -t -I\n chmod +x \n
    git diff --summary | grep --color 'mode change 100755 => 100644' | cut -d' ' -f7- | xargs -t -I\n chmod +x \n
    git diff --summary | grep --color 'mode change 100664 => 100755' | cut -d' ' -f7- | xargs -t -I\n chmod -x \n
    git diff --summary | grep --color 'mode change 100644 => 100755' | cut -d' ' -f7- | xargs -t -I\n chmod -x \n
end

function fix-permissions-git-repos -d "Fix permissions for git repositories in current folder"
    set -l cwd (pwd)
    set -l dir "$argv[1]"
    if test -z "$dir"
        set dir "$cwd"
    else
        cd "$dir"
        set dir (pwd)
    end
    echo "*** Dir: $dir"
    test -d "$dir"/.git ;and git-fix-permissions
    for project in "$dir"/*
        if test ! -d "$project"
            continue
        end
        cd "$project"
        test -d .git ;and git-fix-permissions
        test ""(basename $project)"" = "deployment" ;and fix-permissions-git-repos
    end
    set -l git_hosts  "9fans.net" "bitbucket.org" "github.com" "golang.org" "gopkg.in"  "honnef.co"
    for git_host in $git_hosts
        if test ""(basename $dir)"" = "$git_host"
            for project in "$dir"/*
                fix-permissions-git-repos "$project"
            end
        end
    end
    cd "$cwd"
end
