# OpenSCAP Utilities

Scripts and files to easily create, test, and apply customized OpenSCAP policies using Ansible tags.

- [https://github.com/ComplianceAsCode/content](https://github.com/ComplianceAsCode/content)
- [https://complianceascode.readthedocs.io/en/latest/](https://complianceascode.readthedocs.io/en/latest/)

> [!IMPORTANT]
> This should be used as **one** method to get your systems into a desired state. Some policy rules do not have Ansible tasks for them, and will need manually applied via a shell script. Additionally, not all tags are sorted and grouped out of each policy. This is why the `tags-all.txt` file is created, so you can add anything that's missing. Identify these items with the `oscap` scanner.*

1. Run `./download-content.sh` to pull the latest OpenSCAP policy release from GitHub.
2. It will automatically `unzip` policy files matching the current OS. To specify another OS, use `./parse-tags.sh -u <os-name>`, or just `-u` to unzip all.
3. You can list all available policy files with `./parse-tags.sh -l`.
4. Use `parse-tags.sh '<regex>'` to build tag lists matching the `<regex>`, e.g. `pci` or `'ubuntu2404.*workstation'`.

The `parse-tags.sh` wrapper script is written to interpret posix-extended regex. Combine rules from multiple policies like this.

```bash
# Combine all tags from cis_level2_server and stig
./parse-tags.sh 'ubuntu.*(cis.*2.*server|stig)'
```

5. Go through any of the tag files, and comment out any tags you don't want to apply. Usually `tags-all.txt` is the file to edit here, but tag lists are created for numerous categories.

```md
<SNIP>
accounts_password_pam_minclass
accounts_password_pam_minlen
accounts_password_pam_ocredit
#accounts_password_pam_pwquality_password_auth
#accounts_password_pam_pwquality_system_auth
#accounts_password_pam_retry
accounts_password_pam_ucredit
accounts_password_pam_unix_remember
<SNIP>
```

6. Create CSV's of your tag lists, so you can feed those into your Ansible CLI `--tags` argument.

```bash
./create-csv.sh
```

7. Use the `-C` and `-D` options in `ansible-playbook` to confirm and debug what you're applying.

- You can test a set of tags on multiple playbooks
- You can absorb, for example, kernel hardening tags from every playbook for all systems, and have those ready-to-use as needed
- You can use "meta" tags, such as `low_disruption`, `no_reboot_needed`, or `NIST-800-*`

> [!TIP]
> If you're finding tasks executing that you don't think should, check the assigned tags to that task in the relevant playbook.

```bash
# Check -C on localhost
ansible-playbook -i "localhost," -c local -b --ask-become-pass -t "$(cat tags-all.csv)" -C ./scap-security-guide-0.1.79/ansible/ubuntu2404-playbook-cis_level2_workstation.yml
```

8. Execute Ansible against one or more of the playbooks used to build the tag list.

```bash
# Run on localhost
ansible-playbook -i "localhost," -c local -b --ask-become-pass -t "$(cat tags-all.csv)" ./scap-security-guide-0.1.79/ansible/ubuntu2404-playbook-cis_level2_workstation.yml
```

> [!TIP]
> There are also folders in the same directory of premade tag sets that will apply as many rules as possible without breaking a system, exceptions being `aide` and `auditd` rules. The reason being these rules often endlessly loop, need tuned to your environment, or break the deployment. Use the [`aide`](https://github.com/straysheep-dev/ansible-configs/tree/main/aide) and [`install_auditd`](https://github.com/straysheep-dev/ansible-configs/tree/main/install_auditd) roles instead.
