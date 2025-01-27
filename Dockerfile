FROM ubuntu:24.04

COPY LICENSE README.md /

RUN apt-get update && apt-get install -y \
  git \
  wget \
  lsb-release \
  software-properties-common \
  gnupg \
  && apt-get clean

# Download latest .deb packages from llvm.
# See https://apt.llvm.org/ for instructions.
RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh 19 \
    && apt-get install -y clang-format-19 \
    && apt-get clean

# The following is a workaround to allow other scripts
# that were hard-coded to use the unversioned clang-format
# binary to continue to work.
RUN cd /usr/bin && rm -rf clang-format && ln -s clang-format-19 clang-format

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
