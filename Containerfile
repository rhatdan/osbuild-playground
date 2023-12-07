FROM quay.io/centos-bootc/fedora-bootc:eln
COPY root.keys /usr/etc-system/root.keys
RUN touch /etc/ssh/sshd_config.d/30-auth-system.conf; \
    mkdir -p /usr/etc-system/; \
    echo 'AuthorizedKeysFile /usr/etc-system/%u.keys' >> /etc/ssh/sshd_config.d/30-auth-system.conf; \
    chmod 0600 /usr/etc-system/root.keys
VOLUME /var/roothome
RUN dnf -y install httpd; dnf -y clean all
COPY storage.conf /etc/containers/storage.conf
RUN podman --root=/usr/lib/containers/storage pull $IMAGE
RUN podman images
RUN --mount=type=tmpfs,destination=/var ostree container commit
