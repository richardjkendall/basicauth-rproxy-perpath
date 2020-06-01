#!/bin/bash

locationblock="
<Location {folder}>
AuthType Basic
AuthName \"private area\"
AuthBasicProvider PAM
AuthPAMService aws
Require valid-user
</Location>"

locationblockno="
<Location {folder}>
Require all granted
</Location>"

#input='[{"folder":"/", "auth": "yes"},{"folder":"/events", "auth": "no"}]'
output=""
for row in $(echo "${input}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

   folder=$(_jq '.folder')
   authon=$(_jq '.auth')
   if [ "$authon" == "yes" ]; then
    replaced=$(echo "$locationblock" | sed -e "s|{folder}|$folder|g")
   else
    replaced=$(echo "$locationblockno" | sed -e "s|{folder}|$folder|g")
   fi
   output="$output $replaced"
done

echo "$output"
