#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$script_dir/config.sh"

if [ "${run_phpunit:-true}" = true ]; then
    echo "╭───────────────────────────────╮"
    printf "| ### ${color_bold_blue}Executando PHPUnit...${color_reset} ### |\n"
    echo "╰───────────────────────────────╯"

    phpunit_has_errors=false
    phpunit_files=""

    for file in $files; do
        filename=$(basename -- "$file")
        # extension="${filename##*.}"
        # Nome do arquivo sem extensão
        filename="${filename%.*}"

        # Nome do arquivo termina em "Test"?
        if [[ ${filename: -4} = "Test" ]]; then
            phpunit_files="$phpunit_files --filter $filename"
        fi
    done

    if [ -n "$phpunit_files" ]; then
        phpunit_errors=`eval php ./vendor/bin/phpunit ${phpunit_files} || true`

        if ! [[ "$phpunit_errors" =~ "OK" ]]; then
            message_failure "PHPUnit"

            echo
            echo "$phpunit_errors"
            exit 1
        fi

        message_success "✔ No PHPUnit errors found!"
        exit 0
    fi

    message_info 'PHPUnit No test files have been changed or added!'
    exit 0
fi

message_info 'PHPUnit execution is disabled!'
exit 0
