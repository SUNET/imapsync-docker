FROM debian:bookworm

ARG imapsync_version="2.229"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt update && apt install -y  \
  ca-certificates                 \
  cpanminus                       \
  libauthen-ntlm-perl             \
  libcgi-pm-perl                  \
  libcrypt-openssl-rsa-perl       \
  libdata-uniqid-perl             \
  libencode-imaputf7-perl         \
  libfile-copy-recursive-perl     \
  libfile-tail-perl               \
  libhtml-parser-perl             \
  libio-socket-inet6-perl         \
  libio-socket-ssl-perl           \
  libio-tee-perl                  \
  libjson-webtoken-perl           \
  libmail-imapclient-perl         \
  libmodule-scandeps-perl         \
  libnet-server-perl              \
  libparse-recdescent-perl        \
  libproc-processtable-perl       \
  libreadonly-perl                \
  libregexp-common-perl           \
  libsys-meminfo-perl             \
  libterm-readkey-perl            \
  libtest-deep-perl               \
  libtest-mockobject-perl         \
  libtest-nowarnings-perl         \
  libtest-pod-perl                \
  libtest-warn-perl               \
  libunicode-string-perl          \
  liburi-perl                     \
  libwww-perl                     \
  make                            \
  procps                          \
  time                            \
  wget

RUN cpanm --test-only IO::Socket::SSL && cpanm  IO::Socket::SSL
RUN wget https://github.com/imapsync/imapsync/archive/refs/tags/imapsync-${imapsync_version}.tar.gz \
  && tar -xzf imapsync-${imapsync_version}.tar.gz \
  && mv imapsync-imapsync-${imapsync_version}/imapsync /usr/local/bin/
USER nobody:nogroup
ENV HOME /var/tmp/
WORKDIR /var/tmp/
ENTRYPOINT ["/entrypoint.sh"]
