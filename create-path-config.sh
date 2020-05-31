#!/bin/bash

locationblock="
<Location {folder}>
AuthType Basic
AuthName \"private area\"
AuthBasicProvider PAM
AuthPAMService aws
Require valid-user
</Location>"

#input='[{"folder":"/private"},{"folder":"/private2"}]'
output=""
for row in $(echo "${input}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

   folder=$(_jq '.folder')
   replaced=$(echo "$locationblock" | sed -e "s|{folder}|$folder|g")
   output="$output $replaced"
done

echo "$output"
