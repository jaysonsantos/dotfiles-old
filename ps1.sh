c_cyan=`tput setaf 6`
c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_sgr0=`tput sgr0`


function is_git_working_copy()
{
    wc=0
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        wc=0
    else
        wc=1
    fi

    return $wc
}

function branch_is_dirty()
{
    is_dirty=0
    if is_git_working_copy
    then
        is_dirty=$(git status | grep clean | wc -l)
    fi

    return $is_dirty
}

function branch_color ()
{
    color=""
    if is_git_working_copy
    then
        if ! branch_is_dirty
        then
            color=${c_green}
        else
            color=${c_red}
        fi
    else
        return 0
    fi
    echo -ne $color
}

function git_branch ()
{
    if is_git_working_copy
    then
        gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    else
        return 0
    fi
    echo -ne " ("$gitver

    if branch_is_dirty
    then
         echo -n "*"
    fi

    echo -n ")"
}

function python_version() {
    echo -ne '\033[0;31m'
    echo -n "" $(python --version &> /dev/stdout)
}

function django_version() {
    if [ -z "$(which django-admin.py)" ]
    then
        return
    fi
    echo -ne '\033[0;32m'
    echo -n ' Django' $(django-admin.py --version)
}

function linebreak() {
    echo -e '\n\033[00m$ ';
}

b_is_pythonist=1

export PS1="\u@\h $c_cyan\w"
export PS1="$PS1\`branch_color\`\`git_branch\`"

if [ $b_is_pythonist -ne 0 ]
then
    export PS1="$PS1\`python_version\`\`django_version\`"
fi


export PS1="$PS1\`linebreak\`"
