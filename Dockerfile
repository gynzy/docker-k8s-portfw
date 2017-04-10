FROM google/cloud-sdk

RUN /google-cloud-sdk/bin/gcloud components update

ADD start.sh /
RUN chmod +x start.sh

ENTRYPOINT /start.sh
CMD ["bash"]
