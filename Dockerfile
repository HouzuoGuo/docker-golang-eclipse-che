# Heavily inspired by https://github.com/eclipse/che-dockerfiles/blob/master/recipes/ubuntu_go/Dockerfile
FROM eclipse/stack-base:ubuntu

# Enable node.js 6.x LTS repository
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -

# Install development tools directly relevant to Eclipse Che
ENV DEBIAN_FRONTEND noninteractive
RUN sudo apt update
RUN sudo env DEBIAN_FRONTEND=noninteractive apt upgrade -q -y -f -m -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef
RUN sudo env DEBIAN_FRONTEND=noninteractive apt install -q -y -f -m -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef g++ gcc libc6-dev make nodejs

# Install a comprehensive selection of packages that makes a Go, Java, C, Python, Perl, Ruby development environment.
RUN sudo env DEBIAN_FRONTEND=noninteractive apt install -q -y -f -m -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef ansible ant apache2 apache2-utils apt-transport-https autoconf automake bash bison build-essential bzip2 caca-utils ca-certificates checkinstall chrony clang-6.0 clang-tools-6.0 cloc cmake cscope csh curl cvs dash dateutils debian-keyring diffutils dnsutils docker docker.io dpkg-dev expat ffmpeg file findutils finger fish flex g++ gawk gcc gdb gdbserver gfortran git git-core gnupg gradle graphicsmagick hostname htop id3v2 iftop imagemagick iotop iputils-ping irb jsonlint lftp libapache2-mod-php libatlas-base-dev libavcodec-dev libavformat-dev libbz2-dev libc6-dev libcaca0 libcurl4-openssl-dev libdb-dev libdc1394-22-dev libevent-dev libexpat1 libfaac-dev libffi-dev libgdbm-dev libgeoip-dev libglib2.0-dev libgphoto2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libgtk2.0-dev libibnetdisc-dev libjasper-dev libjpeg8-dev libjpeg-dev libkrb5-dev liblzma-dev libmagickcore-dev libmagickwand-dev libmp3lame-dev libmysqlclient-dev libncurses-dev libnet1-dev libopencore-amrnb-dev libopencore-amrwb-dev libopencv-dev libpcap-dev libperl-dev libpng12-dev libpng16-16 libpng-dev libpq-dev  libqt4-dev libreadline-dev libsqlite3-dev libssl-dev libswscale-dev libtbb-dev libtheora-dev libtiff5-dev libtiff-dev libtool libv4l-dev libvorbis-dev libwebp-dev libxine2-dev libxml2-dev libxslt1-dev libxslt-dev libxvidcore-dev libyaml-dev llvm-6.0-tools lsof lua5.3 make man-db manpages manpages-dev manpages-posix manpages-posix-dev maven moreutils mysql-client nano nasm netcat net-tools nginx nmap nmon nodejs ntpdate openjdk-8-doc openjdk-8-jdk-headless openjdk-9-doc openjdk-9-jdk-headless openssl patch patchutils perl perl-base perl-doc perl-modules php php-cgi php-cli php-curl php-dev php-dom php-gd php-json php-mbstring php-mcrypt php-mysql php-sqlite3 php-xml pkg-config postgresql-client procps psmisc python2.7 python3-dev python3-pip python3-venv python-dev python-matplotlib python-numpy python-pip python-software-properties python-virtualenv rsync ruby ruby-dev ruby-full rubygems screen software-properties-common sqlite3 strace subversion sudo tcpdump tcsh telnet tmux tomcat8 traceroute tree tzdata ubuntu-server ubuntu-standard unar unzip usbutils v4l-utils vim vlc wget whois wiggle x264 xz-utils yamllint yasm zip zlib1g zlib1g-dev zsh

# Install tmux compilation dependencies
RUN sudo env DEBIAN_FRONTEND=noninteractive apt install -q -y -f -m -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef libevent-dev libncurses-dev

