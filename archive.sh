#! /usr/bin/env bash

# Check args
if [[ $# -ne 4 ]]; then
    echo "Usage: bash archive.sh <GitHub_Token> <Source_User> <Destination_User> <Destination_Repo>"
    exit 1
fi

GITHUB_TOKEN=$1
SOURCE_USER=$2
ARCHIVE_USER=$3
ARCHIVE_REPO=$4

# Verify programs installed
if ! command -v curl &> /dev/null; then
    echo "curl not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq not installed"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "git not installed"
    exit 1
fi

TEMP_DIR=$(mktemp -d)

ARCHIVE_DIR="${TEMP_DIR}/${ARCHIVE_REPO}"

mkdir "${ARCHIVE_DIR}"

git clone --depth=1 \
    "ssh://git@github.com:22/${ARCHIVE_USER}/${ARCHIVE_REPO}.git" \
    "${ARCHIVE_DIR}"

# Clear out repo for adding files
rm -rf ${ARCHIVE_DIR}/*

if [[ -f "${ARCHIVE_DIR}/.gitmodules" ]]; then
    rm -f "${ARCHIVE_DIR}/.gitmodules"
fi

# Go through a graphql API to get the list of repos
REQUEST_BODY=" \
  { \
      \"query\": \"query { organization(login: \\\"${SOURCE_USER}\\\") { repositories(first: 50) { nodes { name } } } }\" \
  } \
"
REQUEST_HEAD_AUTH="Authorization: bearer ${GITHUB_TOKEN}"
REQUEST_TYPE="POST"
REQUEST_ADDR="https://api.github.com/graphql"

RESPONSE=$(curl -H "${REQUEST_HEAD_AUTH}" \
                -X "${REQUEST_TYPE}" \
                -d "${REQUEST_BODY}" \
                "${REQUEST_ADDR}")

JQ_FILTER_1=".data.organization.repositories.nodes"
JQ_FILTER_2=".[].name"

REPOS=$(echo "${RESPONSE}" | jq -c "${JQ_FILTER_1}" | jq -c "${JQ_FILTER_2}")

# Process each repository
for EACH in $REPOS; do
    SOURCE_REPO=$(echo "${EACH}" | tr -d '"')
    REPO_ARCHIVE="${ARCHIVE_DIR}/${SOURCE_REPO}"

    mkdir "${REPO_ARCHIVE}"

    git clone --depth=1 \
        "ssh://git@github.com:22/${SOURCE_USER}/${SOURCE_REPO}.git"\
        "${REPO_ARCHIVE}"

    rm -rf "${REPO_ARCHIVE}/.git"
done

# Commit archive of repositories
pushd "${ARCHIVE_DIR}"
git add .
git commit -m "$(date -I) manual archive"
git push
popd

# Clean up temp directory
rm -rf ${TEMP_DIR}
