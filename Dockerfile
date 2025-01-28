FROM ubuntu:18.04

COPY LICENSE README.md /

RUN apt-get update && apt-get install -y \
  clang-format-8 \
  curl \
  git \
  wget \
  && cd /usr/bin && ln -s clang-format-8 clang-format

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
