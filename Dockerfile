FROM archlinux:latest

# TEMP-FIX for pacman issue
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst \
    && curl -LO "https://raw.githubusercontent.com/sickcodes/Docker-OSX/master/${patched_glibc}" \
    && bsdtar -C / -xvf "${patched_glibc}" || echo "Everything is fine." \
# TEMP-FIX for pacman issue
    pacman -Syyu --noconfirm --noprogressbar && \
    pacman -S --noconfirm --needed --noprogressbar \
    base-devel \
    git \
    htop \
    wget \
# TEMP-FIX for pacman issue
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst \
    && curl -LO "https://raw.githubusercontent.com/sickcodes/Docker-OSX/master/${patched_glibc}" \
    && bsdtar -C / -xvf "${patched_glibc}" || echo "Everything is fine." \
# TEMP-FIX for pacman issue
&&echo "root:root" | chpasswd \
&& groupadd --system sudo \
&& useradd -m --groups sudo user \
&& sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
&& su - user -c "cd /home/user \
&& git clone https://aur.archlinux.org/yay-bin.git" \
&& su - user -c "cd /home/user/yay-bin && makepkg -s" \
&& cd /home/user/yay-bin && pacman -U yay-*.tar.zst --noconfirm \
&& rm -rf /home/user/yay-bin \
&& echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
&& echo "LANG=en_US.UTF-8" > /etc/locale.conf \
&& rm -rf /var/cache/pacman/pkg/* \
&& rm -rf /home/user/.cache \
&& locale-gen en_US.UTF-8
ENV LC_CTYPE 'en_US.UTF-8'

USER user
