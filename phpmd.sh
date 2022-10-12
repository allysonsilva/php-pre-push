#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$script_dir/config.sh"

if [ "${run_phpmd:-true}" = true ]; then
    echo "╭──────────────────────────╮"
    printf "| ### ${color_bold_blue}Executando PHPMD${color_reset} ### |\n"
    echo "╰──────────────────────────╯"

    phpmd_command="./vendor/bin/phpmd $files_separated_by_comma ansi ${phpmd_xml:-phpmd.xml.dist} --suffixes php"

    if [ "${phpmd_generate_baseline:-false}" = true ]; then
        # @see https://phpmd.org/documentation/index.html
        php $phpmd_command --generate-baseline &>/dev/null
    fi

    phpmd_errors=`eval php $phpmd_command || true`

    if ! [[ "$phpmd_errors" =~ "No mess detected" ]]
    then
        message_failure "PHPMD - PHP Mess Detector found some errors. Fix the errors before PUSH."
        echo "$phpmd_errors"
        exit 1
    fi

    message_success "✔ No PHPMD errors found!"
    exit 0
fi

message_info 'PHPMD execution is disabled!'
exit 0
