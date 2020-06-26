FROM tikazyq/crawlab:latest
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
    apt-get install -y --no-install-recommends libssl-dev && \
    apt-get install -y --no-install-recommends fonts-liberation libappindicator3-1 libauthen-sasl-perl libdata-dump-perl libdbusmenu-glib4 libdbusmenu-gtk3-4 libencode-locale-perl libfile-basedir-perl libfile-desktopentry-perl libfile-listing-perl libfile-mimeinfo-perl libfont-afm-perl libgbm1 libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libindicator3-7 libio-html-perl libio-socket-ssl-perl libipc-system-simple-perl liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libnet-dbus-perl libnet-http-perl libnet-smtp-ssl-perl libnet-ssleay-perl libnspr4 libnss3 libtext-iconv-perl libtie-ixhash-perl libtimedate-perl libtry-tiny-perl liburi-perl libwayland-server0 libwww-perl libwww-robotrules-perl libx11-protocol-perl xdg-utils python3-pygame python3-apt libcairo2-dev python3-libtorrent command-not-found ubuntu-advantage-tools youtube-dl python3-cupshelpers python3-cups libpq-dev libgirepository1.0-dev python3-systemd
RUN pip3 install blinker colorama configobj csvkit dbus-python defer deluge distro distro-info entrypoints get httplib2 keyring  launchpadlib lazr.restfulclient lazr.uri macaroonbakery Mako MarkupSafe netifaces numpy oauthlib olefile phantomjs Pillow post protobuf psycopg2 public pycairo pycups pygame PyGObject PyJWT pymacaroons PyNaCl pyRFC3339 pyserial python-apt python-debian python-libtorrent pyxattr pyxdg PyYAML query-string rencode request scrapy-crawlera SecretStorage selenium setproctitle simplejson ssh-import-id systemd-python wadllib

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb && dpkg -i /tmp/google-chrome-stable_current_amd64.deb && rm -rf /tmp/google-chrome-stable_current_amd64.deb
RUN sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --no-sandbox|g' /usr/share/applications/google-chrome.desktop

RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/
RUN chmod a+x /root/.vnc/xstartup
RUN touch /root/.vnc/passwd
RUN /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" > /root/.vnc/passwd
RUN chmod 400 /root/.vnc/passwd
RUN chmod go-rwx /root/.vnc
RUN touch /root/.Xauthority
COPY start-vncserver.sh /root/
RUN chmod +x /root/start-vncserver.sh

EXPOSE 5901
EXPOSE 8000
CMD [ "/root/start-vncserver.sh" ]
