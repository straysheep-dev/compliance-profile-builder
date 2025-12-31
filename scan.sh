#!/bin/bash
results_path='/path/to/results.xml'
report_path='/path/to/report.html'
profile_id='<xccdf_org.ssgproject.content_profile_some_profile>'
ssg_data_file='/path/to/<ssg_data_file>.xml'
oscap xccdf eval --profile "$profile_id" --results-arf "$results_path" --report "$report_path" "$ssg_data_file"
