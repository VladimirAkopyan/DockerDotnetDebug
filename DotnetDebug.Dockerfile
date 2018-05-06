FROM microsoft/aspnetcore:2.0 AS base

# Install the SSHD server
RUN apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && mkdir -p /run/sshd \
  && echo "root:Docker!" | chpasswd
#Copy settings file. See elsewhere to find them. 
COPY sshd_config /etc/ssh/sshd_config

# Install Visual Studio Remote Debugger
RUN apt-get install zip unzip
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l ~/vsdbg
  
EXPOSE 2222
