FROM ubuntu:18.04 as downloader

RUN apt update && \
    apt install curl gpg -y

RUN GPG_KEY="$(curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg')" && \
    GPG_FINGERPRINT="$(echo "$GPG_KEY" | gpg --with-colons --import-options show-only --import --fingerprint | awk -F: '$1 == "fpr" {print $10;}')" && \
    EXPECTED_FINGEPRINT="$(printf "74A5E9C458E1A431F1DA57A71657198823E52A61\n41CA9BC62B9FBDC669DB74225A4011580999FBE0")" && \
    [ "$EXPECTED_FINGEPRINT" = "$GPG_FINGERPRINT" ] && echo "$GPG_KEY" | gpg --import && \
    echo "$(curl -s 'https://install.zerotier.com/' | gpg)" > /zt-install.sh

FROM centos:7 as final

# Install jq to edit config files like "local.conf"
RUN yum update -y && \
    yum install -y epel-release jq

COPY --from=downloader /zt-install.sh /usr/bin/

RUN bash /usr/bin/zt-install.sh || [[ -x /usr/sbin/zerotier-one ]]

RUN yum clean all

VOLUME ["/var/lib/zerotier-one"]
CMD ["/usr/sbin/zerotier-one"]

