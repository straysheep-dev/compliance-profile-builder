#!/bin/bash

# GPL-3.0 License

# This function will extract all ansible content for your distribution.
# `unzip` will always ask to replace an existing or previously extracted folder or file.

function ExtractContent() {

    # shellcheck source=/dev/null
    source /etc/os-release
    cd "$DOWNLOAD_PATH" || exit
    echo "[>]Extracting content for ${ID}..."
    unzip scap-security-guide-*.zip "*ansible/$ID*" "*ssg-$ID*xml"
    echo "[*]Done."

}

# This function will download the latest GitHub release of ComplianceAsCode/content's zip archive
# if it doesn't already exist locally. It will always check the sha512sum.

function DownloadGitHubReleases() {

    DOWNLOAD_PATH="$(pwd)"
    AUTHOR_REPO_LIST='ComplianceAsCode/content'

    IGNORE_LIST='(tar\.bz2)'

    for AUTHOR_REPO in $AUTHOR_REPO_LIST
    do
        echo "[>]Writing to $DOWNLOAD_PATH..."
        mkdir -p "$DOWNLOAD_PATH" > /dev/null
        ARTIFACTS=$(curl -s https://api.github.com/repos/"$AUTHOR_REPO"/releases/latest | awk -F '"' '/browser_download_url/{print $4}')
        for URL in $ARTIFACTS
        do
            ARCHIVE=$(basename "$URL")
            if [[ ! "$ARCHIVE" =~ $IGNORE_LIST ]] && [[ ! -e "$DOWNLOAD_PATH"/"$ARCHIVE" ]]; then
                echo "[*]Downloading $ARCHIVE..."
                curl --silent -L "$URL" --output "$DOWNLOAD_PATH"/"$ARCHIVE"
            elif [[ ! "$ARCHIVE" =~ $IGNORE_LIST ]] && [[ -e "$DOWNLOAD_PATH"/"$ARCHIVE" ]]; then
                echo "[*]$ARCHIVE exists, skipping..."
            fi
        done
    done

    echo "[>]Checking archive file hash..."
    cd "$DOWNLOAD_PATH" || exit
    if (sha512sum -c scap-security-guide-*.zip.sha512 --ignore-missing >/dev/null); then
        echo "[OK]SHA512SUM: $ARCHIVE"
        ExtractContent
    else
        echo "[ERROR]SHA512SUM: $ARCHIVE"
        echo "Quitting..."
        exit 1
    fi

}

DownloadGitHubReleases