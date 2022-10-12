#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$script_dir/config.sh"

if [ "${run_phpstan:-true}" = true ]; then
    echo "╭───────────────────────────────╮"
    printf "| ### ${color_bold_blue}Executando PHPStan...${color_reset} ### |\n"
    echo "╰───────────────────────────────╯"
    echo

    phpstan_arguments="--error-format=table --ansi"

    if [ "${phpstan_generate_baseline:-false}" = true ]; then
        phpstan_arguments="${phpstan_arguments} --generate-baseline phpstan-baseline.neon"
    fi

    phpstan_errors=`eval php ./vendor/bin/phpstan analyse "$phpstan_arguments" "$files" || true`

    if [[ $phpstan_errors =~ ERROR ]]
    then
        message_failure "PHPStan - PHPStan found some errors."
        echo "$phpstan_errors"
        exit 1
    fi

    message_success "✔ No PHPStan errors found!"
    exit 0
fi

message_info 'PHPStan execution is disabled!'
exit 0
