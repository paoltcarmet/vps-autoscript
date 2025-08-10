#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Checking Netflix region access..."

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://www.netflix.com/title/80018499)

if [[ "$HTTP_CODE" == "200" ]]; then
  log INFO "Netflix is available in this region."
else
  log INFO "Netflix is NOT available in this region."
fi