FROM google/cloud-sdk

ADD start.sh /
RUN chmod +x start.sh

ENTRYPOINT /start.sh
CMD ["bash"]
