#!/bin/bash
#
# TODO: add creation of CLI input JSON from parameters
#

. defaults.sh

table=${1:-$DEFAULT_TABLE}
cliInput=${2:-${table}TableCliInput.json}

aws dynamodb create-table \
--table-name ${table} \
--cli-input-json file://${cliInput}
