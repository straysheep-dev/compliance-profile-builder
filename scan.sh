#!/bin/bash

# GPL-3.0 License

# This script will scan the local machine with oscap using the profile specified.

# shellcheck source=/dev/null
source /etc/os-release

if ! command -v oscap > /dev/null; then
    echo "[*]oscap not installed."
    echo "    dnf install openscap-scanner"
    echo "    apt install libopenscap8"
    exit 1
fi

if ! [[ "$ID" == 'debian' ]] && ! [[ "$ID" == 'ubuntu' ]]; then
    if ! command -v oscap-ssh > /dev/null; then
        echo "[*]openscal-utils not installed."
        exit 1
    fi
fi

# Replace these variables with the SCAP profile and data file you're using
scan_target="$1"
profile_id="$2"
ssg_data_file="$3"

if [[ $scan_target == '' ]]; then
    echo "[*] Specify either 'localhost' or 'user@remote port'. Note the space between remote and port."
    echo ""
    exit 1
fi

if [[ $profile_id == '' ]]; then
    echo "[*] Specify a SCAP profile ID."
    echo ""
    echo "    Example: xccdf_org.ssgproject.content_profile_some_profile"
    echo ""
    exit 1
fi

if [[ $ssg_data_file == '' ]]; then
    echo "[*] Specify a SCAP data file."
    echo ""
    echo "    Example: /path/to/<ssg_data_file>.xml"
    echo ""
    exit 1
fi

# Vars
scan_folder="$(pwd)/scans"
results_path="$scan_folder/results.xml"
report_path="$scan_folder/report.html"

if ! [[ -d "$scan_folder" ]]; then
    mkdir -p "$scan_folder" || exit 1
fi

# Run a scan
if [[ "$scan_target" == "localhost" ]]; then
    sudo oscap xccdf eval --profile "$profile_id" --results-arf "$results_path" --report "$report_path" "$ssg_data_file"
else
    oscap-ssh --sudo "$1" xccdf eval --profile "$profile_id" --results-arf "$results_path" --report "$report_path" "$ssg_data_file"
fi