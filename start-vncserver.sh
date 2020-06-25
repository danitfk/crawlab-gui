#!/bin/bash

echo "starting VNC server ..."
export USER=crawlab
vncserver :1 -geometry 1280x800 -depth 24 && tail -F /home/crawlab/.vnc/*.log
