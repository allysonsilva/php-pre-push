#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$script_dir/config.sh"

echo "╭────────────────────────────────╮"
printf "| ### ${color_bold_blue}Executando PHP Lint...${color_reset} ### |\n"
echo "╰────────────────────────────────╯"

php_lint_has_errors=false

for file in $files; do
    php_lint_errors=`php -l -d display_errors=On $file 2>&1 | grep 'PHP Parse error:' || true`

    if [ -n "$php_lint_errors" ]; then
        message_failure "$php_lint_errors"

        php_lint_has_errors=true
    fi
done

if [ "$php_lint_has_errors" = false ]; then
    message_success 'No Errors Found - PHP Lint(Syntax check only)'
    exit 0
fi

exit 1
