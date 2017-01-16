#!/bin/bash
function __status() {
    local branch="$(__git_ps1 '(%s)')"
    if [[ ! -z $branch ]]; then
        # Git
        local all="$(git status --porcelain | wc -l )"
        local _repo_name="$(git remote show origin -n | grep 'Fetch URL:' | sed -E 's#^.*/(.*)$#\1#' | sed 's#.git$##')"

        echo "$txtbold$txtred$_repo_name $txtcyan$branch $txtwhite$all changes$txtreset\n"

        rm --force ./.git/index.lock

    else
        # File
        local _all_count="$(ls -1 | wc -l)"
        local _folder_count="$(ls -1 -p | grep "/" | wc -l)"
        local _file_count=$(($_all_count - $_folder_count))
        local _dir_size="$(ls -lah | grep -m 1 total | sed 's/total //')B"

        echo "$txtcyan\W: $txtreset$_folder_count dirs | $_file_count files | $_dir_size\n"
    fi

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

    # Unicode "✗"
    local x='\342\234\227'

    local status=""
    # If branch is set: display branch status, else directory info
    

## Line 1 ##
    PS1="\n"
    # time
    PS1+="$txtwhite$txtbold[-\A-] "
    # user
    PS1+="$txtgreen\u:"
    # directory
    PS1+="$txtyellow[\w] "
    # host
    PS1+="$txtreset$txtpurple(\h)"

## Line 2 ##
    PS1+="\n"
    PS1+="$(__status)"

## Line 3 ##
    # if error, a red "✗" and the error number
    if [[ $last_cmd != 0 ]]; then
        PS1+=" $txtred$txtbold$x ($last_cmd)$txtreset"
    fi

    # trail
    PS1+=" $txtbold$ $txtreset\]"
}

PROMPT_COMMAND='set_prompt'
