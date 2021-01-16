#!/usr/bin/env bash

# Assembles the all-in-one template script by combining source.sh & script.sh

# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
fi

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Main control flow
function main() {
    # shellcheck source=source.sh
    source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

    trap "script_trap_err" ERR
    trap "script_trap_exit" EXIT

    script_init "$@"
    build_template
}

# This is quite brittle, but it does work. I appreciate the irony given it's
# assembling a template meant to consist of good Bash scripting practices. I'll
# make it more durable once I have some spare time. Likely some arcane sed...
function build_template() {
    local tmp_file
    local shebang header
    local source_file script_file
    local script_options source_data script_data

    shebang="#!/usr/bin/env bash"
    header="
# A best practices Bash script template with many useful functions. This file
# combines the source.sh & script.sh files into a single script. If you want
# your script to be entirely self-contained then this should be what you want!"

    source_file="$script_dir/source.sh"
    script_file="$script_dir/script.sh"

    script_options="$(head -n 26 "$script_file" | tail -n 17)"
    source_data="$(tail -n +10 "$source_file" | head -n -1)"
    script_data="$(tail -n +27 "$script_file")"

    {
        printf '%s\n' "$shebang"
        printf '%s\n\n' "$header"
        printf '%s\n\n' "$script_options"
        printf '%s\n\n' "$source_data"
        printf '%s\n' "$script_data"
    } > template.sh

    tmp_file="$(mktemp /tmp/template.XXXXXX)"
    sed -e '/# shellcheck source=source\.sh/{N;N;d;}' \
        -e 's/BASH_SOURCE\[1\]/BASH_SOURCE[0]/' \
        template.sh > "$tmp_file"
    mv "$tmp_file" template.sh
    chmod +x template.sh
}

# Template, assemble!
main

# vim: syntax=sh cc=80 tw=79 ts=4 sw=4 sts=4 et sr
