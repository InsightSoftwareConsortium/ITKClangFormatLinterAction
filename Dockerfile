FROM ubuntu:18.04

COPY LICENSE README.md /

RUN apt-get update && apt-get install -y \
  clang-format-8 \
  curl \
  git \
  wget \
  && apt-get clean

# The following is a workaround to allow other scripts
# that were hard-coded to use the unversioned clang-format
# binary to continue to work.
RUN cd /usr/bin && ln -s clang-format-8 clang-format

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
