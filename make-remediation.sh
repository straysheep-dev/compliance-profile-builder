#!/bin/bash
results_file='/path/to/results.xml'
result_id='<xccdf_org.open-scap_testresult_xccdf_org.ssgproject.content_profile_name>'
fix_type='ansible'
remediation_file='/path/to/write/your/remediation.file'
oscap xccdf generate fix --fix-type "$fix_type" --output "$remediation_file" --result-id "$result_id" "$results_file"
