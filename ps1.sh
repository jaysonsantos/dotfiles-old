function git_branch() {
   echo -ne '\033[0;33m'
   echo -n "" $(git branch &> /dev/stdout|grep ^\*|sed 's/\* \(.*\)/ \(\1\) /')
}

function python_version() {
   echo -ne '\033[0;31m'
   echo -n "" $(python --version &> /dev/stdout)
}

function django_version() {
   echo -ne '\033[0;32m'
   echo -n ' Django' $(django-admin.py --version)
}

function linebreak() {
   echo -e '\033[00m\n$ ';
}

export PS1="\[\e]0;\u@\h: \w\a\\u@\h:\w"
export PS1="$PS1\`git_branch\`\`python_version\`\`django_version\`\`linebreak\`"
