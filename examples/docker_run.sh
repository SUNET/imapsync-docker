#!/bin/bash

docker run \
  -e IMAPSYNC_MODE='from_gmail' \
  -e IMAPSYNC_USER1='user@example.com' \
  -e IMAPSYNC_OAUTH_ACCESS_TOKEN1='verylongaccesstokenhere' \
  -e IMAPSYNC_HOST2='mail.example.com' \
  -e IMAPSYNC_USER2='user@example.com' \
  -e IMAPSYNC_PASSWORD2='verysecretpassword' \
  docker.sunet.se/mail/imapsync:2.229-1


