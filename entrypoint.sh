#!/bin/bash

for var in SYNC_DEST SYNC_PW SYNC_SOURCE SYNC_TOKEN SYNC_USER; do
    if [[ -z "${!var}" ]]; then
        missing+=( "$var" )
    fi
done

if [[ ${#missing[@]} -ne 0 ]]; then
    echo "Error: the following variables are not set: ${missing[*]}" >&2
    exit 1
fi

declare -a imapsync_args=()

# flags taken from https://wiki.sunet.se/display/SDO/Sunet+Drive+Mail

if [[ ${SYNC_DEST} == "m365" ]]; then
    imapsync_args+=( "--user1" "${SYNC_USER}" )
    imapsync_args+=( "--host1" "${SYNC_SOURCE_ADDRESS:-mail.sunet.se}" )
    imapsync_args+=( "--password1" "${SYNC_PW}" )
    imapsync_args+=( "--office2" )
    imapsync_args+=( "--user2" "${SYNC_USER}" )
    imapsync_args+=( "--oauthaccesstoken2" "${SYNC_TOKEN}" )
    imapsync_args+=( "--password2" "dummy" )
    imapsync_args+=( "--automap" )
    imapsync_args+=( "--addheader" )
    imapsync_args+=( "--skipcrossduplicates" )
    imapsync_args+=( "--disarmreadreceipts" )
    imapsync_args+=( "--delete2" )
    imapsync_args+=( "--regexflag" 's/\$MDNSent//g' )
    # dry for now, remove after testing
    imapsync_args+=( "--dry" )
elif [[ ${SYNC_SOURCE} == "m365" ]]; then
    imapsync_args+=( "--office1" )
    imapsync_args+=( "--user1" "${SYNC_USER}" )
    imapsync_args+=( "--oauthaccesstoken1" "${SYNC_TOKEN}" )
    imapsync_args+=( "--password1" "dummy" )
    imapsync_args+=( "--user2" "${SYNC_USER}" )
    imapsync_args+=( "--host2" "${SYNC_DESTINATION_ADDRESS:-mail.sunet.se}" )
    imapsync_args+=( "--password2" "${SYNC_PW}" )
    imapsync_args+=( "--automap" )
    imapsync_args+=( "--addheader" )
    imapsync_args+=( "--skipcrossduplicates" )
    imapsync_args+=( "--disarmreadreceipts" )
    imapsync_args+=( "--delete2" )
    imapsync_args+=( "--exclude" "Calendar|Contacts|dovecot|Conversation History|Tasks|Notes" )
    imapsync_args+=( "--regexflag" 's/\$MDNSent//g' )
    imapsync_args+=( "--regexflag" 's/\\Flagged//g' )
    imapsync_args+=( "--regexmess" "s/\[Du f=C3=A5r inte ofta e-post fr=C3=A5n.*//" )
    # dry for now, remove after testing
    imapsync_args+=( "--dry" )
else
    echo "Error: only to or from m365 supported"
    exit 1
fi

/usr/local/bin/imapsync "${imapsync_args[@]}"
