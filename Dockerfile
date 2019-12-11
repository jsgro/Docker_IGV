################################################################################################
#
# MODIFY DOCKER FILE FROM https://hub.docker.com/r/thephilross/igv/~/dockerfile/
# Philipp Ross, philippross369@gmail.com
################################################################################################
#
# ALSO SEE https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb
# IMPORTANT STEPS:
#
# To get the pygame running on my Mac, I had to do a few things:
# 
# - Install the latest XQuartz X11 server and run it
# - Activate the option ‘Allow connections from network clients’ in XQuartz settings
# - Quit & restart XQuartz (to activate the setting)
# 
#!/bin/bash
# 
# allow access from localhost
# xhost + 127.0.0.1
# 
# run firefox with X11 forwarding and keep running until it quits
# docker run -e DISPLAY=docker.for.mac.localhost:0 jess/firefox
#
################################################################################################
#
# Allow connections from network clients - SEE ABOVE.
# xhost + 127.0.0.1
# docker run -e DISPLAY=docker.for.mac.localhost:0 igv:2.4.11  # OR [USERNAME]/igv:2.4.11 
#

FROM ubuntu:18.04

LABEL maintener="Jean-Yves Sgro<jsgro@wisc.edu>" 

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	software-properties-common \
	wget \
	unzip \
	glib-networking-common\
        libxrender1 \
        libxtst6 \
        libxi6

# BELOW RUN COMMANDS FROM https://hub.docker.com/r/relateiq/oracle-java8/~/dockerfile/
#
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && apt-get update && apt-get install -y curl dnsutils oracle-java8-installer ca-certificates

# DUE TO ERROR: java.lang.UnsatisfiedLinkError: /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libawt_xawt.so: libXext.so.6: cannot open shared object file: No such file or directory
# SOLUTION: https://askubuntu.com/questions/674579/libawt-xawt-so-libxext-so-6-cannot-open-shared-object-file-no-such-file-or-di
# ADD THE FOLLOWING:
#
# RUN apt-get install libxrender1 libxtst6 libxi6
# ADDED ABOVE INSTEAD

# Update IGV version to 2.4.11
# The SED command will not do anything now as the default is now 4000 rather than 2000
# For now keep at 4000 but keep command in place for future use and reference

RUN mkdir -p /igv && \
	cd /igv && \
	wget http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.11.zip && \
	unzip IGV_2.4.11.zip && \
	cd IGV_2.4.11/ && \
	sed -i 's/Xmx2000/Xmx8000/g' igv.sh && \
	cd /usr/bin && \
	ln -s /igv/IGV_2.4.11/igv.sh ./igv

CMD ["/usr/bin/igv"]

