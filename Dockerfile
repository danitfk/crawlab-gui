FROM ubuntu:18.04
RUN echo "Europe/Warsaw" > /etc/timezone
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends wget curl rsync netcat mg vim bzip2 zip unzip && \
    apt-get install -y --no-install-recommends libx11-6 libxcb1 libxau6 && \
    apt-get install -y --no-install-recommends lxde tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python-pip python-dev python-qt4 && \
    apt-get install -y --no-install-recommends libssl-dev && \
    apt-get install -y --no-install-recommends fonts-liberation libappindicator3-1 libauthen-sasl-perl libdata-dump-perl libdbusmenu-glib4 libdbusmenu-gtk3-4 libencode-locale-perl libfile-basedir-perl libfile-desktopentry-perl libfile-listing-perl libfile-mimeinfo-perl libfont-afm-perl libgbm1 libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libindicator3-7 libio-html-perl libio-socket-ssl-perl libipc-system-simple-perl liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libnet-dbus-perl libnet-http-perl libnet-smtp-ssl-perl libnet-ssleay-perl libnspr4 libnss3 libtext-iconv-perl libtie-ixhash-perl libtimedate-perl libtry-tiny-perl liburi-perl libwayland-server0 libwww-perl libwww-robotrules-perl libx11-protocol-perl xdg-utils

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb && dpkg -i /tmp/google-chrome-stable_current_amd64.deb && rm -rf /tmp/google-chrome-stable_current_amd64.deb


RUN echo "mycontainer" > /etc/hostname
RUN echo "127.0.0.1     localhost" > /etc/hosts
RUN echo "127.0.0.1     mycontainer" >> /etc/hosts

RUN useradd crawlab
RUN mkdir /home/crawlab && chown -R crawlab:crawlab /home/crawlab
RUN apt-get update && apt-get install -y sudo && \
    adduser crawlab sudo
RUN /bin/bash -c "echo -e 'crawlab     ALL=(ALL) NOPASSWD:ALL'" >> /etc/sudoers


USER crawlab
RUN mkdir -p /home/crawlab/.vnc
COPY xstartup /home/crawlab/.vnc/
RUN sudo chown crawlab:crawlab /home/crawlab/.vnc/xstartup && chmod a+x /home/crawlab/.vnc/xstartup
RUN touch /home/crawlab/.vnc/passwd
RUN /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" > /home/crawlab/.vnc/passwd
RUN sudo chmod 400 /home/crawlab/.vnc/passwd
RUN sudo chmod go-rwx /home/crawlab/.vnc
RUN touch /home/crawlab/.Xauthority
COPY start-vncserver.sh /home/crawlab/
RUN sudo chown crawlab:crawlab /home/crawlab/start-vncserver.sh && chmod +x /home/crawlab/start-vncserver.sh

ENV USER crawlab

CMD [ "/home/crawlab/start-vncserver.sh" ]
