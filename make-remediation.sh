#!/bin/bash

# GPL-3.0 License

# This script will ingest the results.xml file from an oscap scan
# and build a remediation playbook based on the fix_type variable
# below (default is ansible).

if ! command -v oscap > /dev/null; then
    echo "[*]oscap not installed."
    exit 1
fi

# Replace this variable with the SCAP profile you're using
result_id=$1

if [[ $result_id == '' ]]; then
    echo "[*] Specify a SCAP profile ID."
    echo ""
    echo "    Example: xccdf_org.open-scap_testresult_xccdf_org.ssgproject.content_profile_name"
    echo ""
    exit 1
fi

# Vars
scan_folder="$(pwd)/scans"
results_file="$scan_folder/results.xml"
fix_type='ansible'
remediation_file="$scan_folder/remediation.file"

# Create the output directory if it doesn't exist
mkdir -p "$scan_folder" || exit 1

# Build the playbook
oscap xccdf generate fix --fix-type "$fix_type" --output "$remediation_file" --result-id "$result_id" "$results_file"
