FROM amazon/aws-cli:latest@sha256:f2a8ba78f4d4d34ad0ca1fb0a0ad814bca123294d7f4b36740ccbcfb48d66c23 AS awscli
FROM debian:bullseye@sha256:2ce44bbc00a79113c296d9d25524e15d423b23303fdbbe20190d2f96e0aeb251 AS base

# github metadata
LABEL org.opencontainers.image.source=https://github.com/plockaby/docker-debug

# install common tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends time openssl gnutls-bin zip unzip bzip2 lynx vim vim-scripts curl whois telnet sqlite3 strace lsof less traceroute bash-completion socat busybox dnsutils net-tools tcpdump wget iputils-ping fping iproute2 ca-certificates nmap netcat-openbsd postgresql-client groff && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# copy the aws cli over
COPY --from=awscli /usr/local/aws-cli /usr/local/aws-cli
RUN ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws && \
    ln -s /usr/local/aws-cli/v2/current/bin/aws_completer /usr/local/bin/aws_completer


COPY /entrypoint /
RUN chmod +x /entrypoint

ENTRYPOINT ["/entrypoint"]
