#!/bin/sh

OUT_FILE='./out.tsv'

echo 'eventTime|awsRegion|eventSource|eventName|userName|sourceIPAddress|userAgent|requestParameters|userIdentity' \
  | sed 's/|/\t/g' > ${OUT_FILE}

find . -name "*.json.gz" | xargs gunzip -c \
  | jq '.Records[] | select(contains({eventName:"Describe"})|not) | select(contains({eventName:"List"})|not) | select(contains({eventName:"Get"})|not)' \
  | jq -r '"\(.eventTime)|\(.awsRegion)|\(.eventSource)|\(.eventName)|\(.userName)|\(.sourceIPAddress)|\(.userAgent)|\(.requestParameters)|\(.userIdentity)"' \
  | sed 's/|/\t/g' | sort -k 1,1 >> ${OUT_FILE}

head -n 10 ${OUT_FILE}
