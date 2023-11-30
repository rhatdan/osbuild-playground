FROM quay.io/centos-boot/fedora-tier-1:eln
COPY root.keys /usr/etc-system/root.keys
RUN mkdir -p /usr/etc-system/; \
    echo 'AuthorizedKeysFile /usr/etc-system/%u.keys' >> /etc/ssh/sshd_config.d/30-auth-system.conf; \
    chmod 0600 /usr/etc-system/root.keys
RUN dnf -y install httpd; dnf -y clean all
RUN --mount=type=tmpfs,destination=/var ostree container commit
