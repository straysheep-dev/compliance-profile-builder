#!/bin/bash

# GPL-3.0 License

# This cripts comments out all "meta" tags in the tags-all.txt file.
# These tags are usually too broad, or can be selected easily using
# the regex below for specific compliance requirements.
# aide and auditd tags are also excluded due to the higher failure
# rate.

meta_tags='^always$
^.*aide_.*$
^audit_.*$
^CCE-.*$
^CJIS-.*$
^.*configure_.*$
^.*_strategy$
^DISA-.*$
^high_.*$
^medium_.*$
^low_.*$
^unknown_.*$
^NIST-.*$
^.*reboot_.*$
^PCI-.*$'

while IFS= read -r tag; do
    echo "[*]Disabling ${tag}..."
    sed -E -i "s/(${tag})/#\1/g" tags-all.txt
done <<< "${meta_tags}"
