FROM google/cloud-sdk

ADD start.sh /

ENTRYPOINT start.sh
