# Docker_IGV
Docker container based on Ubuntu 18.04 to run IGV 4.2.11

See Docker file for comments and Docker 
and https://hub.docker.com/r/jysgro/igv/
for full description.

# PURPOSE

Run `IGV` in a container. This came about when a Mac had Java 10 but IGV requires Java 8.

IGV: Integrative Genomics Viewer - Broad Institute
[https://software.broadinstitute.org/software/igv/](https://software.broadinstitute.org/software/igv/)

IGV version installed: `2.4.11`

Ubutu base used: `ubuntu:18.04`

# HOW TO RUN

Displaying the graphics from IGV requires `X11`, read below for Mac.   
Windows users *might* be able to replace `XQuartz` with `MobaXterm` (not tested) or another `X` software.

IGV will run in the Unix graphical environment `X11`. Below is a method I found online to accomplish this.
See **How to show X11 windows with Docker on Mac** by *Marc Reichelt* [https://bit.ly/2usa0bB](https://bit.ly/2usa0bB)

## Set-up:

* Install the latest XQuartz X11 server and run it
* Activate the option ‘Allow connections from network clients’ in XQuartz settings (menu: `Xquartz > Preferences...` and click on `Security` tab.)
* Crucial: Quit & restart XQuartz (to activate the setting)

Open a *Terminal* and run command: `xhost + 127.0.0.1` or create and run the following script:

```
#!/bin/bash

# allow access from localhost
xhost + 127.0.0.1
```

## Create Docker container and run IGV

To add shared volume add `-v` as shown below for a (blank) directory here called `dockershare` mapped onto the `/root` home directory on the container

```
docker run -it --rm -v /Users/$USER/dockershare:/root -e DISPLAY=docker.for.mac.localhost:0 jysgro/igv:igv:2.4.11 /bin/sh
```

This command will create the container with a shell. To start IGV simply issue the command: `igv &` and when done type `exit` to exit the container. 

Thank you to *Marc Reichelt* (link above) for the very informative blog that makes this easy. Here is the important remark from his blog:

*Notice the trick using docker.for.mac.localhost as display name. That’s a hostname that points to the host machine, so we don’t have to deal with changing IP addresses.*

Indeed when I check inside the container:

```
# printenv DISPLAY
docker.for.mac.localhost:0
# 
```

