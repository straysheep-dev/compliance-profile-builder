#!/bin/bash

# GPL-3.0 License

# This script will scan the local machine with oscap using the profile specified.

if ! command -v oscap > /dev/null; then
    echo "[*]oscap not installed."
    exit 1
fi

# Replace these variables with the SCAP profile and data file you're using
profile_id="$1"
ssg_data_file="$2"

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

# Run a scan
oscap xccdf eval --profile "$profile_id" --results-arf "$results_path" --report "$report_path" "$ssg_data_file"
