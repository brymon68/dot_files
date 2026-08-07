#!/bin/bash
# AWS credential_process: 1Password -> STS session token -> cached temp creds.
#
# Fetches the long-lived IAM key from 1Password, exchanges it once for a 36h
# STS session token, caches that, and hands the temp creds to the AWS SDK/CLI.
# The long-lived key never touches the environment or disk.
#
# Wired up via ~/.aws/config. Refresh happens automatically on expiry; to force
# one, delete the cache file.

set -euo pipefail
umask 077

export PATH="/opt/homebrew/bin:/usr/bin:/bin"

OP_ITEM="v6zzdqu7bbtg7n3sqyc3s4lzwu"
OP_VAULT="Private"
CACHE="$HOME/.aws/cache/tal-session.json"
DURATION=129600 # 36h, the max for an IAM user
SKEW=900        # refresh 15m before expiry

# Serve the cache if it has meaningful life left.
if [[ -r "$CACHE" ]] && python3 -c '
import sys, json, datetime
try:
    exp = json.load(open(sys.argv[1]))["Expiration"]
    exp = datetime.datetime.fromisoformat(exp.replace("Z", "+00:00"))
    left = (exp - datetime.datetime.now(datetime.timezone.utc)).total_seconds()
    sys.exit(0 if left > int(sys.argv[2]) else 1)
except Exception:
    sys.exit(1)
' "$CACHE" "$SKEW"; then
  cat "$CACHE"
  exit 0
fi

access_key="$(op item get "$OP_ITEM" --vault "$OP_VAULT" --fields AccessKeyId --reveal)"
secret_key="$(op item get "$OP_ITEM" --vault "$OP_VAULT" --fields SecretAccessKey --reveal)"

# Unset AWS_PROFILE/AWS_SESSION_TOKEN so this call cannot recurse back into
# this script or inherit a stale session.
session="$(
  env -u AWS_PROFILE -u AWS_SESSION_TOKEN \
    AWS_ACCESS_KEY_ID="$access_key" \
    AWS_SECRET_ACCESS_KEY="$secret_key" \
    AWS_REGION=us-west-2 \
    aws sts get-session-token --duration-seconds "$DURATION" --output json
)"

printf '%s' "$session" | python3 -c '
import sys, json
c = json.load(sys.stdin)["Credentials"]
out = {
    "Version": 1,
    "AccessKeyId": c["AccessKeyId"],
    "SecretAccessKey": c["SecretAccessKey"],
    "SessionToken": c["SessionToken"],
    "Expiration": c["Expiration"],
}
blob = json.dumps(out)
open(sys.argv[1], "w").write(blob)
print(blob)
' "$CACHE"
