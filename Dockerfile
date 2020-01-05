FROM ubuntu:18.04

COPY LICENSE README.md /

RUN apt-get update && apt-get install -y \
  clang-format-8 \
  git \
  wget \
  && cd /usr/bin && ln -s clang-format-8 clang-format

RUN wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/master/Utilities/Maintenance/clang-format.bash \
  && chmod +x ./clang-format.bash

RUN wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/master/.clang-format \
  && mv ./.clang-format /ITK.clang-format

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
