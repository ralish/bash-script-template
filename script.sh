#!/usr/bin/env bash

# A best practices Bash script template with many useful functions. This file
# sources in the bulk of the functions from the source.sh file which it expects
# to be in the same directory. Only those functions which are likely to need
# modification are present in this file. This is a great combination if you're
# writing several scripts! By pulling in the common functions you'll minimise
# code duplication, as well as ease any potential updates to shared functions.

# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
fi

# Only enable these shell behaviours if we're not being sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if ! (return 0 2> /dev/null); then
    # A better class of script...
    set -o errexit      # Exit on most errors (see the manual)
    set -o nounset      # Disallow expansion of unset variables
    set -o pipefail     # Use last non-zero exit code in a pipeline
fi

# Enable errtrace or the error trap handler will not work as expected
set -o errtrace         # Ensure the error trap handler is inherited

# DESC: Usage help
# ARGS: None
# OUTS: None
function script_usage() {
    cat << EOF
usage: $(basename "$0") [options] openaudible_library_dir organised_library_dir
     -h|--help                  Displays this help
     -c|--copy                  Copy files insted of hardlinking
     -v|--verbose               Displays verbose output
    -nc|--no-colour             Disables colour output
    -cr|--cron                  Run silently unless we encounter an error
EOF
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parse_params() {
    local param
    if [[ $# -eq 0 ]]; then
        script_usage
        exit 0
    fi
    while [[ $# -gt 0 ]]; do
        param="$1"
        shift
        case $param in
            -h | --help)
                script_usage
                exit 0
                ;;
            -c | --copy)
                copy=true
                ;;
            -v | --verbose)
                # shellcheck disable=SC2034
                verbose=true
                ;;
            -nc | --no-colour)
                # shellcheck disable=SC2034
                no_colour=true
                ;;
            -cr | --cron)
                # shellcheck disable=SC2034
                cron=true
                ;;
            *)
                if [[ -z "${openaudible_library_dir-}" ]]; then
                    openaudible_library_dir=$(realpath "$param")
                elif [[ -z "${organised_library_dir-}" ]]; then
                    organised_library_dir=$(realpath "$param")
                else
                    script_exit "Invalid parameter was provided: $param" 1
                fi
                ;;
        esac
    done
    if [[ -z "${openaudible_library_dir-}" ]]; then
        script_exit "Required parameter openaudible_library_dir was not provided" 1
    elif [[ ! -d "$openaudible_library_dir" ]]; then
        script_exit "Provided openaudible_library_dir is not a directory: $openaudible_library_dir" 1
    fi
    if [[ -z "${organised_library_dir-}" ]]; then
        script_exit "Required parameter organised_library_dir was not provided" 1
    elif [[ ! -d "$organised_library_dir" ]]; then
        script_exit "Provided organised_library_dir is not a directory: $organised_library_dir" 1
    fi
}

# DESC: Check if all required dependencies are installed
# ARGS: None
# OUTS: None
function check_dependencies() {
    check_binary jq true
    check_binary inotifywait true
}

# DESC: Create organised link
# ARGS: $1 (required): Source file
#       $2 (required): Target root
# OUTS: None
function handle_file() {
    if [[ $# -lt 2 ]]; then
        script_exit 'Missing required argument to handle_file()!' 2
    fi

    local filename_with_extension
    filename_with_extension=$(basename "$1")
    local filename="${filename_with_extension%.*}"

    local book_json
    book_json=$(jq -r --arg filename "$filename" \
      '.[] | select(.filename == $filename)' \
      < "$openaudible_library_dir/books.json")
    if [[ -z "$book_json" ]]; then
        # shellcheck disable=SC2154
        pretty_print "No entry in $openaudible_library_dir/books.json for $filename" \
          "$fg_red"
        return
    fi

    local author
    author=$(jq --raw-output '.author' <<< "$book_json")

    local link_target="${2}/${author}/"

    local series_name
    series_name=$(jq -r '.series_name | select(. != null)' <<< "$book_json")
    if [[ -n "$series_name" ]]; then
        link_target="${link_target}${series_name}/"
        local series_sequence
        series_sequence=$(jq --raw-output '.series_sequence | select(. != null)' \
          <<< "$book_json")
        if [[ -n "$series_sequence" ]]; then
            link_target="${link_target}Book ${series_sequence} - "
        fi
    fi

    local release_year
    release_year=$(jq -r '.release_date' <<< "$book_json" | \
      sed -r 's/^([[:digit:]]{4})-([[:digit:]]{2})-([[:digit:]]{2})$/\1/')
    local narrated_by
    narrated_by=$(jq -r '.narrated_by' <<< "$book_json")
    link_target="${link_target}${release_year} - ${filename} {${narrated_by}}/${filename_with_extension}"

    link "$1" "$link_target"
}

# DESC: Hardlink source to target
# ARGS: $1 (required): Source file
#       $2 (required): Target file
# OUTS: None
function link() {
    if [[ $# -lt 2 ]]; then
        script_exit 'Missing required argument to link()!' 2
    fi

    if [[ -f "$2" ]]; then
        # shellcheck disable=SC2154
        pretty_print "Link $1 => $2 already exists" "$fg_yellow"
        return
    fi

    mkdir --parents "$(dirname "$2")"

    # shellcheck disable=SC2154
    pretty_print "Linking $1 => $2" "$fg_green"
    if [[ -z ${copy-} ]]; then
        ln "$1" "$2"
    else
        cp --archive "$1" "$2"
    fi
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    trap script_trap_err ERR
    trap script_trap_exit EXIT

    script_init "$@"
    parse_params "$@"
    cron_init
    colour_init
    check_dependencies

    if [[ ! -f "$openaudible_library_dir/books.json" ]]; then
        script_exit "Could not find books.json in $openaudible_library_dir!" 1
    fi

    if [[ -n ${copy-} ]]; then
        verbose_print "Copying instead of linking" "$fg_yellow"
    fi

    # shellcheck disable=SC2154
    pretty_print "Linking files from $openaudible_library_dir/books to $organised_library_dir" \
      "$fg_white"

    for file in "$openaudible_library_dir"/books/*; do
        verbose_print "Handling $file" "$fg_white"
        handle_file "$file" "$organised_library_dir"
    done

    pretty_print "Listening for changes in $openaudible_library_dir/books" \
      "$fg_white"

    inotifywait --monitor --quiet \
      --event create --event moved_to \
      --format %w%f "${openaudible_library_dir}/books" |
    while read -r file; do
        verbose_print "Handling $file" "$fg_white"
        handle_file "$file" "$organised_library_dir"
    done
}

# shellcheck source=source.sh
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

# Invoke main with args if not sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if ! (return 0 2> /dev/null); then
    main "$@"
fi

# vim: syntax=sh cc=80 tw=79 ts=4 sw=4 sts=4 et sr
