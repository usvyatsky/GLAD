#!/bin/bash
#
# TODO: add creation of CLI input JSON from parameters
#

. defaults.sh

table=${1:-$DEFAULT_TABLE}
policyName=${2:-$DEFAULT_POLICY}
description=${3:-$DEFAULT_POLICY_DESCRIPTION}

if ! [ -f ${table}TableDescription.json ] ; then
	aws dynamodb describe-table --table-name ${table} > ${table}TableDescription.json
fi

tableArn=`jq '.Table.TableArn' ${table}TableDescription.json | tr -d \"`

jqProg="(.Statement[]|select(.Sid==\"${policyName}\")|.Resource)|=\"${tableArn}\""
jq ${jqProg} ${policyName}PolicyTemplate.json > ${policyName}Policy.json

aws iam create-policy \
--policy-name ${policyName} \
--policy-document file://${policyName}Policy.json \
--description "${description}"
