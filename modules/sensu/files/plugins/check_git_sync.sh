#!/bin/bash
#
# Check sync status of local git clone with remote master branch.
#
# Pass one or more space separated pairs of local|remote repositories (pipe delimited).
# Ex. ./check_git_sync.sh "/local/path/to/arcus/puppet|git@github.com:arcus-io/puppet.git"

if [ $# -eq 0 ];
  then
    echo "Pass one or more space separated/pipe delimited pairs of repositories:"
    echo 'Ex. "/local/path/to/arcus/puppet|git@github.com:arcus-io/puppet.git"'
    exit 1
  else
    OIFS=$IFS
    IFS='|'
    NOT_SYNCED=()

    # Compare local|remote repositories
    for PAIRS in "$@"; do
      read -a PAIR <<< "${PAIRS}"

      cd ${PAIR[0]}
      GIT_LOCAL=$(git log -n 1 --pretty=format:"%H")
      GIT_REMOTE=$(sudo git ls-remote ${PAIR[1]} | grep refs/heads/master | cut -f 1)

      # Collect repositories that are out of sync
      if ! [ "${GIT_LOCAL}" == "${GIT_REMOTE}" ]; then
        NOT_SYNCED[${#NOT_SYNCED[@]}]=${PAIR[0]}
      fi
    done

    # Count of repositories that are out of sync
    OUT_OF_SYNC=${#NOT_SYNCED[@]}

    # Return warning for the repositories that are out of sync
    if [ ${OUT_OF_SYNC} -gt 0 ]; then
      OUTPUT=""

      for (( i=0; i<${OUT_OF_SYNC}; i++ )); do
        OUTPUT="$OUTPUT ${NOT_SYNCED[$i]}"
      done

      echo "Repositories out of sync: $OUTPUT"
      exit 2
    fi

    IFS=$OIFS

    # All repositories are in sync
    echo "All repositories are up to date"
    exit 0
fi
