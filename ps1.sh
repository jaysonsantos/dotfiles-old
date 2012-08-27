c_cyan=`tput setaf 6`
c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_sgr0=`tput sgr0`

function branch_is_clean()
{
    is_clean=0
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        if git diff --quite 2>/dev/null >&2
            is_clean=0
        then
            is_clean=1
        fi
    fi

    return $is_clean
}

function branch_color ()
{
    color=""
    if branch_is_clean
    then
        color=${c_green}
    else
        color=${c_red}
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
    echo -ne " ("$gitver

    if ! branch_is_clean
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
