###############################################################################$
# Arch Lunux

FROM archlinux/base

RUN pacman --noconfirm -Syu \
    openssh \
    git \
    gcc \
    make \
    pkgconf \
    jq

###############################################################################$
# systemd

RUN systemctl set-default multi-user.target

RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    sys-kernel-config.mount \
    \
    systemd-ask-password-console.path \
    systemd-ask-password-wall.path \
    \
    display-manager.service \
    getty@.service \
    systemd-logind.service \
    systemd-remount-fs.service \
    systemd-resolved.service \
    systemd-update-done.service \
    systemd-update-utmp.service \
    systemd-cryptsetup@.service \
    \
    system-systemd@cryptsetup.slice \
    \
    cryptsetup.target \
    getty.target \
    network.target \
    nss-lookup.target \
    network-online.target \
    graphical.target \
    remote-cryptsetup.target \
    remote-fs.target \
    swap.target \
    \
    shadow.timer \
    systemd-tmpfiles-clean.timer

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["/usr/lib/systemd/systemd"]


###############################################################################$
# Rust

ARG RUST_VERSION

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $RUST_VERSION -y

ENV PATH=/root/.cargo/bin:$PATH

RUN rustup component add rustfmt

RUN rustup component add clippy


###############################################################################$
# workdir

VOLUME /work

WORKDIR /work
