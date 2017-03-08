#!/bin/bash
function __status() {
    local branch="$(__git_ps1 '(%s)')"
    local _stats=""

    if [[ ! -z $branch ]]; then
        # Git
        local changes="$(git status --porcelain | wc -l )"
        local _repo_name="$(git remote show origin -n | grep 'Fetch URL:' | sed -E 's#^.*/(.*)$#\1#' | sed 's#.git$##')"
        local _commits="$(git status -sb | grep -oP '\[\K[^\]]+')"
        local commit_num="$(cut -d' ' -f2 <<<"$_commits")"
        local commit_position="$(cut -d' ' -f1 <<<"$_commits")"

        # Repo name
        _stats+="$txtbold$txtred$_repo_name "
        # Branch
        _stats+="$txtcyan$branch "


        # Commited changes
        if [[ $commit_num > 0 ]]; then
            _stats+="$txtbold$txtgreen$commit_num $txtreset$commit_position "
        fi

        # Uncommited changes
        if [[ $changes > 0 ]]; then
            _stats+="$txtwhite$changes$txtreset changes"
        fi



    else
        # File
        local _all_count="$(ls -1 | wc -l)"
        local _folder_count="$(ls -1 -p | grep "/" | wc -l)"
        local _file_count=$(($_all_count - $_folder_count))
        local _dir_size="$(ls -lah | grep -m 1 total | sed 's/total //')B"

        # Current dirname
        _stats+="$txtbold$txtcyan\W$txtreset: "
        # Folder count
        _stats+="$_folder_count dirs"
        # File count
        _stats+=", $_file_count files"
        # Directory size
        _stats+=", $_dir_size"
    fi

    _stats+="$txtreset\n"
    echo "$_stats"
}

function set_prompt() {
    # Return code
    local last_cmd=$?

    # Colours
    local txtreset="$(tput sgr0)"
    local txtbold="$(tput bold)"
    local txtblack="$(tput setaf 0)"
    local txtred="$(tput setaf 1)"
    local txtgreen="$(tput setaf 2)"
    local txtyellow="$(tput setaf 3)"
    local txtblue="$(tput setaf 4)"
    local txtpurple="$(tput setaf 5)"
    local txtcyan="$(tput setaf 6)"
    local txtwhite="$(tput setaf 7)"    

## Line 1 ##
    PS1="\n"
    # time
    PS1+="$txtwhite$txtbold\A "
    # user
    PS1+="$txtgreen\u:"
    # directory
    PS1+="$txtyellow[\w] "

    # host
    # PS1+="$txtreset$txtpurple(\h)"

    PS1+="\n"

## Line 2 ##
    PS1+="$(__status)"

    # trail
    PS1+="$ "
}

PROMPT_COMMAND='set_prompt'