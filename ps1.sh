c_cyan=`tput setaf 6`
c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_blue=`tput setaf 4`
c_yellow=`tput setaf 3`
c_sgr0=`tput sgr0`

function branch_color ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        color=""
        if git diff --quiet 2>/dev/null >&2
        then
            color="${c_green}"
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
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    else
        return 0
    fi
    echo -e " ("$gitver")"
}

function python_version() {
    echo -n $c_blue $(python --version &> /dev/stdout)
}

function django_version() {
    if [ -z "$(which django-admin.py)" ]
    then
        return
    fi
    echo -n "$c_yellow Django" $(django-admin.py --version)
}

function linebreak() {
    echo -e '\033[00m\n$ ';
}

export PS1="\u@\h $c_cyan\w"
export PS1="$PS1\`branch_color\`\`git_branch\`"

if [ -z "$PS1_EXCLUDE_PYTHON" ]
then
    PS1_EXCLUDE_PYTHON=0
fi

# The idea of this is: before source this export PS1_EXCLUDE_PYTHON=1
if [ "$PS1_EXCLUDE_PYTHON" -ne 1 ]
then
    export PS1="$PS1\`python_version\`\`django_version\`"
fi

export PS1="$PS1\`linebreak\`"