# Remove unnecessary files
RUN sudo rm -rf /var/lib/apt/lists/*

# Download source and compile tmux
RUN wget -O tmux-2.7.tar.gz https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
RUN tar xvf tmux-2.7.tar.gz && cd tmux-2.7 && ./configure && make && sudo make install

# Remove tmux source
RUN rm -rf tmux*

# Set up tmux for improved terminal interaction
RUN echo "\
set -g default-terminal \"xterm-256color\"\n\
set -g history-limit 10000\n\
set-option -g repeat-time 250\n\
setw -g mode-keys vi\n\
set -g mouse off\n\
set-option -g status on\n\
set -g status-interval 5\n\
set -g status-justify centre\n\
set -g visual-activity on\n\
setw -g monitor-activity on\n\
# for iPad bluetooth keyboard\n\
bind-key -Troot å send-keys C-a\n\
bind-key -Troot ∫ send-keys C-b\n\
bind-key -Troot ç send-keys C-c\n\
bind-key -Troot ∂ send-keys C-d\n\
bind-key -Troot ´ send-keys C-e\n\
bind-key -Troot ƒ send-keys C-f\n\
bind-key -Troot © send-keys C-g\n\
bind-key -Troot ˙ send-keys C-h\n\
bind-key -Troot ˆ send-keys C-i\n\
bind-key -Troot ∆ send-keys C-j\n\
bind-key -Troot ˚ send-keys C-k\n\
bind-key -Troot ¬ send-keys C-l\n\
bind-key -Troot µ send-keys C-m\n\
bind-key -Troot ˜ send-keys C-n\n\
bind-key -Troot ø send-keys C-o\n\
bind-key -Troot π send-keys C-p\n\
bind-key -Troot œ send-keys C-q\n\
bind-key -Troot ® send-keys C-r\n\
bind-key -Troot ß send-keys C-s\n\
bind-key -Troot † send-keys C-t\n\
bind-key -Troot ¨ send-keys C-u\n\
bind-key -Troot √ send-keys C-v\n\
bind-key -Troot ∑ send-keys C-w\n\
bind-key -Troot ≈ send-keys C-x\n\
bind-key -Troot ¥ send-keys C-y\n\
bind-key -Troot Ω send-keys C-z\n\
" > ${HOME}/.tmux.conf

# Setup bash and fish for more convenient interaction
RUN echo "\
alias l='ls -lFh '\n\
alias g='grep -i -E '\n\
alias s='sudo '\n\
alias i='sudo systemctl '\n\
alias j='sudo journalctl '\n\
alias r='rsync -rvz '\n\
alias '..'='cd ..; '\n\
alias '...'='cd ...; '\n\
export EDITOR=vim\n\
export PAGER=less\n\
" >> ${HOME}/.bashrc

RUN mkdir -p ${HOME}/.config/fish
RUN echo "\
if status --is-interactive\n\
    set fish_greeting\n\
    function l\n\
        ls -lFh $argv\n\
    end\n\
    function g\n\
        grep -i -E $argv\n\
    end\n\
    function s\n\
        sudo $argv\n\
    end\n\
    function i\n\
        sudo systemctl $argv\n\
    end\n\
    function j\n\
        sudo journalctl $argv\n\
    end\n\
    function r\n\
        rsync -rvz $argv\n\
    end\n\
    set -gx EDITOR vim\n\
    set -gx PAGER less\n\
end\n\
" >> ${HOME}/.config/fish/config.fish

# Fix permission on newly created configuration files
RUN for file in "${HOME}/.config" "${HOME}/.bashrc"; do \
      sudo chgrp -R 0 ${file} && \
      sudo chmod -R g+rwX ${file}; \
    done

# Continue setting up Go development tools
ENV GOLANG_VERSION 1.10.3
ENV GOLANG_LS_VERSION="0.1.7"
ENV goRelArch linux-amd64
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz
ENV GOPATH /projects/.che
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN sudo curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && sudo tar -C /usr/local -xzf golang.tar.gz \
    && sudo rm golang.tar.gz && \
    sudo mkdir -p /projects/.che && \
    sudo chmod -R 777 /projects && \
    export GOPATH=/tmp/gopath && \
    go get -v github.com/nsf/gocode && \
    go get -v github.com/uudashr/gopkgs/cmd/gopkgs && \
    go get -v github.com/ramya-rao-a/go-outline && \
    go get -v github.com/acroca/go-symbols && \
    go get -v golang.org/x/tools/cmd/guru && \
    go get -v golang.org/x/tools/cmd/gorename && \
    go get -v github.com/fatih/gomodifytags && \
    go get -v github.com/haya14busa/goplay/cmd/goplay && \
    go get -v github.com/josharian/impl && \
    go get -v github.com/tylerb/gotype-live && \
    go get -v github.com/rogpeppe/godef && \
    go get -v golang.org/x/tools/cmd/godoc && \
    go get -v github.com/zmb3/gogetdoc && \
    go get -v golang.org/x/tools/cmd/goimports && \
    go get -v sourcegraph.com/sqs/goreturns && \
    go get -v github.com/golang/lint/golint && \
    go get -v github.com/cweill/gotests/... && \
    go get -v github.com/alecthomas/gometalinter && \
    go get -v honnef.co/go/tools/... && \
    go get -v github.com/sourcegraph/go-langserver && \
    go get -v github.com/derekparker/delve/cmd/dlv && \
    mkdir -p ${HOME}/che/ls-golang && \
    echo "unset SUDO\nif sudo -n true > /dev/null 2>&1; then\nexport SUDO="sudo"\nfi\n if [ ! -d "/projects/.che/src" ]; then\necho "Copying GO LS Deps"\n\${SUDO} mkdir -p /projects/.che\n \${SUDO} cp -R /tmp/gopath/* /projects/.che/\nfi" > ${HOME}/gopath.sh && \
    chmod +x ${HOME}/gopath.sh && \
    cd ${HOME}/che/ls-golang && \
    npm i go-language-server@${GOLANG_LS_VERSION} && \
    for f in "${HOME}/che" "${HOME}/.cache"; do \
        sudo chgrp -R 0 ${f} && \
        sudo chmod -R g+rwX ${f}; \
    done

EXPOSE 8080

CMD ${HOME}/gopath.sh & tail -f /dev/null
