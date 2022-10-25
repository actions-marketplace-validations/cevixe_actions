#!/bin/bash

set -u

function parseInputs(){
	# Required inputs
	if [ "${INPUT_COMMAND}" == "" ]; then
		echo "Input command cannot be empty"
		exit 1
	fi
}

function configureApp(){
	appVersion="github.com/cevixe/app@v0.3.0"
	go get $appVersion && \
	cp -R $GOPATH/pkg/mod/$appVersion /app && \
	export CEVIXE_APP_DIR="/app"
}

function runCevixeCli(){
	cd /cli

	configureApp

	echo "Run cvx ${INPUT_COMMAND}"
	set -o pipefail
	cdk ${INPUT_COMMAND} 2>&1 | tee output.log
	exitCode=${?}
	set +o pipefail
	echo ::set-output name=status::${exitCode}
	output=$(cat output.log)

	commentStatus="Failed"
	if [ "${exitCode}" == "0" ]; then
		commentStatus="Success"
	elif [ "${exitCode}" != "0" ]; then
		echo "cvx ${INPUT_COMMAND} has failed. See above console output for more details."
		exit 1
	fi

	if [ "$GITHUB_EVENT_NAME" == "pull_request" ]; then
		commentWrapper="#### \`cvx ${INPUT_COMMAND}\` ${commentStatus}
<details><summary>Show Output</summary>
\`\`\`
${output}
\`\`\`
</details>
*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`*"

		payload=$(echo "${commentWrapper}" | jq -R --slurp '{body: .}')
		commentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)

		echo "${payload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${commentsURL}" > /dev/null
	fi
}

function main(){
	parseInputs
	export CEVIXE_WORKSPACE=${GITHUB_WORKSPACE}
	runCevixeCli
}

main