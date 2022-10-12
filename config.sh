#!/bin/bash

set -o allexport
[ -f .env.pre-push ] && source .env.pre-push
set +o allexport

# Echo Colors
color_red='\e[0;31m'
color_green='\e[0;32m'
color_yellow='\e[0;33m'
color_blue='\e[0;34m'

color_bold_black='\e[1;30m'
color_bold_white='\e[1;37m'
color_bold_red='\e[1;31m'
color_bold_green='\e[1;32m'
color_bold_yellow='\e[1;33m'
color_bold_blue='\e[1;34m'

color_background_red='\e[41m'
color_background_green='\e[42m'
color_background_yellow='\e[43m'
color_background_blue='\e[44m'

color_reset='\e[0m' # No Color

function message_failure() {
    echo
    printf "${color_bold_white}${color_background_red} 🤦 $1 ${color_reset}\n"
}

function message_success() {
    echo
    printf "${color_bold_black}${color_background_green} 🚀 🎉 $1 ${color_reset}\n"
}

function message_warning() {
    echo
    printf "${color_bold_black}${color_background_yellow} ⚠️  $1 ${color_reset}\n"
}

function message_info() {
    echo
    printf "${color_bold_black}${color_background_blue} ☝️️ $1 ${color_reset}\n"
}

# Default values of arguments
diff_filter=${diff_filter:-ACM}
parent_branch=${parent_branch:-main}
other_arguments=()

# current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
# current_branch=`git name-rev --name-only HEAD`
# current_branch=`git branch --show-current`

# --diff-filter {diff-value} --branch {branch-name}
while [ $# -gt 0 ]; do
    case "$1" in
        # Use `-f {value}` or `--diff-filter {value}`
        -f|--diff-filter) diff_filter="${2}" ; shift ;;
        --branch) parent_branch="${2}" ; shift ;;
        *) other_arguments+=("${2}") ; shift ;;
    esac
    shift
done

# Fetch all changed php files and validate them
files=$(git diff --name-only --diff-filter=${diff_filter} "$parent_branch"..HEAD --oneline | grep '\.php$' | grep -Ev '\.(blade.php|txt)$')

# Replace first blank only
files_separated_by_comma=${files/ /''}

# Remove blank spaces with comma
# Separated by commas
files_separated_by_comma=$(echo $files_separated_by_comma | sed 's/ /,/g')

if [ -z "$files" ]; then
    message_info "Nenhum arquivo .php pôde ser encontrado!"
    exit 0
fi
