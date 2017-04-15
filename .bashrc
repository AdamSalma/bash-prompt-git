#!/bin/bash
function __status() {
    local branch="$(__git_ps1 '%s')"
    local stats=""

    # Git repo status
    if [[ ! -z $branch ]]; then
        local _status="$(git status --porcelain)"
        local _changes="$(echo "$_status" | grep 'M' | wc -l )"
        local unstaged="$(echo "$_status" | grep ' M' | wc -l )"
        local staged=$(($_changes - $unstaged))

        local repo_name="$(git remote show origin -n | grep 'Fetch URL:' | sed -E 's#^.*/(.*)$#\1#' | sed 's#.git$##')"

        local _commits="$(git status -sb | grep -oP '\[\K[^\]]+')"
        local commit_num="$(cut -d' ' -f2 <<<"$_commits")"
        local commit_position="$(cut -d' ' -f1 <<<"$_commits")"

        # Repo name
        stats+="$txtbold$txtred$repo_name "

        # Branch
        if [[ $commit_num > 0 ]]; then
            # Branch with ahead/behind
            stats+="$txtcyan($branch"

            if [[ $commit_position = "ahead" ]]; then
                stats+=" +$commit_num"
            else
                stats+=" -$commit_num"
            fi

            stats+=")$txtreset "
        else 
            # Normal branch without ahead/behind
            stats+="$txtcyan($branch)$txtreset "
        fi

        # Uncommited changes
        if [[ $_changes > 0 ]]; then
            if [[ $staged > 0 ]]; then
                # Number of staged changes
                stats+="$txtgreen$staged"
                if [[ $unstaged > 0 ]]; then
                    # Add '/'
                    stats+="$txtwhite$txtbold/$txtreset"
                fi
            fi

            if [[ $unstaged > 0 ]]; then
                # Number of unstaged changes
                stats+="$txtbold$txtred$unstaged"
            fi
            stats+="$txtreset changes "
        fi

    # File status; not in git repo
    else
        local _all_count="$(ls -1 | wc -l)"
        local _folder_count="$(ls -1 -p | grep "/" | wc -l)"
        local _file_count=$(($_all_count - $_folder_count))
        local _dir_size="$(ls -lah | grep -m 1 total | sed 's/total //')B"

        # Current dirname
        stats+="$txtbold$txtcyan\W$txtreset: "
        # Folder count
        stats+="$_folder_count dirs"
        # File count
        stats+=", $_file_count files"
        # Directory size
        stats+=", $_dir_size"
    fi

    echo "$stats"
}

function __ps1() {
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

## Line 1
    PS1="\n"
    # time
    PS1+="$txtwhite$txtbold\A "
    # user
    PS1+="$txtgreen\u:"
    # directory
    PS1+="$txtyellow[\w]$txtreset "

    # host
    # PS1+="$txtreset$txtpurple(\h)"

    PS1+="\n"

## Line 2
    PS1+="$(__status)"

    PS1+="$txtreset\n"

## Line 3
    PS1+="$ "
}

PROMPT_COMMAND='__ps1'
