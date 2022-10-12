#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$script_dir/config.sh"

if [ "${run_phpcs:-true}" = true ]; then
    echo "╭────────────────────────────────────╮"
    printf "| ### ${color_bold_blue}Executando PHP CodeSniffer${color_reset} ### |\n"
    echo "╰────────────────────────────────────╯"

    phpcs_has_errors=false

    for file in $files; do
        phpcs_errors=`eval php ./vendor/bin/phpcs "$file" || true`

        if [[ $phpcs_errors =~ ERROR || $phpcs_errors =~ WARNING ]]
        then
            # Display error and PHPCS filtered output.
            # Display processing file error.
            message_failure "Erro PHPCS no arquivo $file"

            echo "$phpcs_errors"
            phpcs_has_errors=true
        fi
    done

    if [ "$phpcs_has_errors" = false ]; then
        message_success '✔ No Errors Found - PHP CodeSniffer'
        exit 0
    fi

    exit 1
fi

message_info 'PHPCS execution is disabled!'
exit 0
