FROM debian:stretch

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# 1/ this forces dpkg not to call sync() after package extraction and speeds up install
# 2/ we don't need and apt cache in a container
# 3/ remove config files while removing apps
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    echo "APT::Get::Purge \"true\";" >> /etc/apt/apt.conf

# Upgrade system and install pre-requiresites
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        apt-transport-https \
        apt-utils \
        aptitude \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        htop \
        locate \
        openssh-server \
        pwgen \
        sshfs \
        synaptic \
        wget \
        software-properties-common

# Declare x2go repository, then install LXDE ( + base apps : Firefox, Gimp, LibreOffice & Thunderbird ) & x2go
RUN apt-key adv --recv-keys --keyserver keys.gnupg.net E1F958385BFE2B6E && \
    echo "# X2Go Repository (release builds)" > /etc/apt/sources.list.d/x2go.list && \
    echo "deb http://packages.x2go.org/debian stretch main" >> /etc/apt/sources.list.d/x2go.list && \
    echo "# X2Go Repository (sources of release builds)" >> /etc/apt/sources.list.d/x2go.list && \
    echo "deb-src http://packages.x2go.org/debian stretch main" >> /etc/apt/sources.list.d/x2go.list && \
    apt-get update && \
    apt-get install -y \
        lxde \
        firefox-esr \
        gimp \
        libreoffice \
        libreoffice-l10n-fr \
        libreoffice-evolution \
        libreoffice-help-en-us \
        libreoffice-help-fr \
        hunspell-en-us \
        hyphen-en-us \
        hyphen-fr \
        myspell-fr-gut \
        mythes-en-us \
        mythes-fr \
        thunderbird \
        thunderbird-l10n-fr \
        mail-notification \
        x2goserver \
        x2goserver-xsession

# Update sshd settings
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication/PasswordAuthentication/g" /etc/ssh/sshd_config

# Make some cleaning
RUN apt-get autoclean &&\
    apt-get clean && \
    apt-get autoremove && \
    dpkg -P $(dpkg -l | awk '$1~/^rc$/{print $2}') && \
    rm -rf /tmp/*

RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

ADD first_run.sh /first_run.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 22

CMD ["/run.sh"]
