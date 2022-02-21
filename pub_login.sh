# This script creates/updates credentials.json file which is used
# to authorize publisher when publishing packages to pub.dev

# Checking whether the secrets are available as environment
# variables or not.
if [ -z "${PUB_DEV_PUBLISH_ACCESS_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_ACCESS_TOKEN environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_REFRESH_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_REFRESH_TOKEN environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}" ]; then
  echo "Missing PUB_DEV_PUBLISH_TOKEN_ENDPOINT environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_EXPIRATION}" ]; then
  echo "Missing PUB_DEV_PUBLISH_EXPIRATION environment variable"
  exit 1
fi

mkdir /home/runner/.pub-cache/

# Create credentials.json file.
cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken":"${PUB_DEV_PUBLISH_ACCESS_TOKEN}",
  "refreshToken":"${PUB_DEV_PUBLISH_REFRESH_TOKEN}",
  "tokenEndpoint":"${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}",
  "scopes": ["openid", "https://www.googleapis.com/auth/userinfo.email"],
  "expiration":${PUB_DEV_PUBLISH_EXPIRATION}
}
EOF