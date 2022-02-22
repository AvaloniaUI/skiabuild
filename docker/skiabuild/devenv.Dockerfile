FROM jameswalmsley/skiabuild:latest

RUN yum -y install sudo wget epel-release
RUN yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm && yum -y install git
RUN wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && cd /usr && tar xvfh /nvim*.tar.gz --strip-components=1 && rm /nvim*.tar.gz
