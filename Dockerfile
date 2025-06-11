FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  build-essential \
  gcc-mipsel-linux-gnu g++-mipsel-linux-gnu \
  make git wget ca-certificates \
  python3 \
  && apt clean

WORKDIR /build

COPY build_core.sh /build/build_core.sh
RUN chmod +x /build/build_core.sh

CMD ["/bin/bash"]
