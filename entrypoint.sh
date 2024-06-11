#!/bin/bash

if [[ -z "${IMAPSYNC_MODE}" ]]; then
  echo "IMAPSYNC_MODE is not set"
  exit 1
fi

declare -a imapsync_args=()

if [[ "${IMAPSYNC_MODE}" == "from_gmail" ]]; then
  if [[ -z "${IMAPSYNC_HOST2}" ]] ||
     [[ -z "${IMAPSYNC_PASSWORD2}" ]] ||
     [[ -z "${IMAPSYNC_USER1}" ]] ||
     [[ -z "${IMAPSYNC_USER2}" ]] ||
     [[ -z "${IMAPSYNC_OAUTH_ACCESS_TOKEN1}" ]]; then
    echo "At least one of IMAPSYNC_HOST2, IMAPSYNC_PASSWORD2, IMAPSYNC_USER1, IMAPSYNC_USER2, IMAPSYNC_OAUTH_ACCESS_TOKEN1 are not set"
    exit 1
  fi
  imapsync_args+=( '--gmail1' '--user1' "${IMAPSYNC_USER1}" )
  imapsync_args+=( '--oauthaccesstoken1' "${IMAPSYNC_OAUTH_ACCESS_TOKEN1}" )
  imapsync_args+=( '--password1' 'dummy' )
  imapsync_args+=( '--host2' "${IMAPSYNC_HOST2}" '--user2' "${IMAPSYNC_USER2}" )
  imapsync_args+=( '--password2' "${IMAPSYNC_PASSWORD2}" )
  imapsync_args+=( '--nolog' )
fi


/usr/local/bin/imapsync ${imapsync_args[@]}
