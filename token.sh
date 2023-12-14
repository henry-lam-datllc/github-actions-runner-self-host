#!/bin/sh
registration_url="https://api.github.com/repos/$OWNER/$REPO/actions/runners/registration-token"
echo "Requesting registration URL at '$registration_url'"

response=$(curl -sX POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_TOKEN" $registration_url)

export RUNNER_TOKEN=$(echo $response | jq .token --raw-output)

echo "Runner registration token: $RUNNER_TOKEN"

# cd /home/runner/actions-runner
./config.sh --url https://github.com/$OWNER/$REPO --token $RUNNER_TOKEN --name $(hostname)

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!
