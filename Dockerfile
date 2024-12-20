FROM ubuntu:24.04

COPY LICENSE README.md /

RUN apt-get update && apt-get install -y \
  clang-format-18 \
  git \
  wget \
  && apt-get clean \
  && cd /usr/bin && ln -s clang-format-8 clang-format

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
